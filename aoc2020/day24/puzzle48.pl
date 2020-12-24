:- use_module(library(clpfd)).
:- use_module(library(pio)).
:- set_prolog_flag(double_quotes,codes).
:- use_module(library(rbtrees)).

coord(e) --> "e".
coord(se) --> "se".
coord(sw) --> "sw".
coord(w) --> "w".
coord(nw) --> "nw".
coord(ne) --> "ne".
coords([C]) --> coord(C).
coords([C|T]) --> coord(C), coords(T).
parse([]) --> [].
parse([H|T]) --> coords(H), "\n", parse(T).

posOffset(e, X, Y, X1, Y) :- X1 #= X + 2.
posOffset(se, X, Y, X1, Y1) :- X1 #= X + 1, Y1 #= Y - 2.
posOffset(sw, X, Y, X1, Y1) :- X1 #= X - 1, Y1 #= Y - 2.
posOffset(w, X, Y, X1, Y) :- X1 #= X - 2.
posOffset(nw, X, Y, X1, Y1) :- X1 #= X - 1, Y1 #= Y + 2.
posOffset(ne, X, Y, X1, Y1) :- X1 #= X + 1, Y1 #= Y + 2.

tile_coord([], X, Y, X, Y).
tile_coord([H|T], X, Y, X1, Y1) :- posOffset(H, X, Y, X2, Y2), tile_coord(T, X2, Y2, X1, Y1).

update_tree(Tree, NewTree, X, Y) :- rb_insert_new(Tree, (X,Y), 1, NewTree).
update_tree(Tree, NewTree, X, Y) :- rb_delete(Tree, (X,Y), 1, NewTree).

insert_tiles([], Tree, Tree).
insert_tiles([H|T], Tree, Result) :-
    tile_coord(H, 0, 0, X, Y),
    update_tree(Tree, NewTree, X, Y),
    insert_tiles(T, NewTree, Result).

black_neighboring_tile(D, X, Y, BX, BY, Tree) :- posOffset(D, X, Y, BX, BY), rb_lookup((BX,BY), 1, Tree).

count_neighboring_black_tiles(Tree, X, Y, N) :-
    findall(D, black_neighboring_tile(D,X,Y,_,_,Tree), L),
    length(L, N).

insert_black_tiles([], _, Tree, Tree).
insert_black_tiles([(X,Y)|T], OldTree, Tree, NewTree) :-
    count_neighboring_black_tiles(OldTree, X, Y, N),
    N in 1..2,
    rb_insert_new(Tree, (X,Y), 1, Tree2),
    insert_black_tiles(T, OldTree, Tree2, NewTree).
insert_black_tiles([(X,Y)|T], OldTree, Tree, NewTree) :-
    count_neighboring_black_tiles(OldTree, X, Y, N),
    (N #= 0 ; N #> 2),
    insert_black_tiles(T, OldTree, Tree, NewTree).

insert_white_tiles([], _, Tree, Tree).
insert_white_tiles([(X,Y)|T], OldTree, Tree, NewTree) :-
    count_neighboring_black_tiles(OldTree, X, Y, N),
    N #= 2,
    rb_insert_new(Tree, (X,Y), 1, Tree2),
    insert_white_tiles(T, OldTree, Tree2, NewTree).
insert_white_tiles([(X,Y)|T], OldTree, Tree, NewTree) :-
    count_neighboring_black_tiles(OldTree, X, Y, N),
    N #\= 2,
    insert_white_tiles(T, OldTree, Tree, NewTree).

remove_duplicates([],[]).
remove_duplicates([H|T], [H|T1]) :- \+ member(H, T), remove_duplicates(T, T1).
remove_duplicates([H|T], T1) :- once(member(H, T)), remove_duplicates(T, T1).

white_tiles(Tree, WhiteTiles) :-
    rb_visit(Tree, BlackTiles),
    maplist({Tree}/[(X,Y)-1,Neighbors]>>
            findall((X1,Y1), 
                (black_neighboring_tile(_,X1,Y1,X,Y,Tree), \+rb_lookup((X1,Y1), 1, Tree)), 
                Neighbors),
            BlackTiles, WhiteTilesLists),
    flatten(WhiteTilesLists, WhiteTilesFlattened),
    remove_duplicates(WhiteTilesFlattened, WhiteTiles).

simulate(Tree, 0, Tree).
simulate(Tree, K, ResultTree) :-
    K #> 0,
    rb_visit(Tree, L),
    maplist([(X,Y)-1,(X,Y)]>>true, L, BlackTiles),
    white_tiles(Tree, WhiteTiles),
    rb_empty(Empty),
    insert_black_tiles(BlackTiles, Tree, Empty, BlackInserted),
    insert_white_tiles(WhiteTiles, Tree, BlackInserted, AllInserted),
    K1 #= K - 1,
    simulate(AllInserted, K1, ResultTree).

solve(Tiles, Result) :- 
    rb_empty(Tree),
    insert_tiles(Tiles, Tree, NewTree),
    simulate(NewTree, 100, NewTree2),
    rb_visit(NewTree2, L),
    findall(C, member(C-1, L), BlackTiles),
    length(BlackTiles, Result).

main :-
    phrase_from_file(parse(Tiles), "input"),
    solve(Tiles, Result),
    writeln(Result).