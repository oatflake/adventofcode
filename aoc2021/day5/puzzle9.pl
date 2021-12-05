:- use_module(library(clpfd)).
:- use_module(library(pio)).
:- set_prolog_flag(double_quotes,codes).
:- use_module(library(rbtrees)).

all_chars([Head]) --> [Head], {[Head] \= "\n", [Head] \= ","}.
all_chars([Head|Tail]) --> [Head], {[Head] \= "\n", [Head] \= ","}, all_chars(Tail).
line([X1,Y1,X2,Y2]) --> all_chars(X1), ",", all_chars(Y1), " -> ", all_chars(X2), ",", all_chars(Y2), "\n".
parse([Line]) --> line(Line).
parse([Line|Tail]) -->  line(Line), parse(Tail).

convert(DataAsString, Data) :- maplist(number_codes, Data, DataAsString).

filter(Lines, Filtered) :-
    include([[X,_,X,_]]>>(true), Lines, FilteredX),
    include([[_,Y,_,Y]]>>(true), Lines, FilteredY),
    union(FilteredX, FilteredY, Filtered).

updateTree(X, Y, Tree, NewTree) :-
    rb_insert_new(Tree, (X,Y), 1, NewTree).
updateTree(X, Y, Tree, NewTree) :-
    rb_lookup((X,Y), Value, Tree),
    NewValue #= Value + 1,
    rb_insert(Tree, (X,Y), NewValue, NewTree).

rasterLine([X,Y,X,Y], Tree, ResultTree) :- updateTree(X, Y, Tree, ResultTree).
rasterLine([X1,Y,X2,Y], Tree, ResultTree) :-
    X2 #\= X1,
    updateTree(X1, Y, Tree, NewTree),
    sign(X2 - X1, S),
    NewX #= X1 + S,
    rasterLine([NewX,Y,X2,Y], NewTree, ResultTree).
rasterLine([X,Y1,X,Y2], Tree, ResultTree) :-
    Y2 #\= Y1,
    updateTree(X, Y1, Tree, NewTree),
    sign(Y2 - Y1, S),
    NewY #= Y1 + S,
    rasterLine([X,NewY,X,Y2], NewTree, ResultTree).

rasterLines([], Tree, Tree).
rasterLines([Line|Tail], Tree, ResultTree) :-
    rasterLine(Line, Tree, NewTree),
    rasterLines(Tail, NewTree, ResultTree).

main :-
    phrase_from_file(parse(DataAsStrings), "input"),
    maplist(convert, DataAsStrings, Lines),
    filter(Lines, FilteredLines),
    rb_empty(EmptyTree),
    rasterLines(FilteredLines, EmptyTree, RasteredLines),
    rb_visit(RasteredLines, VisitedCoords),
    findall(C, (member(C-V, VisitedCoords), V #\= 1), Intersections),
    length(Intersections, Result),
    writeln(Result). 