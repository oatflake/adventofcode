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
    assert(attribute(ID, AttributeTypeAsAtom, AttributeValueAsString)),
    assertPassport(Tail, ID).

assertData([], _).
assertData([Head|Tail], ID) :-
    assertPassport(Head, ID),
    IncreasedID #= ID + 1,
    assertData(Tail, IncreasedID).

digit(Char) :- Char in 48..57.
containsNonDigit(String) :- member(Char, String), \+ digit(Char).
colorHex(Char) :- digit(Char).
colorHex(Char) :- Char in 97..102.
containsNonColorHex(String) :- member(Char, String), \+ colorHex(Char).

validBirthYear(String) :- length(String, 4), \+ containsNonDigit(String), 
    number_codes(Number, String), Number in 1920..2002.
validIssueYear(String) :- length(String, 4), \+ containsNonDigit(String), 
    number_codes(Number, String), Number in 2010..2020.
validExpirationYear(String) :- length(String, 4), \+ containsNonDigit(String), 
    number_codes(Number, String), Number in 2020..2030.
validHeight(String) :- length(UnitString, 2), append(NumberAsString, UnitString, String), 
    ((UnitString="cm", Number in 150..193);(UnitString="in", Number in 59..76)),
    \+ containsNonDigit(NumberAsString), number_codes(Number, NumberAsString).
validHairColor([Head|Tail]) :- [Head]="#", length(Tail, 6), \+ containsNonColorHex(Tail).
validEyeColor(String) :- member(String, ["amb","blu","brn","gry","grn","hzl","oth"]).
validPassportID(String) :- length(String, 9), \+ containsNonDigit(String).

passport(ID, BirthYear, IssueYear, ExpirationYear, Height, HairColor, EyeColor, PassportID, CountryID) :-
    attribute(ID, 'byr', BirthYear), validBirthYear(BirthYear),
    attribute(ID, 'iyr', IssueYear), validIssueYear(IssueYear),
    attribute(ID, 'eyr', ExpirationYear), validExpirationYear(ExpirationYear),
    attribute(ID, 'hgt', Height), validHeight(Height),
    attribute(ID, 'hcl', HairColor), validHairColor(HairColor),
    attribute(ID, 'ecl', EyeColor), validEyeColor(EyeColor),
    attribute(ID, 'pid', PassportID), validPassportID(PassportID),
    (attribute(ID, 'cid', CountryID);(\+attribute(ID, 'cid', _), CountryID=none)).

main :-
    retractall(attribute(_, _, _)),
    phrase_from_file(parse(Data), "input"),
    assertData(Data, 0),
    %printAllPassports(Data),
    findall(ID, passport(ID, _, _, _, _, _, _, _, _), List),
    length(List, Result),
    writeln(Result).
