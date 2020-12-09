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

smallestInvalidNumber(X) :-
    num(N, X),
    \+ valid(N, X),
    \+ smallerInvalidExists(N).

sumOfRange(L, U, Acc, Result) :- 
    L #= U - 1, 
    num(L, N), 
    num(U, N1), 
    Result #= Acc + N + N1.
sumOfRange(L, U, Acc, Result) :-
    L #< U - 1,
    num(L, N),
    L1 #= L + 1,
    Acc1 #= Acc + N,
    sumOfRange(L1, U, Acc1, Result).

smallerInRangeExists(L, U, M) :-
    K in L..U,
    num(K, N),
    N #< M.

minInRange(L, U, Min) :-
    K in L..U,
    num(K, Min),
    \+ smallerInRangeExists(L, U, Min).

largerInRangeExists(L, U, M) :-
    K in L..U,
    num(K, N),
    N #> M.

maxInRange(L, U, Max) :-
    K in L..U,
    num(K, Max),
    \+ largerInRangeExists(L, U, Max).

solve(Invalid, Result) :-
    sumOfRange(L, U, 0, Invalid),
    minInRange(L, U, Min),
    maxInRange(L, U, Max),
    Result #= Min + Max.

main :-
    retractall(num(_,_)),
    phrase_from_file(parse(D), "input"),
    assert_data(D, 1),
    smallestInvalidNumber(Invalid),
    solve(Invalid, Result),
    writeln(Result).