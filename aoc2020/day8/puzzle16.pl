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

% modify_instr(+PC, +Instr, +ChangedPC, -NewInstr)
modify_instr(PC, Instr, ChangedPC, Instr) :- PC #\= ChangedPC.
modify_instr(ChangedPC, jmp, ChangedPC, nop).
modify_instr(ChangedPC, nop, ChangedPC, jmp).

% run(+PC, +Acc, +Dict, +ChangedPC, -Result, -Success)
run(PC, Acc, _, _, Acc, ok) :-
    PC1 #= PC - 1, 
    instr(PC1, _, _), 
    \+ instr(PC, _, _).
run(PC, _, Dict, _, _, fail) :- 
    rb_lookup(PC, _, Dict).
run(PC, Acc, Dict, ChangedPC, Result, Success) :- 
    rb_insert_new(Dict, PC, Acc, Dict2),
    instr(PC, Instr, Param),
    modify_instr(PC, Instr, ChangedPC, NewInstr),
    program_counter(PC, NewInstr, Param, PC2),
    accumulator(Acc, NewInstr, Param, Acc2),
    run(PC2, Acc2, Dict2, ChangedPC, Result, Success).

main :-
    retractall(instr(_,_,_)),
    phrase_from_file(parse(D), "input"),
    assert_data(D, 0),
    rb_empty(Dict),
    run(0, 0, Dict, _, Result, ok),
    writeln(Result).