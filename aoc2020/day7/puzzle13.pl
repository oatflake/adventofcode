:- use_module(library(clpfd)).
:- use_module(library(pio)).
:- set_prolog_flag(double_quotes,codes).

:- dynamic color/1.
% bag color, number, other bag color
:- dynamic contains/3.

all_chars([Head]) --> [Head], {[Head] \= "\n", [Head] \= " "}.
all_chars([Head|Tail]) --> [Head], {[Head] \= "\n", [Head] \= " "}, all_chars(Tail).
color(Total) --> all_chars(Part1), " ", all_chars(Part2), {append(Part1, " ", X), append(X, Part2, Total)}.
bag --> " bag".
bag --> " bags".
contained_colors([]) --> "no other bags.".
contained_colors([Number,Color]) --> all_chars(Number), " ", color(Color), bag, ".".
contained_colors([Number,Color|Tail]) --> all_chars(Number), " ", color(Color), bag, ", ", contained_colors(Tail).
parse([[Color,ContainedBags]|Tail]) --> color(Color), " bags contain ", contained_colors(ContainedBags), "\n", parse(Tail).
parse([]) --> [].

assert_colors(_, []).
assert_colors(ColorAsString, [NumberAsString, OtherColorAsString|ContainedColors]) :-
    atom_codes(ColorAsAtom, ColorAsString),
    number_codes(Number, NumberAsString),
    atom_codes(OtherColorAsAtom, OtherColorAsString),
    assert(contains(ColorAsAtom, Number, OtherColorAsAtom)),
    assert_colors(ColorAsString, ContainedColors).

assert_data([]).
assert_data([[ColorAsString,ContainedColors]|Tail]) :-
    atom_codes(ColorAsAtom, ColorAsString),
    assert(color(ColorAsAtom)),
    assert_colors(ColorAsString, ContainedColors),
    assert_data(Tail).

contains(Color, OtherColor) :- contains(Color, _, OtherColor).
contains(Color, OtherColor) :- contains(Color, _, Inbetween), contains(Inbetween, OtherColor).

contains_gold(Color) :- contains(Color, 'shiny gold'), !.
gold_bag(Color) :- color(Color), contains_gold(Color).

main :-
    retractall(color(_)),
    retractall(contains(_,_,_)),
    phrase_from_file(parse(Data), "input"),
    assert_data(Data),
    findall(Color, gold_bag(Color), List),
    length(List, Result),
    writeln(Result).
