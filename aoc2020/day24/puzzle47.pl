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
update_tree(Tree, NewTree, X, Y) :- rb_lookup((X,Y), Value, Tree), rb_insert(Tree, (X,Y), 1 - Value, NewTree).

insert_tiles([], Tree, Tree).
insert_tiles([H|T], Tree, Result) :-
    tile_coord(H, 0, 0, X, Y),
    update_tree(Tree, NewTree, X, Y),
    insert_tiles(T, NewTree, Result).

solve(Tiles, Result) :- 
    rb_empty(Tree),
    insert_tiles(Tiles, Tree, NewTree),
    rb_visit(NewTree, L),
    findall(C, member(C-1, L), BlackTiles),
    length(BlackTiles, Result).

main :-
    phrase_from_file(parse(Tiles), "input"),
    solve(Tiles, Result),
    writeln(Result).