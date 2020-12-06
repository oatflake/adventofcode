:- use_module(library(pio)).
:- use_module(library(clpfd)).
:- set_prolog_flag(double_quotes,codes).

all_chars([H]) --> [H], {[H] \= "\n"}.
all_chars([H|T]) --> [H], {[H] \= "\n"}, all_chars(T).
group(L) --> all_chars(H), "\n", group(T), {append(H, T, L)}.
group(H) --> all_chars(H), "\n".
parse([A|L]) --> group(A), "\n", parse(L).
parse([A]) --> group(A).

printGroups([]).
printGroups([H|T]) :- atom_codes(S, H), writeln(S), printGroups(T).

removeDuplicates([], []).
removeDuplicates([H|T], [H|L]) :- \+ member(H, T), removeDuplicates(T, L).
removeDuplicates([H|T], L) :- once(member(H, T)), removeDuplicates(T, L).

count([], 0).
count([H|T], R) :-
    removeDuplicates(H, H1),
    length(H1, N),
    R #= N + N1,
    count(T, N1).

main :-
    phrase_from_file(parse(L), "input"),
    %printGroups(L),
    count(L, N),
    writeln(N).
