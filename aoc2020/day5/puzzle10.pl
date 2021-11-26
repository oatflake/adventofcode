:- use_module(library(pio)).
:- use_module(library(clpfd)).
:- set_prolog_flag(double_quotes,codes).

:- dynamic seat/1.

all_chars([]) --> [].
all_chars([Head|Tail]) --> [Head], {[Head] \= "\n"}, all_chars(Tail).
parse([Line|Tail]) --> all_chars(Line), "\n", parse(Tail).
parse([Line]) --> all_chars(Line), "\n".

printSeats([]).
printSeats([Head|Tail]) :- atom_codes(Seat, Head), writeln(Seat), printSeats(Tail).

assertData([]).
assertData([Head|Tail]) :- assert(seat(Head)), assertData(Tail).

binSearch([], _, _, Min, Max, X) :- X #= (Max + Min) // 2.
binSearch([Low|Tail], Low, High, Min, Max, X) :-
    Mid #= (Max + Min) // 2,
    binSearch(Tail, Low, High, Min, Mid, X).
binSearch([High|Tail], Low, High, Min, Max, X) :-
    Mid #= (Max + Min) // 2 + 1,
    binSearch(Tail, Low, High, Mid, Max, X).

id(Seat, ID) :-
    length(First, 7),
    length(Second, 3),
    append(First, Second, Seat),
    binSearch(First, 70, 66, 0, 127, X),
    binSearch(Second, 76, 82, 0, 7, Y),
    ID #= X * 8 + Y.

notHighestID(ID) :- seat(Seat), id(Seat, OtherID), OtherID #> ID.
maxID(ID) :- seat(Seat), id(Seat, ID), \+ notHighestID(ID).
notSmallestID(ID) :- seat(Seat), id(Seat, OtherID), OtherID #< ID.
minID(ID) :- seat(Seat), id(Seat, ID), \+ notSmallestID(ID).

main :-
    retractall(seat(_)),
    phrase_from_file(parse(Data), "input"),
    assertData(Data),
    %printSeats(Data),
    minID(Min),
    maxID(Max),
    Result #> Min,
    Result #< Max,
    id(Seat, Result),
    \+ seat(Seat),
    writeln(Result).
