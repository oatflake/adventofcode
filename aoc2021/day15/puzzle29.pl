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

insertChildrenIntoQueue(_, [], _, Queue, Queue).
insertChildrenIntoQueue((X, Y, PathCost), [(ChildX, ChildY)|Tail], Map, Queue, Result) :-
    rb_lookup((ChildX, ChildY), Risk, Map),
    PathCostToChild #= PathCost + Risk,
    add_to_heap(Queue, PathCostToChild, (ChildX, ChildY, X, Y), NewQueue),
    insertChildrenIntoQueue((X, Y, PathCost), Tail, Map, NewQueue, Result).
    
delta(EndX, _, X, Y, (NeighborX,Y)) :- member(DX, [-1, 1]), NeighborX #= X + DX, NeighborX in 0..EndX, label([NeighborX]).
delta(_, EndY, X, Y, (X,NeighborY)) :- member(DY, [-1, 1]), NeighborY #= Y + DY, NeighborY in 0..EndY, label([NeighborY]).

getNeighbors((EndX, EndY), X, Y, Neighbors) :-  findall(Neighbor, delta(EndX, EndY, X, Y, Neighbor), Neighbors).
    
% as we are only interested in the path cost, we don't actually need the path for this puzzle,
% however, I feel like it's good to have a complete dijkstra implementation around for later...
extractPath((none, none), _, Path, Path).
extractPath((X, Y), Visited, Path, Result) :-
    (X, Y) \= (none, none),
    rb_lookup((X, Y), Parent, Visited),
    extractPath(Parent, Visited, [(X, Y)|Path], Result).

findPath((X, Y), Queue, Visited, _, (Path, PathCost)) :-
    get_from_heap(Queue, PathCost, (X, Y, ParentX, ParentY), _),
    rb_insert_new(Visited, (X, Y), (ParentX, ParentY), NewVisited),
    extractPath((X, Y), NewVisited, [], Path).
findPath(End, Queue, Visited, Map, Result) :-
    get_from_heap(Queue, _, (X, Y, _, _), TmpQueue),
    rb_lookup((X, Y), _, Visited),
    findPath(End, TmpQueue, Visited, Map, Result).
findPath(End, Queue, Visited, Map, Result) :-
    get_from_heap(Queue, PathCost, (X, Y, ParentX, ParentY), TmpQueue),
    rb_insert_new(Visited, (X, Y), (ParentX, ParentY), NewVisited),
    getNeighbors(End, X, Y, Neighbors),
    insertChildrenIntoQueue((X, Y, PathCost), Neighbors, Map, TmpQueue, NewQueue),
    findPath(End, NewQueue, NewVisited, Map, Result).

main :-
    phrase_from_file(parse(0, 0, Data), "input"),
    rb_empty(EmptyTree),
    insertIntoMap(Data, EmptyTree, Map),
    last(Data, (EndX, EndY, _)),
    empty_heap(EmptyHeap),
    add_to_heap(EmptyHeap, 0, (0, 0, none, none), InitialQueue),
    findPath((EndX, EndY), InitialQueue, EmptyTree, Map, (_, PathCost)),
    writeln(PathCost).