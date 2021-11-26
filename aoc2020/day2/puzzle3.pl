:- use_module(library(pio)).
:- use_module(library(clpfd)).
:- set_prolog_flag(double_quotes,codes).

% Min, Max, Letter, PasswordString
:- dynamic password/4.

all_chars([]) --> [].
all_chars([Head|Tail]) --> [Head], all_chars(Tail).
parse([]) --> [].
parse([Min, Max, Letter, PasswordString|Tail]) -->
    all_chars(Min), "-",
    all_chars(Max), " ",
    [Letter], ": ",
    all_chars(PasswordString), "\n", !, parse(Tail).

assertData([]).
assertData([MinAsString, MaxAsString, Letter, PasswordString|Tail]) :-
    number_codes(MinAsNumber, MinAsString),
    number_codes(MaxAsNumber, MaxAsString),
    assertz(password(MinAsNumber, MaxAsNumber, Letter, PasswordString)),
    assertData(Tail).

count(_, [], 0).
count(SearchedItem, [SearchedItem|Tail], IncreasedOccurences) :-
    IncreasedOccurences #= Occurences + 1,
    count(SearchedItem, Tail, Occurences).
count(SearchedItem, [Head|Tail], Occurences) :-
    SearchedItem \= Head,
    count(SearchedItem, Tail, Occurences).

valid(String) :-
    password(Min, Max, Char, String),
    count(Char, String, Occurences),
    Min #=< Occurences,
    Max #>= Occurences.

main :-
    retractall(password(_, _, _, _)),
    phrase_from_file(parse(Data), "input"),
    assertData(Data),
    findall(PasswordString, valid(PasswordString), List),
    length(List, Result),
    writeln(Result).
