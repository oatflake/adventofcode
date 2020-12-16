:- use_module(library(clpfd)).
:- use_module(library(pio)).
:- set_prolog_flag(double_quotes,codes).

:- dynamic rule/6.
:- dynamic your_ticket/1.
:- dynamic nearby_ticket/1.

all_chars([H]) --> [H], {[H] \= "\n", [H] \= ","}.
all_chars([H|T]) --> [H], {[H] \= "\n", [H] \= ","}, all_chars(T).
rule([I, range(Min1,Max1), range(Min2,Max2), yes], I) --> 
    "departure", all_chars(_),": ",all_chars(Min1),"-",all_chars(Max1),
    " or ",all_chars(Min2),"-",all_chars(Max2),"\n".
rule([I, range(Min1,Max1), range(Min2,Max2), no], I) --> 
    all_chars(Name),": ",{\+append("departure", _, Name)},all_chars(Min1),"-",all_chars(Max1),
    " or ",all_chars(Min2),"-",all_chars(Max2),"\n".
rules([], _) --> [].
rules(R, I) --> rule(L, I), { I1 #= I + 1 }, rules(T, I1), { append(L, T, R) }.
ticket_numbers([N]) --> all_chars(N), "\n".
ticket_numbers([N|T]) --> all_chars(N), ",", ticket_numbers(T).
your_ticket(T) --> "your ticket:\n", ticket_numbers(T).
tickets([]) --> [].
tickets([H|T]) --> ticket_numbers(H), tickets(T).
nearby_tickets(N) --> "nearby tickets:\n", tickets(N).
parse([R,T,N]) -->  rules(R, 1), "\n", your_ticket(T), "\n", nearby_tickets(N).
parse([]) --> [].

assert_rules([]).
assert_rules([I, range(Min, Max), range(Min1, Max1), Departure |T]) :-
    number_codes(A, Min),
    number_codes(B, Max),
    number_codes(C, Min1),
    number_codes(D, Max1),
    assert(rule(I, A, B, C, D, Departure)),
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

valid_ticket(L) :-
    nearby_ticket(L),
    \+ (member(X, L),
        \+ (rule(_, Min, Max, Min1, Max1, _), (X in Min..Max; X in Min1..Max1))
    ).

match_field_rule(K, N, ValidTickets) :- 
    rule(K, Min, Max, Min1, Max1, _),
    \+ (member(T, ValidTickets), 
        nth1(N, T, X),
        (X #< Min; X #> Max, X #< Min1; X #> Max1)).

product([], Acc, Acc).
product([H|T], Acc, Result) :- Acc1 #= Acc * H, product(T, Acc1, Result).

select_rules([],[],_,[]).
select_rules(Rules, Fields, ValidTickets, [matching(Rule,Field)|Sol]) :-
    select(Rule, Rules, Rules2),
    select(Field, Fields, Fields2),
    match_field_rule(Rule, Field, ValidTickets),
    \+ (member(Field2, Fields2), match_field_rule(Rule, Field2, ValidTickets)),
    select_rules(Rules2, Fields2, ValidTickets, Sol).

sorted_list([1], 1).
sorted_list([N|T], N) :- N > 1, N1 #= N - 1, sorted_list(T, N1).

solve(Result) :-
    findall(X, valid_ticket(X), ValidTickets),
    your_ticket(YourTicket),
    length(YourTicket, Len),
    sorted_list(Fields, Len),
    sorted_list(Rules, Len),
    select_rules(Rules, Fields, ValidTickets, Sol),
    findall(I, rule(I, _, _, _, _, yes), DepartureRules),
    findall(Elem, 
        (member(I1, DepartureRules), member(matching(I1, F), Sol), 
        nth1(F, YourTicket, Elem)), V),
    product(V, 1, Result).

main :-
    retractall(rule(_,_,_,_,_,_)),
    retractall(your_ticket(_)),
    retractall(nearby_ticket(_)),
    phrase_from_file(parse(D), "input"),
    assert_data(D),
    solve(Result),
    writeln(Result).