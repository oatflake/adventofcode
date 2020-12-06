:- use_module(library(pio)).
:- use_module(library(clpfd)).
:- set_prolog_flag(double_quotes,codes).

all_chars([H]) --> [H], {[H] \= "\n"}.
all_chars([H|T]) --> [H], {[H] \= "\n"}, all_chars(T).
group([H|T]) --> all_chars(H), "\n", group(T).
group([H]) --> all_chars(H), "\n".
parse([A|L]) --> group(A), "\n", parse(L).
parse([A]) --> group(A).

group_intersection([X], X).
group_intersection([X,Y|T], L) :-
    intersection(X,Y,I),
    group_intersection([I|T], L).

count([], 0).
count([H|T], R) :-
    group_intersection(H, L),
    length(L, N),
    R #= N + N1,
    count(T, N1).

main :-
    phrase_from_file(parse(L), "input"),
    count(L, N),
    writeln(N).
