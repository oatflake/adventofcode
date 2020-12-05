:- use_module(library(pio)).
:- use_module(library(clpfd)).
:- set_prolog_flag(double_quotes,codes).

:- dynamic seat/1.

all_chars([]) --> [].
all_chars([H|T]) --> [H], {[H] \= "\n"}, all_chars(T).
parse([A|L]) --> all_chars(A), "\n", parse(L).
parse([A]) --> all_chars(A), "\n".

printSeats([]).
printSeats([H|T]) :- atom_codes(S, H), writeln(S), printSeats(T).

assertData([]).
assertData([H|T]) :- assert(seat(H)), assertData(T).

binSearch([], _, _, Min, Max, X) :- X #= (Max + Min) // 2.
binSearch([Low|T], Low, High, Min, Max, X) :-
    Mid #= (Max + Min) // 2,
    binSearch(T, Low, High, Min, Mid, X).
binSearch([High|T], Low, High, Min, Max, X) :-
    Mid #= (Max + Min) // 2 + 1,
    binSearch(T, Low, High, Mid, Max, X).

id(Seat, I) :-
    length(Second, 3),
    append(First, Second, Seat),
    binSearch(First, 70, 66, 0, 127, X),
    binSearch(Second, 76, 82, 0, 7, Y),
    I #= X * 8 + Y.

notHighestID(I) :- seat(S), id(S, J), J #> I.

maxID(I) :- seat(S), id(S, I), \+ notHighestID(I).

main :-
    retractall(seat(_)),
    phrase_from_file(parse(L), "input"),
    assertData(L),
    %printSeats(L),
    maxID(I),
    writeln(I).
