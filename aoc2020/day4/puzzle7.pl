:- use_module(library(pio)).
:- use_module(library(clpfd)).
:- set_prolog_flag(double_quotes,codes).

% passport id, attribute type, value
:- dynamic attribute/3.

all_chars([]) --> [].
all_chars([Head|Tail]) --> [Head], {[Head] \= "\n", [Head] \= " "}, all_chars(Tail).
passport_line([AttributeType, AttributeValue|Tail]) --> 
    all_chars(AttributeType), ":", all_chars(AttributeValue), " ", passport_line(Tail).
passport_line([AttributeType, AttributeValue]) --> all_chars(AttributeType), ":", all_chars(AttributeValue).
passport(ListOfTuples) --> 
    passport_line(TuplesOnThisLine), "\n", passport(TuplesOnFollowingLines), 
    {append(TuplesOnThisLine, TuplesOnFollowingLines, ListOfTuples)}.
passport(ListOfTuples) --> passport_line(ListOfTuples), "\n".
parse([FirstPassport|Tail]) --> passport(FirstPassport), "\n", parse(Tail).
parse([OnlyPassport]) --> passport(OnlyPassport).

printPassport([]).
printPassport([HeadAsString|Tail]) :-
    atom_codes(HeadAsAtom, HeadAsString),
    writeln(HeadAsAtom),
    printPassport(Tail).

printAllPassports([]).
printAllPassports([Head|Tail]) :-
    printPassport(Head),
    writeln('---------'),
    printAllPassports(Tail).

assertPassport([], _).
assertPassport([AttributeTypeAsString, AttributeValueAsString|Tail], ID) :-
    atom_codes(AttributeTypeAsAtom, AttributeTypeAsString),
    atom_codes(AttributeValueAsAtom, AttributeValueAsString),
    assert(attribute(ID, AttributeTypeAsAtom, AttributeValueAsAtom)),
    assertPassport(Tail, ID).

assertData([], _).
assertData([Head|Tail], ID) :-
    assertPassport(Head, ID),
    IncreasedID #= ID + 1,
    assertData(Tail, IncreasedID).

passport(ID, BirthYear, IssueYear, ExpirationYear, Height, HairColor, EyeColor, PassportID, CountryID) :-
    attribute(ID, 'byr', BirthYear),
    attribute(ID, 'iyr', IssueYear),
    attribute(ID, 'eyr', ExpirationYear),
    attribute(ID, 'hgt', Height),
    attribute(ID, 'hcl', HairColor),
    attribute(ID, 'ecl', EyeColor),
    attribute(ID, 'pid', PassportID),
    (attribute(ID, 'cid', CountryID);(\+attribute(ID, 'cid', _), CountryID=none)).

main :-
    retractall(attribute(_, _, _)),
    phrase_from_file(parse(Data), "input"),
    assertData(Data, 0),
    %printAllPassports(Data),
    findall(ID, passport(ID, _, _, _, _, _, _, _, _), List),
    length(List, Result),
    writeln(Result).
