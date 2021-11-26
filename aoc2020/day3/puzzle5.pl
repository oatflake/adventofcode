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

countTrees(_, Y, 0, _, Height) :- Y #>= Height.
countTrees(X, Y, NumberOfTrees, Width, Height) :-
    cell(46, X, Y),     % 46 is no tree
    X1 #= (X + 3) mod Width,
    Y1 #= Y + 1,
    countTrees(X1, Y1, NumberOfTrees, Width, Height).
countTrees(X, Y, IncreasedNumberOfTrees, Width, Height) :-
    cell(35, X, Y),     % 35 is a tree
    IncreasedNumberOfTrees #= NumberOfTrees + 1,
    X1 #= (X + 3) mod Width,
    Y1 #= Y + 1,
    countTrees(X1, Y1, NumberOfTrees, Width, Height).

main :-
    retractall(cell(_, _, _)),
    phrase_from_file(parse([FirstLine|Tail]), "input"),
    assertData([FirstLine|Tail], 0),
    length(FirstLine, Width),
    length([FirstLine|Tail], Height),
    countTrees(0, 0, Result, Width, Height),
    writeln(Result).
