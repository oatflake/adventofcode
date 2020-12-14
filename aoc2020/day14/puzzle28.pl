:- use_module(library(clpfd)).
:- use_module(library(pio)).
:- set_prolog_flag(double_quotes,codes).

all_chars([H]) --> [H], { [H] \= "\n" }.
all_chars([H|T]) --> [H], { [H] \= "\n" }, all_chars(T).
parse([mask(X)|T]) --> "mask = ", all_chars(X), "\n", parse(T).
parse([mem(X, Y)|T]) --> "mem[", all_chars(X), "] = ", all_chars(Y), "\n", parse(T).
parse([]) --> []. 

sum_tree([], Acc, Acc).
sum_tree([_-H|T], Acc, Result) :-
    Acc1 #= Acc + H,
    sum_tree(T, Acc1, Result).

address([], [], []).
address([X|T], [48|TM], [X|T2]) :- address(T, TM, T2).
address([_|T], [49|TM], [49|T2]) :- address(T, TM, T2).
address([_|T], [88|TM], [49|T2]) :- address(T, TM, T2).
address([_|T], [88|TM], [48|T2]) :- address(T, TM, T2).

change_memory([], _, Mem, Mem).
change_memory([H|T], V, Mem, NewMem) :-
    atom_codes(H1, H),
    rb_insert(Mem, H1, V, Mem1),
    change_memory(T, V, Mem1, NewMem).

convert_to_bitlist(0, N, Acc, Acc) :- length(Acc, N).
convert_to_bitlist(X, N, Acc, Result) :-
    length(Acc, N1),
    N1 #< N,
    LastBit #= X mod 2,
    X1 #= X // 2,
    Converted #= LastBit + 48,
    convert_to_bitlist(X1, N, [Converted|Acc], Result).

apply_instructions([],_, Mem, Mem).
apply_instructions([mask(X)|T], _, Mem, Result) :-
    apply_instructions(T, mask(X), Mem, Result).

apply_instructions([mem(X,Y)|T], mask(Mask), Mem, Result) :-
    number_codes(X1, X),
    length(Mask, N),
    convert_to_bitlist(X1, N, [], X2), 
    findall(Z, address(X2, Mask, Z), L),
    number_codes(Y1, Y),
    change_memory(L, Y1, Mem, Mem1),
    apply_instructions(T, mask(Mask), Mem1, Result).

solve(L, Result):-
    rb_empty(EmptyMem),
    apply_instructions(L, _, EmptyMem, Mem),
    rb_visit(Mem, Pairs),
    sum_tree(Pairs, 0, Result).

main :-
    phrase_from_file(parse(D), "input"),
    solve(D, Result),
    writeln(Result).