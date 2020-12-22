% works on small input, but crashes for real input. resorting to using python again...

:- use_module(library(clpfd)).
:- use_module(library(pio)).
:- set_prolog_flag(double_quotes,codes).
:- use_module(library(rbtrees)).

all_chars([H]) --> [H], {[H] \= "\n"}.
all_chars([H|T]) --> [H], {[H] \= "\n"}, all_chars(T).
cards([H]) --> all_chars(H), "\n".
cards([H|T]) --> all_chars(H), "\n", cards(T).
deck(C) --> all_chars(_), "\n", cards(C).
parse([P1, P2]) --> deck(P1), "\n", deck(P2).

:- table play/5.

play(_, [], D2, [], D2).
play(_, D1, [], D1, []).
play(History, [H1|T1], [H2|T2], D1new, D2new) :-
    (\+ member(([H1|T1], [H2|T2]), History) -> (
        NewHistory = [([H1|T1], [H2|T2])|History],
        length(T1, N1),
        length(T2, N2),
        H1 #=< N1,
        H2 #=< N2,
        length(L1, H1),
        length(L2, H2),
        append(L1, _, T1),
        append(L2, _, T2),
        TmpHistory = [],
        play(TmpHistory, L1, L2, _, R2),
        (R2 = [] -> 
        append(T1, [H1, H2], E1),
        play(NewHistory, E1, T2, D1new, D2new);
        append(T2, [H2, H1], E2),
        play(NewHistory, T1, E2, D1new, D2new))
    );
        (D1new = [H1|T1], D2new = [])
    ).

play(History, [H1|T1], [H2|T2], D1new, D2new) :-
    (\+ member(([H1|T1], [H2|T2]), History) -> (
    NewHistory = [([H1|T1], [H2|T2])|History],
    length(T1, N1),
    length(T2, N2),
    (H1 #> N1 ; H2 #> N2),
    H1 #> H2,
    append(T1, [H1, H2], E1),
    play(NewHistory, E1, T2, D1new, D2new)
    );
        (D1new = [H1|T1], D2new = [])
    ).
play(History, [H1|T1], [H2|T2], D1new, D2new) :-
    (\+ member(([H1|T1], [H2|T2]), History) -> (
    NewHistory = [([H1|T1], [H2|T2])|History],
    length(T1, N1),
    length(T2, N2),
    (H1 #> N1;H2 #> N2),
    H1 #< H2,
    append(T2, [H2, H1], E2),
    play(NewHistory, T1, E2, D1new, D2new)
    );
        (D1new = [H1|T1], D2new = [])
    ).

score([H], 1, H).
score([H|T], N, Score) :-
    N1 #= N - 1,
    score(T, N1, S),
    Score #= S + H * N.

solve(D1, D2, Result) :- 
    History = [],
    play(History, D1, D2, D1new, D2new), !, 
    (D1new = [] -> score(D2new, _, Result) ; score(D1new, _, Result)).

main :-
    phrase_from_file(parse([P1, P2]), "input"),
    maplist(number_codes, D1, P1),
    maplist(number_codes, D2, P2),
    solve(D1, D2, Result),
    writeln(Result).