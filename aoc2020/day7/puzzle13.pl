:- use_module(library(clpfd)).
:- use_module(library(pio)).
:- set_prolog_flag(double_quotes,codes).

:- dynamic color/1.
:- dynamic contains/3.

all_chars([H]) --> [H], {[H] \= "\n", [H] \= " "}.
all_chars([H|T]) --> [H], {[H] \= "\n", [H] \= " "}, all_chars(T).
color(P) --> all_chars(P1), " ", all_chars(P2), {append(P1, " ", X), append(X, P2, P)}.
bag --> " bag".
bag --> " bags".
contained_colors([]) --> "no other bags.".
contained_colors([N,C]) --> all_chars(N), " ", color(C), bag, ".".
contained_colors([N,C|T]) --> all_chars(N), " ", color(C), bag, ", ", contained_colors(T).
parse([[A,C]|L]) --> color(A), " bags contain ", contained_colors(C), "\n", parse(L).
parse([]) --> [].

assert_colors(_, []).
assert_colors(Color, [Number, OtherColor|ContainedColors]) :-
    atom_codes(C, Color),
    number_codes(N, Number),
    atom_codes(OC, OtherColor),
    assert(contains(C, N, OC)),
    assert_colors(Color, ContainedColors).

assert_data([]).
assert_data([[Color,ContainedColors]|T]) :-
    atom_codes(C, Color),
    assert(color(C)),
    assert_colors(Color, ContainedColors),
    assert_data(T).

contains(X, Y) :- contains(X, _, Y).
contains(X, Y) :- contains(X, _, Z), contains(Z, Y).

contains_gold(X) :- contains(X, 'shiny gold'), !.
gold_bag(X) :- color(X), contains_gold(X).

main :-
    retractall(color(_)),
    retractall(contains(_,_,_)),
    phrase_from_file(parse(D), "input"),
    assert_data(D),
    findall(X, gold_bag(X), L),
    length(L, N),
    writeln(N).
