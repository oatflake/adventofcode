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

contained_bags(X, N, Y) :- contains(X, N, Y).
contained_bags(X, N, Y) :- contains(X, N1, Z), contained_bags(Z, N2, Y), N #= N1 * N2.

main :-
    retractall(color(_)),
    retractall(contains(_,_,_)),
    phrase_from_file(parse(D), "input"),
    assert_data(D),
    findall(K, contained_bags('shiny gold', K, _), L),
    sum(L, #=, N),
    writeln(N).

