:- use_module(library(clpfd)).
:- use_module(library(pio)).
:- set_prolog_flag(double_quotes,codes).

all_chars([H]) --> [H], {[H] \= "\n", [H] \= " "}.
all_chars([H|T]) --> [H], {[H] \= "\n", [H] \= " "}, all_chars(T).
parse([X|T]) --> all_chars(X), "\n", parse(T).
parse([]) --> [].

jolt_differences(_, [], Ones, Threes, Result) :- Result #= (Threes + 1) * Ones.
jolt_differences(X, [H|T], Ones, Threes, Result) :-
    H - X #= 2,
    jolt_differences(H, T, Ones, Threes, Result).
jolt_differences(X, [H|T], Ones, Threes, Result) :-
    H - X #= 3,
    ThreesNew = Threes + 1,
    jolt_differences(H, T, Ones, ThreesNew, Result).
jolt_differences(X, [H|T], Ones, Threes, Result) :-
    H - X #= 1,
    OnesNew = Ones + 1,
    jolt_differences(H, T, OnesNew, Threes, Result).

solve(L, Result) :-
    maplist(number_codes, L2, L),
    sort(L2, Sorted),
    jolt_differences(0, Sorted, 0, 0, Result).

main :-
    phrase_from_file(parse(D), "input"),
    solve(D, Result),
    writeln(Result).