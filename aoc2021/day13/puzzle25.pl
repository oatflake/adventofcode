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

main :-
    phrase_from_file(parse((Coords, Folds)), "input"),
    [FirstFold|_] = Folds,
    maplist(foldCoord(FirstFold), Coords, NewCoords),
    sort(NewCoords, RemainingCoords),   % sort removes duplicates
    length(RemainingCoords, Result),
    writeln(Result).