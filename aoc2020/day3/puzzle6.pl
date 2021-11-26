:- use_module(library(pio)).
:- use_module(library(clpfd)).
:- set_prolog_flag(double_quotes,codes).

% Char, XCoord, YCoord
:- dynamic cell/3.

all_chars([]) --> [].
all_chars([Head|Tail]) --> [Head], all_chars(Tail).
parse([]) --> [].
parse([Line|Tail]) -->
     all_chars(Line),
     "\n",
     parse(Tail).

assertCells([], _, _).
assertCells([Head|Tail], XCoord, YCoord) :-
     assert(cell(Head, XCoord, YCoord)),
     InceasedXCoord #= XCoord + 1,
     assertCells(Tail, InceasedXCoord, YCoord).

assertData([], _).
assertData([Line|Tail], YCoord) :-
     assertCells(Line, 0, YCoord),
     InceasedYCoord #= YCoord + 1,
     assertData(Tail, InceasedYCoord).

countTrees(_, Y, 0, _, Height, _, _) :- Y #>= Height.
countTrees(X, Y, NumberOfTrees, Width, Height, DX, DY) :-
    cell(46, X, Y),
    X1 #= (X + DX) mod Width,
    Y1 #= Y + DY,
    countTrees(X1, Y1, NumberOfTrees, Width, Height, DX, DY).
countTrees(X, Y, IncreasedNumberOfTrees, Width, Height, DX, DY) :-
    cell(35, X, Y),
    IncreasedNumberOfTrees #= NumberOfTrees + 1,
    X1 #= (X + DX) mod Width,
    Y1 #= Y + DY,
    countTrees(X1, Y1, NumberOfTrees, Width, Height, DX, DY).

main :-
    retractall(cell(_, _, _)),
    phrase_from_file(parse([FirstLine|Tail]), "input"),
    assertData([FirstLine|Tail], 0),
    length(FirstLine, Width),
    length([FirstLine|Tail], Height),
    countTrees(0, 0, N1, Width, Height, 1, 1),
    countTrees(0, 0, N2, Width, Height, 3, 1),
    countTrees(0, 0, N3, Width, Height, 5, 1),
    countTrees(0, 0, N4, Width, Height, 7, 1),
    countTrees(0, 0, N5, Width, Height, 1, 2),
    Result #= N1 * N2 * N3 * N4 * N5,
    writeln(Result).
