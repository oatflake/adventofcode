:- use_module(library(clpfd)).
:- use_module(library(pio)).
:- set_prolog_flag(double_quotes,codes).

all_chars([Head]) --> [Head], {[Head] \= "\n"}.
all_chars([Head|Tail]) --> [Head], {[Head] \= "\n"}, all_chars(Tail).
parse([Line]) --> all_chars(Line), "\n".
parse([Line|Tail]) --> all_chars(Line), "\n", parse(Tail).

convertToBitString(BitString, ConvertedBitString) :-
    maplist(([X,Y]>>(Y #= X - 48)), BitString, ConvertedBitString).

addBitStrings([], [], []). 
addBitStrings([Bit|Tail], [OtherBit|OtherTail], [NewBit|NewTail]) :-
    NewBit #= Bit + OtherBit,
    addBitStrings(Tail, OtherTail, NewTail).

bitStringAsNumber([Bit], 1, Bit).
bitStringAsNumber([Bit|Tail], NewBase, Result) :-
    bitStringAsNumber(Tail, Base, Number),
    NewBase #= Base * 2,
    Result #= Number + NewBase * Bit.

binaryToDezimal(Binary, Dezimal) :- bitStringAsNumber(Binary, _, Dezimal).

main :-
    phrase_from_file(parse(ListOfStrings), "input"),
    length(ListOfStrings, NumberOfStrings),
    maplist(convertToBitString, ListOfStrings, ListOfBitStrings),
    [FirstString|_] = ListOfBitStrings,
    length(FirstString, StringLength),
    length(Zeros, StringLength),
    maplist(=(0), Zeros),
    foldl(addBitStrings, ListOfBitStrings, Zeros, BitsCount),
    maplist(({NumberOfStrings}/[X,Y]>>(Y #= min(1, max(0, 2 * X - NumberOfStrings)))), BitsCount, MostCommon),
    maplist(({NumberOfStrings}/[X,Y]>>(Y #= 1 - X)), MostCommon, LeastCommon),
    binaryToDezimal(MostCommon, Gamma),
    binaryToDezimal(LeastCommon, Epsilon),
    Result #= Gamma * Epsilon,
    writeln(Result).