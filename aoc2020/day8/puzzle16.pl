:- use_module(library(clpfd)).
:- use_module(library(pio)).
:- set_prolog_flag(double_quotes,codes).
:- use_module(library(rbtrees)).

% line number, instruction, parameter
:- dynamic instr/3.

all_chars([Head]) --> [Head], {[Head] \= "\n", [Head] \= " "}.
all_chars([Head|Tail]) --> [Head], {[Head] \= "\n", [Head] \= " "}, all_chars(Tail).
parse([[Instr,Param]|Tail]) --> all_chars(Instr), " ", all_chars(Param), "\n", parse(Tail).
parse([]) --> [].

assert_data([], _).
assert_data([[InstrAsString,ParamAsString]|Tail], LineNumber) :-
    atom_codes(InstrAsAtom, InstrAsString),
    number_codes(ParamAsAtom, ParamAsString),
    assert(instr(LineNumber, InstrAsAtom, ParamAsAtom)),
    IncreasedLineNumber #= LineNumber + 1,
    assert_data(Tail, IncreasedLineNumber).

program_counter(Old, nop, _, New) :- New #= Old + 1.
program_counter(Old, acc, _, New) :- New #= Old + 1.
program_counter(Old, jmp, Param, New) :- New #= Old + Param.
accumulator(Old, nop, _, Old).
accumulator(Old, acc, Param, New) :- New #= Old + Param.
accumulator(Old, jmp, _, Old).

% modify_instr(+ProgramCounter, +Instr, +ChangedProgramCounter, -NewInstr)
modify_instr(ProgramCounter, Instr, ChangedProgramCounter, Instr) :- ProgramCounter #\= ChangedProgramCounter.
modify_instr(ChangedProgramCounter, jmp, ChangedProgramCounter, nop).
modify_instr(ChangedProgramCounter, nop, ChangedProgramCounter, jmp).

% run(+ProgramCounter, +Accumulator, +Dict, +ChangedProgramCounter, -Result, -Success)
run(ProgramCounter, Accumulator, _, _, Accumulator, ok) :-
    NewProgramCounter #= ProgramCounter - 1, 
    instr(NewProgramCounter, _, _), 
    \+ instr(ProgramCounter, _, _).
run(ProgramCounter, _, Dict, _, _, fail) :- 
    rb_lookup(ProgramCounter, _, Dict).
run(ProgramCounter, Accumulator, Dict, ChangedProgramCounter, Result, Success) :- 
    rb_insert_new(Dict, ProgramCounter, Accumulator, NewDict),
    instr(ProgramCounter, Instr, Param),
    modify_instr(ProgramCounter, Instr, ChangedProgramCounter, NewInstr),
    program_counter(ProgramCounter, NewInstr, Param, NewProgramCounter),
    accumulator(Accumulator, NewInstr, Param, NewAccumulator),
    run(NewProgramCounter, NewAccumulator, NewDict, ChangedProgramCounter, Result, Success).

main :-
    retractall(instr(_,_,_)),
    phrase_from_file(parse(Data), "input"),
    assert_data(Data, 0),
    rb_empty(Dict),
    run(0, 0, Dict, _, Result, ok),
    writeln(Result).