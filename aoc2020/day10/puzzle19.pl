:- use_module(library(clpfd)).
:- use_module(library(pio)).
:- set_prolog_flag(double_quotes,codes).

all_chars([Head]) --> [Head], {[Head] \= "\n", [Head] \= " "}.
all_chars([Head|Tail]) --> [Head], {[Head] \= "\n", [Head] \= " "}, all_chars(Tail).
parse([Line|Tail]) --> all_chars(Line), "\n", parse(Tail).
parse([]) --> [].

jolt_differences(_, [], Ones, Threes, Result) :- Result #= (Threes + 1) * Ones.
jolt_differences(X, [Head|Tail], Ones, Threes, Result) :-
    Head - X #= 2,
    jolt_differences(Head, Tail, Ones, Threes, Result).
jolt_differences(X, [Head|Tail], Ones, Threes, Result) :-
    Head - X #= 3,
    ThreesNew = Threes + 1,
    jolt_differences(Head, Tail, Ones, ThreesNew, Result).
jolt_differences(X, [Head|Tail], Ones, Threes, Result) :-
    Head - X #= 1,
    OnesNew = Ones + 1,
    jolt_differences(Head, Tail, OnesNew, Threes, Result).

solve(ListOfNumbersAsStrings, Result) :-
    maplist(number_codes, ListOfNumbers, ListOfNumbersAsStrings),
    sort(ListOfNumbers, SortedList),
    jolt_differences(0, SortedList, 0, 0, Result).

main :-
    phrase_from_file(parse(Data), "input"),
    solve(Data, Result),
    writeln(Result).