:- use_module(library(clpfd)).
:- use_module(library(pio)).
:- set_prolog_flag(double_quotes,codes).

all_chars([H]) --> [H], {[H] \= "\n"}.
all_chars([H|T]) --> [H], {[H] \= "\n"}, all_chars(T).
cards([H]) --> all_chars(H), "\n".
cards([H|T]) --> all_chars(H), "\n", cards(T).
deck(C) --> all_chars(_), "\n", cards(C).
parse([P1, P2]) --> deck(P1), "\n", deck(P2).

play([], D2, [], D2).
play(D1, [], D1, []).
play([H1|T1], [H2|T2], D1new, D2new) :-
    H1 #> H2,
    append(T1, [H1, H2], E1),
    play(E1, T2, D1new, D2new).
play([H1|T1], [H2|T2], D1new, D2new) :-
    H1 #< H2,
    append(T2, [H2, H1], E2),
    play(T1, E2, D1new, D2new).

score([H], 1, H).
score([H|T], N, Score) :-
    N1 #= N - 1,
    score(T, N1, S),
    Score #= S + H * N.

solve(D1, D2, Result) :- 
    play(D1, D2, D1new, D2new),
    (D1new = [] -> score(D2new, _, Result) ; score(D1new, _, Result)).

main :-
    phrase_from_file(parse([P1, P2]), "input"),
    maplist(number_codes, D1, P1),
    maplist(number_codes, D2, P2),
    solve(D1, D2, Result),
    writeln(Result).