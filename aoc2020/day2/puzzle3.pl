:- use_module(library(pio)).
:- use_module(library(clpfd)).
:- set_prolog_flag(double_quotes,codes).

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

count(_, [], 0).
count(X, [X|T], N) :-
     N #= N1 + 1,
     count(X, T, N1).
count(X, [H|T], N) :-
     X \= H,
     count(X, T, N).

valid(String) :-
     password(Min, Max, Char, String),
     count(Char, String, N),
     Min #=< N,
     Max #>= N.

main :-
    retractall(password(_, _, _, _)),
    phrase_from_file(parse(Data), "input"),
    assertData(Data),
    findall(X, valid(X), L),
    length(L, N),
    writeln(N).
