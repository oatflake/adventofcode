:- use_module(library(clpfd)).
:- use_module(library(pio)).
:- set_prolog_flag(double_quotes,codes).
:- use_module(library(rbtrees)).
:- use_module(library(heaps)).

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

sumOfVersions(p(Version, 4, _), Version).
sumOfVersions(p(Version, Type, Subpackets), Result) :-
    Type #\= 4,
    maplist(sumOfVersions, Subpackets, Versions),
    sum_list(Versions, SubpacketsVersions),
    Result #= Version + SubpacketsVersions.

main :-
    phrase_from_file(parse(Packet), "input"), 
    !, % cutting is not pretty, but seems fine at least for my input... 
       % cutting isn't necessary, but due to the padding the parser wastes time looking for other solutions
    sumOfVersions(Packet, Result),
    writeln(Result).