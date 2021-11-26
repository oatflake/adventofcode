:- use_module(library(clpfd)).
:- use_module(library(pio)).
:- set_prolog_flag(double_quotes,codes).

all_chars([Head]) --> [Head], {[Head] \= "\n", [Head] \= " "}.
all_chars([Head|Tail]) --> [Head], {[Head] \= "\n", [Head] \= " "}, all_chars(Tail).
parse([Line|Tail]) --> all_chars(Line), "\n", parse(Tail).
parse([]) --> [].

:- table arrangements/2.
arrangements([_,_], 1).
arrangements([First, Second, Third|Tail], Result) :-
    ( Third - First #< 4 -> arrangements([First, Third|Tail], Sum1) ; Sum1 #= 0 ),
    arrangements([Second, Third|Tail], Sum2),
    Result #= Sum1 + Sum2.

solve(ListOfNumbersAsStrings, Result) :-
    maplist(number_codes, ListOfNumbers, ListOfNumbersAsStrings),
    max_list(ListOfNumbers, Max),
    Last #= Max + 3,
    sort([0, Last|ListOfNumbers], Sorted),
    arrangements(Sorted, Result).

main :-
    phrase_from_file(parse(Data), "input"),
    solve(Data, Result),
    writeln(Result).