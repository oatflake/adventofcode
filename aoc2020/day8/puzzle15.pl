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

run(ProgramCounter, Accumulator, Dict, Accumulator) :- 
    rb_lookup(ProgramCounter, _, Dict).
run(ProgramCounter, Accumulator, Dict, Result) :- 
    rb_insert_new(Dict, ProgramCounter, Accumulator, NewDict),
    instr(ProgramCounter, Instr, Param),
    program_counter(ProgramCounter, Instr, Param, NewProgramCounter),
    accumulator(Accumulator, Instr, Param, NewAccumulator),
    run(NewProgramCounter, NewAccumulator, NewDict, Result).

main :-
    retractall(instr(_,_,_)),
    phrase_from_file(parse(Data), "input"),
    assert_data(Data, 0),
    rb_empty(Dict),
    run(0, 0, Dict, Result),
    writeln(Result).