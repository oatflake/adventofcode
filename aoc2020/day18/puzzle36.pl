:- use_module(library(clpfd)).
:- use_module(library(pio)).
:- set_prolog_flag(double_quotes,codes).

compound_term(compound_term(Seq)) --> "(", sequence(Seq) ,")".
single_number(num(X)) --> [H], {H in 48..58, X #= H - 48}.
operator(mul) --> "*".
operator(add) --> "+".
sequence([Num]) --> single_number(Num).
sequence([Term]) --> compound_term(Term).
sequence([Num,Op|Rest]) --> single_number(Num), " ", operator(Op), " ", sequence(Rest).
sequence([Term,Op|Rest]) --> compound_term(Term), " ", operator(Op), " ", sequence(Rest).
parse([Seq|Rest]) -->  sequence(Seq), "\n", parse(Rest).
parse([]) --> [].

evaluate([num(X)], X).
evaluate([compound_term(Seq)], Result) :-
    evaluate(Seq, Result).
evaluate([X, add, Y], Result) :-
    evaluate([X], R1),
    evaluate([Y], R2),
    Result #= R1 + R2.
evaluate([X, mul, Y], Result) :-
    evaluate([X], R1),
    evaluate([Y], R2),
    Result #= R1 * R2.
evaluate([X, mul, Y, mul, Z|Rest], Result) :-
    evaluate([X], R1),
    evaluate([Y], R2),
    R3 #= R1 * R2,
    evaluate([num(R3),mul,Z|Rest], Result).
evaluate([X, add, Y, Op, Z|Rest], Result) :-
    evaluate([X], R1),
    evaluate([Y], R2),
    R3 #= R1 + R2,
    evaluate([num(R3),Op,Z|Rest], Result).
evaluate([X, mul, Y, add, Z|Rest], Result) :-
    evaluate([X], R1),
    evaluate([Y,add,Z|Rest], R2),
    Result #= R1 * R2.

solve([], 0).
solve([H|T], Result) :-
    evaluate(H, X),
    solve(T, Result1),
    Result #= Result1 + X.

main :-
    phrase_from_file(parse(D), "input"),
    solve(D, Result),
    writeln(Result).