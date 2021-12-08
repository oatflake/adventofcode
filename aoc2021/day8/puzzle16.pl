:- use_module(library(clpfd)).
:- use_module(library(pio)).
:- set_prolog_flag(double_quotes,codes).

all_chars([Char]) --> [Head], {[Head] \= "\n", [Head] \= " ", [Head] \= "|" , atom_codes(Char, [Head]) }.
all_chars([Char|Tail]) --> [Head], {[Head] \= "\n", [Head] \= " ", [Head] \= "|", atom_codes(Char, [Head]) }, all_chars(Tail).
digits([Pattern]) --> all_chars(Pattern).
digits([Pattern|Tail]) --> all_chars(Pattern), " ", digits(Tail).
parse([(SignalPattern,Output)]) --> digits(SignalPattern), " | " , digits(Output), "\n".
parse([(SignalPattern,Output)|Tail]) -->  digits(SignalPattern), " | " , digits(Output), "\n", parse(Tail).

assignDigits(Patterns, [A,B,C,D,E,F,G]) :- 
    member(Pattern1, Patterns),
    permutation(Pattern1, [C, F]),
    member(Pattern7, Patterns),
    permutation(Pattern7, [A, C, F]),
    member(Pattern4, Patterns),
    permutation(Pattern4, [B, C, D, F]),
    member(Pattern8, Patterns),
    permutation(Pattern8, [A, B, C, D, E, F, G]),
    member(Pattern0, Patterns),
    permutation(Pattern0, [A, B, C, E, F, G]),
    member(Pattern2, Patterns),
    permutation(Pattern2, [A, C, D, E, G]),
    member(Pattern3, Patterns),
    permutation(Pattern3, [A, C, D, F, G]),
    member(Pattern5, Patterns),
    permutation(Pattern5, [A, B, D, F, G]),
    member(Pattern6, Patterns),
    permutation(Pattern6, [A, B, D, E, F, G]),
    member(Pattern9, Patterns),
    permutation(Pattern9, [A, B, C, D, F, G]),
    permutation([a,b,c,d,e,f,g], [A,B,C,D,E,F,G]).

decodeDigit(Digit, [A,B,C,_,E,F,G], 0) :- permutation(Digit, [A, B, C, E, F, G]).
decodeDigit(Digit, [_,_,C,_,_,F,_], 1) :- permutation(Digit, [C, F]).
decodeDigit(Digit, [A,_,C,D,E,_,G], 2) :- permutation(Digit, [A, C, D, E, G]).
decodeDigit(Digit, [A,_,C,D,_,F,G], 3) :- permutation(Digit, [A, C, D, F, G]).
decodeDigit(Digit, [_,B,C,D,_,F,_], 4) :- permutation(Digit, [B, C, D, F]).
decodeDigit(Digit, [A,B,_,D,_,F,G], 5) :- permutation(Digit, [A, B, D, F, G]).
decodeDigit(Digit, [A,B,_,D,E,F,G], 6) :- permutation(Digit, [A, B, D, E, F, G]).
decodeDigit(Digit, [A,_,C,_,_,F,_], 7) :- permutation(Digit, [A, C, F]).
decodeDigit(Digit, [A,B,C,D,E,F,G], 8) :- permutation(Digit, [A, B, C, D, E, F, G]).
decodeDigit(Digit, [A,B,C,D,_,F,G], 9) :- permutation(Digit, [A, B, C, D, F, G]).

decodeOutput([OutputDigit0, OutputDigit1, OutputDigit2, OutputDigit3 ], DigitAssignments, Result) :-
    decodeDigit(OutputDigit0, DigitAssignments, DecodedDigit0),
    decodeDigit(OutputDigit1, DigitAssignments, DecodedDigit1),
    decodeDigit(OutputDigit2, DigitAssignments, DecodedDigit2),
    decodeDigit(OutputDigit3, DigitAssignments, DecodedDigit3),
    Result #= DecodedDigit0 * 1000 + DecodedDigit1 * 100 + DecodedDigit2 * 10 + DecodedDigit3.

sumOfOutputs([], Accumulator, Accumulator).
sumOfOutputs([(Patterns, Output)|Tail], Accumulator, Result) :- 
    assignDigits(Patterns, DigitAssignments),
    decodeOutput(Output, DigitAssignments, Decoded),
    NewAccumulator #= Accumulator + Decoded,
    sumOfOutputs(Tail, NewAccumulator, Result).

main :-
    phrase_from_file(parse(Data), "input"),
    sumOfOutputs(Data, 0, Result),
    writeln(Result).
