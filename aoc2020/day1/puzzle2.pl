:- use_module(library(pio)).
:- use_module(library(clpfd)).
:- set_prolog_flag(double_quotes,codes).

:- dynamic entry/1.

all_chars([]) --> [].
all_chars([Head|Tail]) --> [Head], all_chars(Tail).
parse([]) --> [].
parse([Line|Tail]) --> all_chars(Line), "\n", !, parse(Tail).

assertData([]).
assertData([String|Tail]) :-
     number_codes(Number, String),
     %writeln(Ii),
     assertz(entry(Number)),
     assertData(Tail).

main :-
    phrase_from_file(parse(Data), "input"),
    assertData(Data),
    X + Y + Z #= 2020,
    entry(X), entry(Y), entry(Z),
    Result #= X * Y * Z,
    writeln(Result).
