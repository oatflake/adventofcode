:- use_module(library(clpfd)).
:- use_module(library(pio)).
:- set_prolog_flag(double_quotes,codes).

:- dynamic rule/2.
:- dynamic your_ticket/1.
:- dynamic nearby_ticket/1.

all_chars([H]) --> [H], {[H] \= "\n", [H] \= ","}.
all_chars([H|T]) --> [H], {[H] \= "\n", [H] \= ","}, all_chars(T).
rule([range(Min1,Max1),range(Min2,Max2)]) --> 
    all_chars(_),": ",all_chars(Min1),"-",all_chars(Max1),
    " or ",all_chars(Min2),"-",all_chars(Max2),"\n".
rules([]) --> [].
rules(R) --> rule(L), rules(T), { append(L, T, R) }.
ticket_numbers([N]) --> all_chars(N), "\n".
ticket_numbers([N|T]) --> all_chars(N), ",", ticket_numbers(T).
your_ticket(T) --> "your ticket:\n", ticket_numbers(T).
tickets([]) --> [].
tickets([H|T]) --> ticket_numbers(H), tickets(T).
nearby_tickets(N) --> "nearby tickets:\n", tickets(N).
parse([R,T,N]) -->  rules(R), "\n", your_ticket(T), "\n", nearby_tickets(N).
parse([]) --> [].

assert_rules([]).
assert_rules([range(Min, Max)|T]) :-
    number_codes(A, Min),
    number_codes(B, Max),
    assert(rule(A, B)),
    assert_rules(T).

convert_number_list([], []).
convert_number_list([H|T], [H1|T1]) :-
    number_codes(H1, H),
    convert_number_list(T, T1).

assert_your_ticket(T) :-
    convert_number_list(T, T1),
    assert(your_ticket(T1)).

assert_nearby_tickets([]).
assert_nearby_tickets([H|T]) :-
    convert_number_list(H, H1),
    assert(nearby_ticket(H1)),
    assert_nearby_tickets(T).

assert_data([R,T,N]) :-
    assert_rules(R),
    assert_your_ticket(T),
    assert_nearby_tickets(N).

invalid(X) :-
    nearby_ticket(L),
    member(X, L),
    \+ (rule(Min, Max),
    X in Min..Max).

solve(Result) :-
    findall(X, invalid(X), L),
    sum(L, #=, Result).

main :-
    retractall(rule(_,_)),
    retractall(your_ticket(_)),
    retractall(nearby_ticket(_)),
    phrase_from_file(parse(D), "input"),
    assert_data(D),
    solve(Result),
    writeln(Result).