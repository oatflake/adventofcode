:- use_module(library(clpfd)).
:- use_module(library(pio)).
:- set_prolog_flag(double_quotes,codes).

all_chars([H]) --> [H], { [H] \= "\n" }.
all_chars([H|T]) --> [H], { [H] \= "\n" }, all_chars(T).
mask([0], [1]) --> "X".
mask([0|T1], [1|T2]) --> "X", mask(T1, T2).
mask([H1], [H1]) --> [H], { H1 #= H - 48, [H] \= "\n", [H] \= "X" }.
mask([H1|T1], [H1|T2]) --> [H], { H1 #= H - 48, [H] \= "\n", [H] \= "X" }, mask(T1, T2).
parse([mask(X,Y)|T]) --> "mask = ", mask(X, Y), "\n", parse(T).
parse([mem(X,Y)|T]) --> "mem[", all_chars(X), "] = ", all_chars(Y), "\n", parse(T).
parse([]) --> [].

binarylist_to_int([H], 0, H).
binarylist_to_int([H|T], N, X) :-
    binarylist_to_int(T, N1, X1),
    N1 #= N - 1,
    pow(2, N, K),
    X #= X1 + K * H.

convert([],[]).
convert([mask(X,Y)|T], [mask(X1,Y1)|T2]) :-
    binarylist_to_int(X, _, X1),
    binarylist_to_int(Y, _, Y1),
    convert(T, T2). 
convert([mem(X,Y)|T], [mem(X1,Y1)|T2]) :-
    number_codes(X1, X),
    number_codes(Y1, Y),
    convert(T, T2). 

sum_tree([], Acc, Acc).
sum_tree([_-H|T], Acc, Result) :-
    Acc1 #= Acc + H,
    sum_tree(T, Acc1, Result).
    
apply_instructions([],_, Mem, Mem).
apply_instructions([mask(X,Y)|T], _, Mem, Result) :-
    apply_instructions(T, mask(X,Y), Mem, Result).

apply_instructions([mem(X,Y)|T], mask(Mask0,Mask1), Mem, Result) :-
    V #= (Y \/ Mask0) /\ Mask1,
    rb_insert(Mem, X, V, Mem1),
    apply_instructions(T, mask(Mask0,Mask1), Mem1, Result).

solve(L, Result):-
    rb_empty(EmptyMem),
    apply_instructions(L, _, EmptyMem, Mem),
    rb_visit(Mem, Pairs),
    sum_tree(Pairs, 0, Result).

main :-
    phrase_from_file(parse(D), "input"),
    convert(D, L),
    solve(L, Result),
    writeln(Result).