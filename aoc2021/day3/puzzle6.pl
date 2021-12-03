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

sumOfBitString(StringLength, ListOfBitStrings, BitsCount) :-
    length(Zeros, StringLength),
    maplist(=(0), Zeros),
    foldl(addBitStrings, ListOfBitStrings, Zeros, BitsCount).

mostCommonFilter(NumberOfStrings, BitsCount, MostCommon) :-
    maplist(({NumberOfStrings}/[X,Y]>>(Y #= min(1, max(0, 2 * X - NumberOfStrings + 1)))), BitsCount, MostCommon).

leastCommonFilter(NumberOfStrings, BitsCount, LeastCommon) :-
    maplist(({NumberOfStrings}/[X,Y]>>(Y #= min(1, max(0, NumberOfStrings - 2 * X)))), BitsCount, LeastCommon).

bitStringAsNumber([Bit], 1, Bit).
bitStringAsNumber([Bit|Tail], NewBase, Result) :-
    bitStringAsNumber(Tail, Base, Number),
    NewBase #= Base * 2,
    Result #= Number + NewBase * Bit.

binaryToDezimal(Binary, Dezimal) :- bitStringAsNumber(Binary, _, Dezimal).

filter(_, [Result], _, Result).
filter(Filter, ListOfBitStrings, Index, Result) :- 
    length(ListOfBitStrings, NumberOfStrings),
    [FirstString|_] = ListOfBitStrings,
    length(FirstString, StringLength),
    % counting all bits when we are only interested in one is not ideal...
    % it's coded this due to the fact that we are reusing code written for part 1
    sumOfBitString(StringLength, ListOfBitStrings, BitsCount),
    call(Filter, NumberOfStrings, BitsCount, FilterString),
    nth0(Index, FilterString, FilterElement),
    include([X]>>(nth0(Index, X, FilterElement)), ListOfBitStrings, FilteredList),
    IncreasedIndex #= Index + 1,
    filter(Filter, FilteredList, IncreasedIndex, Result).

main :-
    phrase_from_file(parse(ListOfStrings), "input"),
    maplist(convertToBitString, ListOfStrings, ListOfBitStrings),
    filter(mostCommonFilter, ListOfBitStrings, 0, MostCommon),
    filter(leastCommonFilter, ListOfBitStrings, 0, LeastCommon),
    binaryToDezimal(MostCommon, OxygenGenerator),
    binaryToDezimal(LeastCommon, CO2Scrubber),
    Result #= OxygenGenerator * CO2Scrubber,
    writeln(Result).