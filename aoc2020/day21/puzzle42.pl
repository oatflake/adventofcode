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

ingredient_could_contain_allergent(I, A) :-
    ingredient(I),
    allergent(A),
    \+ (food(F),
    food_allergent(F, A),
    \+ food_ingredient(F, I)).

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

remove_combinations(_, [], []).
remove_combinations([I, A], [[X, B]|T], [[X, B]|T1]) :- X \= I, B \= A, remove_combinations([I, A], T, T1).
remove_combinations([I, A], [[_, A]|T], T1) :- remove_combinations([I, A], T, T1).
remove_combinations([I, A], [[I, _]|T], T1) :- remove_combinations([I, A], T, T1).

pickIngredientAllergent([],[]).
pickIngredientAllergent(L, [[I,A]|T]) :-
    select([I,A], L, R),
    \+ member([_, A], R),
    remove_combinations([I,A], L, L1),
    pickIngredientAllergent(L1, T), !.

solve(Result) :-
    findall([I, A], ingredient_could_contain_allergent(I, A), L),
    pickIngredientAllergent(L, L1),
    sort(2, @=<, L1, Sorted),
    maplist(nth0(0), Sorted, Result).

main :-
    retractall(food(_)),
    retractall(ingredient(_)),
    retractall(allergent(_)),
    retractall(food_ingredient(_, _)),
    retractall(food_allergent(_, _)),
    phrase_from_file(parse(D), "input"),
    assert_data(D, 0),
    solve(Result),
    writeln(Result).