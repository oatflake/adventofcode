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

smallestInvalidIdNumber(Value) :-
    num(ID, Value),
    \+ valid(ID, Value),
    \+ smallerInvalidIdExists(ID).

sumOfIdRange(LowerEnd, UpperEnd, Accumulator, Result) :- 
    LowerEnd #= UpperEnd - 1, 
    num(LowerEnd, Number), 
    num(UpperEnd, Number1), 
    Result #= Accumulator + Number + Number1.
sumOfIdRange(LowerEnd, UpperEnd, Accumulator, Result) :-
    LowerEnd #< UpperEnd - 1,
    num(LowerEnd, Number),
    IncreasedLowerEnd #= LowerEnd + 1,
    NewAccumulator #= Accumulator + Number,
    sumOfIdRange(IncreasedLowerEnd, UpperEnd, NewAccumulator, Result).

smallerValueInIdRangeExists(LowerEnd, UpperEnd, Value) :-
    ID in LowerEnd..UpperEnd,
    num(ID, OtherValue),
    OtherValue #< Value.

minValueInIdRange(LowerEnd, UpperEnd, Min) :-
    ID in LowerEnd..UpperEnd,
    num(ID, Min),
    \+ smallerValueInIdRangeExists(LowerEnd, UpperEnd, Min).

largerValueInIdRangeExists(LowerEnd, UpperEnd, Value) :-
    ID in LowerEnd..UpperEnd,
    num(ID, OtherValue),
    OtherValue #> Value.

maxInIdRange(LowerEnd, UpperEnd, Max) :-
    ID in LowerEnd..UpperEnd,
    num(ID, Max),
    \+ largerValueInIdRangeExists(LowerEnd, UpperEnd, Max).

solve(Invalid, Result) :-
    sumOfIdRange(LowerEnd, UpperEnd, 0, Invalid),
    minValueInIdRange(LowerEnd, UpperEnd, Min),
    maxInIdRange(LowerEnd, UpperEnd, Max),
    Result #= Min + Max.

main :-
    retractall(num(_,_)),
    phrase_from_file(parse(Data), "input"),
    assert_data(Data, 1),
    smallestInvalidIdNumber(Invalid),
    solve(Invalid, Result),
    writeln(Result).