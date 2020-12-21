:- use_module(library(clpfd)).
:- use_module(library(pio)).
:- set_prolog_flag(double_quotes,codes).

:- dynamic food/1.
:- dynamic ingredient/1.
:- dynamic allergent/1.
:- dynamic food_ingredient/2.
:- dynamic food_allergent/2.

all_chars([H]) --> [H], {[H] \= "\n", [H] \= " "}.
all_chars([H|T]) --> [H], {[H] \= "\n", [H] \= " "}, all_chars(T).
allergents([H]) -->  all_chars(H).
allergents([H|T]) -->  all_chars(H), ", ", allergents(T).
allergentListing(A) --> "(contains ", allergents(A), ")".
ingredients([H]) --> all_chars(H).
ingredients([H|T]) --> all_chars(H), " ", ingredients(T).
food([I, A]) --> ingredients(I), " ", allergentListing(A).
parse([H]) --> food(H), "\n".
parse([H|T]) --> food(H), "\n", parse(T).

non_allergent_containing_ingredience_appearances(N) :-
    findall(F, (ingredient_could_not_contain_any_allergent(I), food_ingredient(F, I)), L),
    length(L, N).

ingredient_could_not_contain_any_allergent(I) :-
    ingredient(I),
    \+ (allergent(A), \+ ingredient_could_not_contain_allergent(I, A)).

ingredient_could_not_contain_allergent(I, A) :-
    food_allergent(F, A), \+ food_ingredient(F, I).

assert_once(X) :- X, ! ; assert(X).

assert_food_stuff(_, _, [], _).
assert_food_stuff(A, B, [H|T], F) :-
    atom_codes(I, H),
    X =.. [A, I],
    assert_once(X),
    Y =.. [B, F, I],
    assert(Y),
    assert_food_stuff(A, B, T, F).

assert_data([], _).
assert_data([[I, A]|T], N) :-
    assert(food(N)),
    assert_food_stuff(ingredient, food_ingredient, I, N),
    assert_food_stuff(allergent, food_allergent, A, N),
    N1 #= N + 1,    
    assert_data(T, N1).

main :-
    retractall(food(_)),
    retractall(ingredient(_)),
    retractall(allergent(_)),
    retractall(food_ingredient(_, _)),
    retractall(food_allergent(_, _)),
    phrase_from_file(parse(D), "input"),
    assert_data(D, 0),
    non_allergent_containing_ingredience_appearances(N),
    writeln(N).