:- use_module(library(pio)).
:- use_module(library(clpfd)).
:- set_prolog_flag(double_quotes,codes).
:- use_module(library(lists)).

:- dynamic password/4.

all_chars([]) --> [].
all_chars([H|T]) --> [H], all_chars(T).
parse([]) --> [].
parse([I, J, K, S|T]) -->
     all_chars(I), "-",
     all_chars(J), " ",
     [K], ": ",
     all_chars(S), "\n", !, parse(T).

assertData([]).
assertData([I,J,K,S|T]) :-
     number_codes(Ii, I),
     number_codes(Ji, J),
     assertz(password(Ii, Ji, K, S)),
     assertData(T).

 valid(String) :-
     password(I, J, Char, String),
     ((nth1(I, String, X), nth1(J, String, Char));
     (nth1(I, String, Char), nth1(J, String, X))),
     X \= Char.

main :-
    retractall(password(_, _, _, _)),
    phrase_from_file(parse(Data), "input"),
    assertData(Data),
    findall(X, valid(X), L),
    length(L, N),
    writeln(N).
