% works but is very slow even when using tabling, switching to python for part 2...

:- use_module(library(clpfd)).
:- use_module(library(pio)).
:- set_prolog_flag(double_quotes,codes).

:- dynamic tile/1.
:- dynamic map_entry/4.

all_chars([H]) --> [H], {[H] \= "\n"}.
all_chars([H|T]) --> [H], {[H] \= "\n"}, all_chars(T).

map(H) --> all_chars(H), "\n".
map(L) --> all_chars(H), "\n", map(T), {append(H,T,L)}.
tile(tile(ID, Map)) --> "Tile ", all_chars(ID), ":\n", map(Map).
tiles([H]) --> tile(H), "\n".
tiles([H|T]) --> tile(H), "\n", tiles(T).
parse(Tiles) --> tiles(Tiles).

assert_map_entries(_,[],_,_).
assert_map_entries(TileID, [H|T], X, Y) :-
    ([H] = "#" -> H1 #= 1; H1 #= 0),
    assert(map_entry(TileID, X, Y, H1)),
    Z #= X + 1, 
    X1 #= Z mod 10, 
    Y1 #= Y + Z // 10,
    assert_map_entries(TileID, T, X1, Y1).

assert_tile(tile(ID, Map)) :- 
    number_codes(N, ID),
    assert(tile(N)),
    assert_map_entries(N, Map, 0, 0).

assert_data(Tiles) :- maplist(assert_tile, Tiles).

to_num([H], 0, H).
to_num([H|T], Exp, X) :-
    Exp1 #= Exp - 1,
    to_num(T, Exp1, X1),
    pow(2, Exp, A),
    X #= H * A + X1.

:- table border_id/2.
border_id(BorderList, R) :-
    sort(1, @<, BorderList, Sorted),
    maplist([e(_,C1),C1]>>(true), Sorted, S),    
    reverse(S, S2),
    to_num(S, _, R1),
    to_num(S2, _, R2),
    R #= min(R1, R2).

:- table border/3.
border(ID, 0, R) :- tile(ID), findall(e(X,C), map_entry(ID, X, 0, C), L), border_id(L, R).    % top
border(ID, 2, R) :- tile(ID), findall(e(X,C), map_entry(ID, X, 9, C), L), border_id(L, R).    % bottom
border(ID, 1, R) :- tile(ID), findall(e(Y,C), map_entry(ID, 0, Y, C), L), border_id(L, R).    % left
border(ID, 3, R) :- tile(ID), findall(e(Y,C), map_entry(ID, 9, Y, C), L), border_id(L, R).    % right

neighbor_tiles(ID, NID) :- 
    tile(ID),
    tile(NID),
    ID \= NID,
    border(ID, _, K), 
    border(NID, _, K).
    
corner(ID) :-
    tile(ID),
    length(Neighbors, 2),
    findall(NID, neighbor_tiles(ID, NID), Neighbors).

solve(Result) :-
    findall(ID, corner(ID), Corners),
    foldl([X,Y,Z]>>(Z #= X*Y), Corners, 1, Result).

main :-
    retractall(tile(_)),
    retractall(map_entry(_,_,_,_)),
    phrase_from_file(parse(D), "input"),
    assert_data(D),
    solve(Result),
    writeln(Result).