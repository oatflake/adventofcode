:- use_module(library(clpfd)).
:- use_module(library(pio)).
:- set_prolog_flag(double_quotes,codes).

all_chars([Char]) --> [Head], {[Head] \= "\n", [Head] \= " ", [Head] \= "|" , atom_codes(Char, [Head]) }.
all_chars([Char|Tail]) --> [Head], {[Head] \= "\n", [Head] \= " ", [Head] \= "|", atom_codes(Char, [Head]) }, all_chars(Tail).
digits([Pattern]) --> all_chars(Pattern).
digits([Pattern|Tail]) --> all_chars(Pattern), " ", digits(Tail).
parse([(SignalPattern,Output)]) --> digits(SignalPattern), " | " , digits(Output), "\n".
parse([(SignalPattern,Output)|Tail]) -->  digits(SignalPattern), " | " , digits(Output), "\n", parse(Tail).

countEasyDigits([], Accumulator, Accumulator).
countEasyDigits([Digit|Tail], Accumulator, Result) :- 
    length(Digit, Length),
    \+ member(Length, [2,3,4,7]), 
    countEasyDigits(Tail, Accumulator, Result).
countEasyDigits([Digit|Tail], Accumulator, Result) :- 
    length(Digit, Length),
    member(Length, [2,3,4,7]), 
    NewAccumulator #= Accumulator + 1,
    countEasyDigits(Tail, NewAccumulator, Result).

countEasyOutputs([], Accumulator, Accumulator).
countEasyOutputs([(_,Output)|Tail], Accumulator, Result) :- 
    countEasyDigits(Output, 0, Digits),
    NewAccumulator #= Accumulator + Digits,
    countEasyOutputs(Tail, NewAccumulator, Result).

main :-
    phrase_from_file(parse(Data), "input"),
    countEasyOutputs(Data, 0, Result),
    writeln(Result).
