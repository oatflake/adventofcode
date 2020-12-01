:- use_module(library(pio)).
:- use_module(library(clpfd)).
:- set_prolog_flag(double_quotes,codes).

:- dynamic entry/1.

all_chars([]) --> [].
all_chars([H|T]) --> [H], all_chars(T).
parse([]) --> [].
parse([I|T]) --> all_chars(I), "\n", !, parse(T).

assertData([]).
assertData([I|T]) :-
     number_codes(Ii, I),
     %writeln(Ii),
     assertz(entry(Ii)),
     assertData(T).

main :-
    phrase_from_file(parse(Data), "input"),
    assertData(Data),
    X + Y #= 2020,
    entry(X), entry(Y),
    Result #= X * Y,
    writeln(Result).
