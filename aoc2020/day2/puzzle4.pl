:- use_module(library(pio)).
:- use_module(library(clpfd)).
:- set_prolog_flag(double_quotes,codes).
:- use_module(library(lists)).

% FirstIndex, SecondIndex, Letter, Password
:- dynamic password/4.

all_chars([]) --> [].
all_chars([Head|Tail]) --> [Head], all_chars(Tail).
parse([]) --> [].
parse([FirstIndex, SecondIndex, Letter, PasswordString|Tail]) -->
    all_chars(FirstIndex), "-",
    all_chars(SecondIndex), " ",
    [Letter], ": ",
    all_chars(PasswordString), "\n", !, parse(Tail).

assertData([]).
assertData([FirstIndexAsString, SecondIndexAsString, Letter, PasswordString|Tail]) :-
    number_codes(FirstIndexAsNumber, FirstIndexAsString),
    number_codes(SecondIndexAsNumber, SecondIndexAsString),
    assertz(password(FirstIndexAsNumber, SecondIndexAsNumber, Letter, PasswordString)),
    assertData(Tail).

 valid(String) :-
     password(FirstIndex, SecondIndex, Char, String),
     ((nth1(FirstIndex, String, Char), nth1(SecondIndex, String, OtherChar));
     (nth1(FirstIndex, String, OtherChar), nth1(SecondIndex, String, Char))),
     Char \= OtherChar.

main :-
    retractall(password(_, _, _, _)),
    phrase_from_file(parse(Data), "input"),
    assertData(Data),
    findall(PasswordString, valid(PasswordString), List),
    length(List, Result),
    writeln(Result).
