:- use_module(library(clpfd)).
:- use_module(library(pio)).
:- set_prolog_flag(double_quotes,codes).

:- dynamic num/2.

all_chars([Head]) --> [Head], {[Head] \= "\n", [Head] \= " "}.
all_chars([Head|Tail]) --> [Head], {[Head] \= "\n", [Head] \= " "}, all_chars(Tail).
parse([Line|Tail]) --> all_chars(Line), "\n", parse(Tail).
parse([]) --> [].

assert_data([], _).
assert_data([NumberAsString|Tail], ID) :-
    number_codes(Number, NumberAsString),
    assert(num(ID, Number)),
    IncreasedID #= ID + 1,
    assert_data(Tail, IncreasedID).

valid(ID, _) :- ID < 26.
valid(ID, TargetValue) :- 
    FirstID #= ID - 25, 
    LastID #= ID - 1, 
    SomeID #\= SomeOtherID, 
    [SomeID, SomeOtherID] ins FirstID..LastID, 
    num(SomeID, SomeValue), 
    num(SomeOtherID, SomeOtherValue), 
    TargetValue #= SomeValue + SomeOtherValue.

smallerInvalidIdExists(ID) :-
    OtherID #< ID,
    num(OtherID, OtherValue),
    \+ valid(OtherID, OtherValue).

solve(Value) :-
    num(ID, Value),
    \+ valid(ID, Value),
    \+ smallerInvalidIdExists(ID).

main :-
    retractall(num(_,_)),
    phrase_from_file(parse(Data), "input"),
    assert_data(Data, 1),
    solve(Result),
    writeln(Result).