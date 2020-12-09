:- use_module(library(clpfd)).
:- use_module(library(pio)).
:- set_prolog_flag(double_quotes,codes).

:- dynamic num/2.

all_chars([H]) --> [H], {[H] \= "\n", [H] \= " "}.
all_chars([H|T]) --> [H], {[H] \= "\n", [H] \= " "}, all_chars(T).
parse([X|T]) --> all_chars(X), "\n", parse(T).
parse([]) --> [].

assert_data([], _).
assert_data([X|T], N) :-
    number_codes(Num, X),
    assert(num(N, Num)),
    N1 #= N + 1,
    assert_data(T, N1).

valid(N, _) :- N < 26.
valid(N, X) :- 
    F #= N - 25, 
    L #= N - 1, 
    N1 #\= N2, 
    [N1, N2] ins F..L, 
    num(N1, Y), 
    num(N2, Z), 
    X #= Y + Z.

smallerInvalidExists(N) :-
    N1 #< N,
    num(N1, X),
    \+ valid(N1, X).

solve(X) :-
    num(N, X),
    \+ valid(N, X),
    \+ smallerInvalidExists(N).

main :-
    retractall(num(_,_)),
    phrase_from_file(parse(D), "input"),
    assert_data(D, 1),
    solve(Result),
    writeln(Result).