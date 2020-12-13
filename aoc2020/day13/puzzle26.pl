:- use_module(library(clpfd)).
:- use_module(library(pio)).
:- set_prolog_flag(double_quotes,codes).

all_chars([H]) --> [H], {[H] \= "\n", [H] \= " ", [H] \= ",", [H] \= "x" }.
all_chars([H|T]) --> [H], {[H] \= "\n", [H] \= " ", [H] \= ",", [H] \= "x" }, all_chars(T).
parse([X,T], 0, _) --> all_chars(X), "\n", parse(T, 1, 0).
parse([[X, N]|T], 1, N) --> { N1 #= N + 1 }, all_chars(X), ",", parse(T, 1, N1).
parse(T, 1, N) --> { N1 #= N + 1 }, "x,", parse(T, 1, N1).
parse([[X, N]|T], 1, N) --> all_chars(X), "\n", parse(T, 2, _).
parse([], 2, _) --> [].

convert_buses_data([],[]).
convert_buses_data([[H1,N]|T], [b(B, N)|Buses]) :-
    number_codes(B, H1),
    convert_buses_data(T, Buses).

convert_data([_,B], Buses) :-
    convert_buses_data(B, Buses).

id_product([], Acc, Acc).
id_product([b(ID, _)|T], Acc, Result) :-
    Acc1 #= ID * Acc,
    id_product(T, Acc1, Result).

chinese_remainder([], _, Acc, Acc).
chinese_remainder([b(ID, Offset)|Buses], M, Acc, Result) :-
    Mi #= M // ID,
    gcdExtended(ID, Mi, 1, _, S), 
    Ei #= S * Mi,
    Acc1 #= Acc + Ei * (ID - Offset),
    chinese_remainder(Buses, M, Acc1, Result).

solve(Buses, Time) :-
    id_product(Buses, 1, M),
    chinese_remainder(Buses, M, 0, Time1),
    Time #= Time1 mod M.

main :-
    phrase_from_file(parse(D, 0, _), "input"),
    convert_data(D, Buses),
    solve(Buses, Time),
    writeln(Time).


% --- adapted from https://www.geeksforgeeks.org/euclidean-algorithms-basic-and-extended/ ---
% gcdExtended(+A, +B, -G, -X, -Y)
gcdExtended(0, B, B, 0, 1).
gcdExtended(A, B, G, X, Y) :- 
    A #\= 0,
    B1 #= B mod A,
    gcdExtended(B1, A, G, X1, Y1),
    X #= Y1 - (B // A) * X1,
    Y #= X1.
% -------------------------------------------------------------------------------------------