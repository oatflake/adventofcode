:- use_module(library(pio)).
:- use_module(library(clpfd)).
:- set_prolog_flag(double_quotes,codes).

:- dynamic cell/3.

all_chars([]) --> [].
all_chars([H|T]) --> [H], all_chars(T).
parse([]) --> [].
parse([X|T]) -->
     all_chars(X),
     "\n",
     parse(T).

assertCells([], _, _).
assertCells([H|T], X, Y) :-
     assert(cell(H, X, Y)),
     X1 #= X + 1,
     assertCells(T, X1, Y).

assertData([], _).
assertData([L|T], Y) :-
     assertCells(L, 0, Y),
     Y1 #= Y + 1,
     assertData(T, Y1).

countTrees(_, Y, 0, _, Height, _, _) :- Y #>= Height.
countTrees(X, Y, N, Width, Height, DX, DY) :-
    cell(46, X, Y),
    X1 #= (X + DX) mod Width,
    Y1 #= Y + DY,
    countTrees(X1, Y1, N, Width, Height, DX, DY).
countTrees(X, Y, N, Width, Height, DX, DY) :-
    cell(35, X, Y),
    N #= N1 + 1,
    X1 #= (X + DX) mod Width,
    Y1 #= Y + DY,
    countTrees(X1, Y1, N1, Width, Height, DX, DY).

main :-
    retractall(cell(_, _, _)),
    phrase_from_file(parse([H|T]), "input"),
    assertData([H|T], 0),
    length(H, Width),
    length([H|T], Height),
    countTrees(0, 0, N1, Width, Height, 1, 1),
    countTrees(0, 0, N2, Width, Height, 3, 1),
    countTrees(0, 0, N3, Width, Height, 5, 1),
    countTrees(0, 0, N4, Width, Height, 7, 1),
    countTrees(0, 0, N5, Width, Height, 1, 2),
    N #= N1 * N2 * N3 * N4 * N5,
    writeln(N).
