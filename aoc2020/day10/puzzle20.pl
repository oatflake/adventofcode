:- use_module(library(clpfd)).
:- use_module(library(pio)).
:- set_prolog_flag(double_quotes,codes).

all_chars([H]) --> [H], {[H] \= "\n", [H] \= " "}.
all_chars([H|T]) --> [H], {[H] \= "\n", [H] \= " "}, all_chars(T).
parse([X|T]) --> all_chars(X), "\n", parse(T).
parse([]) --> [].

:- table arrangements/2.
arrangements([_,_], 1).
arrangements([A, B, C|T], N) :-
    ( C - A #< 4 -> arrangements([A, C|T], S1) ; S1 #= 0 ),
    arrangements([B, C|T], S2),
    N #= S1 + S2.

solve(L, Result) :-
    maplist(number_codes, L2, L),
    max_list(L2, Max),
    Last #= Max + 3,
    sort([0, Last|L2], Sorted),
    arrangements(Sorted, Result).

main :-
    phrase_from_file(parse(D), "input"),
    solve(D, Result),
    writeln(Result).