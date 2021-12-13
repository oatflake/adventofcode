:- use_module(library(clpfd)).
:- use_module(library(pio)).
:- set_prolog_flag(double_quotes,codes).

all_chars([Head]) --> [Head], {[Head] \= "\n"}.
all_chars([Head|Tail]) --> [Head], {[Head] \= "\n"}, all_chars(Tail).
coords([(X, Y)]) --> all_chars(XString), ",", all_chars(YString), "\n", 
    {number_codes(X, XString), number_codes(Y, YString)}.
coords([(X, Y)|Tail]) --> all_chars(XString), ",", all_chars(YString), "\n", coords(Tail), 
    {number_codes(X, XString), number_codes(Y, YString)}.
folds([(Axis, Offset)]) --> "fold along ", all_chars(AxisString), "=", all_chars(OffsetString), "\n", 
    {atom_codes(Axis, AxisString), number_codes(Offset, OffsetString)}.
folds([(Axis, Offset)|Tail]) --> "fold along ", all_chars(AxisString), "=", all_chars(OffsetString), "\n", 
    {atom_codes(Axis, AxisString), number_codes(Offset, OffsetString)},folds(Tail).
parse((Coords, Folds)) -->  coords(Coords), "\n", folds(Folds).

foldCoord((x, Offset), (X,Y), (X,Y)) :- X #=< Offset.
foldCoord((y, Offset), (X,Y), (X,Y)) :- Y #=< Offset.
foldCoord((x, Offset), (X,Y), (NewX,Y)) :- X > Offset, NewX #= 2 * Offset - X.
foldCoord((y, Offset), (X,Y), (X,NewY)) :- Y > Offset, NewY #= 2 * Offset - Y.

foldCoords([], Coords, Coords).
foldCoords([Fold|FoldsTail], Coords, FoldedCoords) :-
    maplist(foldCoord(Fold), Coords, NewCoords),
    sort(NewCoords, RemainingCoords),   % sort removes duplicates
    foldCoords(FoldsTail, RemainingCoords, FoldedCoords).

order(=, (X,Y), (X,Y)).
order(>, (X1,Y), (X2,Y)) :- X2 #< X1.
order(<, (X1,Y), (X2,Y)) :- X2 #> X1.
order(>, (_,Y1), (_,Y2)) :- Y2 #< Y1.
order(<, (_,Y1), (_,Y2)) :- Y2 #> Y1.

createString([], _, _, []).
createString([(X,Y)|Tail], CurrentX, Y, [Char|StringTail]) :-
    CurrentX #< X,
    [Char] = " ",
    NewX #= CurrentX + 1,
    createString([(X,Y)|Tail], NewX, Y, StringTail).
createString([(X,Y)|Tail], X, Y, [Char|StringTail]) :-
    [Char] = "#",
    NewX #= X + 1,
    createString(Tail, NewX, Y, StringTail).
createString([(X,Y)|Tail], _, CurrentY, [Char|StringTail]) :-
    CurrentY #< Y,
    [Char] = "\n",
    createString([(X,Y)|Tail], 0, Y, StringTail).

main :-
    phrase_from_file(parse((Coords, Folds)), "input"),
    foldCoords(Folds, Coords, FoldedCoords),
    predsort(order, FoldedCoords, Sorted),
    createString(Sorted, 0, 0, String),
    atom_codes(Result, String),
    writeln(Result).