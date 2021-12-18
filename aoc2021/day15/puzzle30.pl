:- use_module(library(clpfd)).
:- use_module(library(pio)).
:- set_prolog_flag(double_quotes,codes).
:- use_module(library(rbtrees)).
:- use_module(library(heaps)).

parse(_, _, []) --> "\n".
parse(_, Y, Tail) --> "\n", {Y1 #= Y + 1}, parse(0, Y1, Tail).
parse(X, Y, [(X, Y, Risk)|Tail]) --> [Head], {[Head] \= "\n", [Zero] = "0", Risk #= Head - Zero, X1 #= X + 1}, parse(X1, Y, Tail).

insertIntoMap([], Tree, Tree).
insertIntoMap([(X, Y, Risk)|Tail], Tree, Result) :-
    rb_insert_new(Tree, (X, Y), Risk, NewTree),
    insertIntoMap(Tail, NewTree, Result).

getRisk((ChildX, ChildY), (MapWidth, MapHeight, Map), NewRisk) :-
    X #= ChildX mod MapWidth,
    Y #= ChildY mod MapHeight,
    TileX #= ChildX div MapWidth,
    TileY #= ChildY div MapHeight,
    rb_lookup((X, Y), Risk, Map),
    NewRisk #= ((Risk - 1 + TileX + TileY) mod 9) + 1.

insertChildrenIntoQueue(_, _, _, [], _, Queue, Queue).
insertChildrenIntoQueue(Visited, (EndX, EndY), (X, Y, PathCost), [(ChildX, ChildY)|Tail], Map, Queue, Result) :-
    rb_lookup((ChildX, ChildY), _, Visited),    % additional check to prevent our queue (aka open list) from growing too large
    insertChildrenIntoQueue(Visited, (EndX, EndY), (X, Y, PathCost), Tail, Map, Queue, Result).
insertChildrenIntoQueue(Visited, (EndX, EndY), (X, Y, PathCost), [(ChildX, ChildY)|Tail], Map, Queue, Result) :-
    \+ rb_lookup((ChildX, ChildY), _, Visited),
    getRisk((ChildX, ChildY), Map, Risk),
    PathCostToChild #= PathCost + Risk,
    % A* to keep the amount of expanded nodes small, using manhatten distance as heuristic
    TotalCost #= PathCostToChild + abs(ChildX - EndX) + abs(ChildY - EndY), 
    add_to_heap(Queue, TotalCost, (ChildX, ChildY, X, Y, PathCostToChild), NewQueue),
    insertChildrenIntoQueue(Visited, (EndX, EndY), (X, Y, PathCost), Tail, Map, NewQueue, Result).
    
delta(EndX, _, X, Y, (NeighborX,Y)) :- member(DX, [-1, 1]), NeighborX #= X + DX, NeighborX in 0..EndX, label([NeighborX]).
delta(_, EndY, X, Y, (X,NeighborY)) :- member(DY, [-1, 1]), NeighborY #= Y + DY, NeighborY in 0..EndY, label([NeighborY]).

getNeighbors((EndX, EndY), X, Y, Neighbors) :-  findall(Neighbor, delta(EndX, EndY, X, Y, Neighbor), Neighbors).
    
% as we are only interested in the path cost, we don't actually need the path for this puzzle,
% however, I feel like it's good to have a complete dijkstra/A* implementation around for later...
extractPath((none, none), _, Path, Path).
extractPath((X, Y), Visited, Path, Result) :-
    (X, Y) \= (none, none),
    rb_lookup((X, Y), Parent, Visited),
    extractPath(Parent, Visited, [(X, Y)|Path], Result).

findPath((X, Y), Queue, Visited, _, (Path, PathCost)) :-
    get_from_heap(Queue, _, (X, Y, ParentX, ParentY, PathCost), _),
    rb_insert_new(Visited, (X, Y), (ParentX, ParentY), NewVisited),
    extractPath((X, Y), NewVisited, [], Path).
findPath(End, Queue, Visited, Map, Result) :-
    get_from_heap(Queue, _, (X, Y, _, _, _), TmpQueue),
    rb_lookup((X, Y), _, Visited),
    !,  % prolog wants to (unnecessarily) backtrack, hence, cutting to prevent the stack from blowing
    findPath(End, TmpQueue, Visited, Map, Result).
findPath(End, Queue, Visited, Map, Result) :-
    get_from_heap(Queue, _, (X, Y, ParentX, ParentY, PathCost), TmpQueue),
    rb_insert_new(Visited, (X, Y), (ParentX, ParentY), NewVisited),
    getNeighbors(End, X, Y, Neighbors),
    insertChildrenIntoQueue(Visited, End, (X, Y, PathCost), Neighbors, Map, TmpQueue, NewQueue),
    !,  % prolog wants to (unnecessarily) backtrack, hence, cutting to prevent the stack from blowing
    findPath(End, NewQueue, NewVisited, Map, Result).

main :-
    phrase_from_file(parse(0, 0, Data), "input"),
    rb_empty(EmptyTree),
    insertIntoMap(Data, EmptyTree, Map),
    last(Data, (LastX, LastY, _)),
    MapWidth #= LastX + 1, 
    MapHeight #= LastY + 1,
    EndX #= MapWidth * 5 - 1,
    EndY #= MapHeight * 5 - 1,
    empty_heap(EmptyHeap),
    add_to_heap(EmptyHeap, 0, (0, 0, none, none, 0), InitialQueue),
    findPath((EndX, EndY), InitialQueue, EmptyTree, (MapWidth, MapHeight, Map), (_, PathCost)),
    writeln(PathCost).