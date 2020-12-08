:- use_module(library(clpfd)).
:- use_module(library(pio)).
:- set_prolog_flag(double_quotes,codes).
:- use_module(library(rbtrees)).

:- dynamic instr/3.

all_chars([H]) --> [H], {[H] \= "\n", [H] \= " "}.
all_chars([H|T]) --> [H], {[H] \= "\n", [H] \= " "}, all_chars(T).
parse([[Instr,Param]|T]) --> all_chars(Instr), " ", all_chars(Param), "\n", parse(T).
parse([]) --> [].

assert_data([], _).
assert_data([[Instr,Param]|T], N) :-
    atom_codes(I, Instr),
    number_codes(P, Param),
    assert(instr(N, I, P)),
    N1 #= N + 1,
    assert_data(T, N1).

program_counter(Old, nop, _, New) :- New #= Old + 1.
program_counter(Old, acc, _, New) :- New #= Old + 1.
program_counter(Old, jmp, Param, New) :- New #= Old + Param.
accumulator(Old, nop, _, Old).
accumulator(Old, acc, Param, New) :- New #= Old + Param.
accumulator(Old, jmp, _, Old).

run(PC, Acc, Dict, Acc) :- 
    rb_lookup(PC, _, Dict).
run(PC, Acc, Dict, Result) :- 
    rb_insert_new(Dict, PC, Acc, Dict2),
    instr(PC, Instr, Param),
    program_counter(PC, Instr, Param, PC2),
    accumulator(Acc, Instr, Param, Acc2),
    run(PC2, Acc2, Dict2, Result).

main :-
    retractall(instr(_,_,_)),
    phrase_from_file(parse(D), "input"),
    assert_data(D, 0),
    rb_empty(Dict),
    run(0, 0, Dict, Result),
    writeln(Result).