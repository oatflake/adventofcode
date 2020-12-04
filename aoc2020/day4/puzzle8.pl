:- use_module(library(pio)).
:- use_module(library(clpfd)).
:- set_prolog_flag(double_quotes,codes).

:- dynamic attribute/3.

all_chars([]) --> [].
all_chars([H|T]) --> [H], {[H] \= "\n", [H] \= " "}, all_chars(T).
passport_line([X, Y|T]) --> all_chars(X), ":", all_chars(Y), " ", passport_line(T).
passport_line([X, Y]) --> all_chars(X), ":", all_chars(Y).
passport(L2) --> passport_line(L), "\n", passport(T), {append(L, T, L2)}.
passport(L) --> passport_line(L), "\n".
parse([A|L]) --> passport(A), "\n", parse(L).
parse([A]) --> passport(A).

printPassport([]).
printPassport([H|T]) :-
    atom_codes(S, H),
    writeln(S),
    printPassport(T).

printAllPassports([]).
printAllPassports([H|T]) :-
    printPassport(H),
    writeln('---------'),
    printAllPassports(T).

assertPassport([], _).
assertPassport([X,Y|T], N) :-
    atom_codes(XS, X),
    assert(attribute(N, XS, Y)),
    assertPassport(T, N).

assertData([], _).
assertData([H|T], N) :-
    assertPassport(H, N),
    N1 #= N + 1,
    assertData(T, N1).

digit(X) :- X in 48..57.
containsNonDigit(L) :- member(X, L), \+ digit(X).
colorHex(X) :- digit(X).
colorHex(X) :- X in 97..102.
containsNonColorHex(L) :- member(X, L), \+ colorHex(X).

validBirthYear(X) :- length(X, 4), \+ containsNonDigit(X), number_codes(Y, X), Y in 1920..2002.
validIssueYear(X) :- length(X, 4), \+ containsNonDigit(X), number_codes(Y, X), Y in 2010..2020.
validExpirationYear(X) :- length(X, 4), \+ containsNonDigit(X), number_codes(Y, X), Y in 2020..2030.
validHeight(X) :- length(UL, 2), append(YL, UL, X), ((UL="cm", Y in 150..193);(UL="in", Y in 59..76)),
    \+ containsNonDigit(YL), number_codes(Y, YL).
validHairColor([H|T]) :- [H]="#", length(T, 6), \+ containsNonColorHex(T).
validEyeColor(X) :- member(X, ["amb","blu","brn","gry","grn","hzl","oth"]).
validPassportID(X) :- length(X, 9), \+ containsNonDigit(X).

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
    phrase_from_file(parse([H|T]), "input"),
    assertData([H|T], 0),
    %printAllPassports([H|T]),
    findall(X, passport(X, _, _, _, _, _, _, _, _), L),
    length(L, N),
    writeln(N).
