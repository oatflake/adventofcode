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
    atom_codes(YS, Y),
    assert(attribute(N, XS, YS)),
    assertPassport(T, N).

assertData([], _).
assertData([H|T], N) :-
    assertPassport(H, N),
    N1 #= N + 1,
    assertData(T, N1).

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
    phrase_from_file(parse([H|T]), "input"),
    assertData([H|T], 0),
    %printAllPassports([H|T]),
    findall(X, passport(X, _, _, _, _, _, _, _, _), L),
    length(L, N),
    writeln(N).
