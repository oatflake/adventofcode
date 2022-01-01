:- use_module(library(clpfd)).
:- use_module(library(pio)).
:- set_prolog_flag(double_quotes,codes).

all_chars([]) --> [].
all_chars([Head|Tail]) --> [Head], {[Head] \= "\n"}, all_chars(Tail).

hexBin("0", "0000").
hexBin("1", "0001").
hexBin("2", "0010").
hexBin("3", "0011").
hexBin("4", "0100").
hexBin("5", "0101").
hexBin("6", "0110").
hexBin("7", "0111").
hexBin("8", "1000").
hexBin("9", "1001").
hexBin("A", "1010").
hexBin("B", "1011").
hexBin("C", "1100").
hexBin("D", "1101").
hexBin("E", "1110").
hexBin("F", "1111").

hexToBinary([], []).
hexToBinary([Hex|HexTail], Result) :- hexBin([Hex], Binary), hexToBinary(HexTail, BinaryTail), append(Binary, BinaryTail, Result).

binaryToDecimal([BitAsChar], 1, Decimal) :- number_codes(Decimal, [BitAsChar]).
binaryToDecimal([BitAsChar|BitsTail], NewBase, Decimal) :- 
    binaryToDecimal(BitsTail, Base, Rest),
    number_codes(Bit, [BitAsChar]),
    NewBase #= Base * 2,
    Decimal #= NewBase * Bit + Rest.

number(Group) --> "0", all_chars(Group), { length(Group, 4) }.
number(Result) --> "1", all_chars(Group), { length(Group, 4) }, number(BitString), { append(Group, BitString, Result) }.

version(Version) --> all_chars(VersionAsString), { length(VersionAsString, 3), binaryToDecimal(VersionAsString, _, Version) }.

type(Type) --> all_chars(TypeAsString), { length(TypeAsString, 3), binaryToDecimal(TypeAsString, _, Type) }.

totalLengthInBits(TotalLength) --> 
    all_chars(TotalLengthAsString), 
    { length(TotalLengthAsString, 15), binaryToDecimal(TotalLengthAsString, _, TotalLength) }.

numberOfSubpackets(NumberOfSubpackets) --> 
    all_chars(NumberOfSubpacketsAsString), 
    { length(NumberOfSubpacketsAsString, 11), binaryToDecimal(NumberOfSubpacketsAsString, _, NumberOfSubpackets) }.

subpackets([Packet]) --> packet(Packet).
subpackets([Packet|Tail]) --> packet(Packet), subpackets(Tail).

packet(p(Version, Type, Number)) --> 
    version(Version), type(Type), { Type #= 4 }, 
    number(BitString), { binaryToDecimal(BitString, _, Number) }.
packet(p(Version, Type, Subpackets)) --> 
    version(Version), type(Type), { Type #\= 4 }, 
    "0", totalLengthInBits(TotalLength), all_chars(SubpacketsAsString), 
    { length(SubpacketsAsString, TotalLength), phrase(subpackets(Subpackets), SubpacketsAsString) }.
packet(p(Version, Type, Subpackets)) --> 
    version(Version), type(Type), { Type #\= 4 }, 
    "1", numberOfSubpackets(Length), { length(Subpackets, Length) }, subpackets(Subpackets).

padding --> all_chars(_).

firstPacket(Packet) --> packet(Packet), padding.

parse(Packet) --> all_chars(PacketHex), "\n", { hexToBinary(PacketHex, PacketBinary), phrase(firstPacket(Packet), PacketBinary) }.

evaluate(p(_, 4, Number), Number).
evaluate(p(_, 0, Subpackets), Result) :-
    maplist(evaluate, Subpackets, Numbers), foldl([A,B,R]>>(R #= A + B), Numbers, 0, Result).
evaluate(p(_, 1, Subpackets), Result) :-
    maplist(evaluate, Subpackets, Numbers), foldl([A,B,R]>>(R #= A * B), Numbers, 1, Result).
evaluate(p(_, 2, Subpackets), Result) :-
    maplist(evaluate, Subpackets, Numbers), foldl([A,B,R]>>(R #= min(A, B)), Numbers, 99999999999999999999, Result).
evaluate(p(_, 3, Subpackets), Result) :-
    maplist(evaluate, Subpackets, Numbers), foldl([A,B,R]>>(R #= max(A, B)), Numbers, 0, Result).
evaluate(p(_, 5, Subpackets), Result) :- 
    maplist(evaluate, Subpackets, [A, B]), Result #= min(1, max(0, A - B)).
evaluate(p(_, 6, Subpackets), Result) :- 
    maplist(evaluate, Subpackets, [A, B]), Result #= min(1, max(0, B - A)).
evaluate(p(_, 7, Subpackets), Result) :-
    maplist(evaluate, Subpackets, [A, B]), Result #= 1 - min(1, max(0, abs(A - B))).

main :-
    phrase_from_file(parse(Packet), "input"), 
    !, % cutting is not pretty, but seems fine at least for my input... 
       % cutting isn't necessary, but due to the padding the parser wastes time looking for other solutions
    evaluate(Packet, Result),
    writeln(Result).