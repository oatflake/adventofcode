:- use_module(library(clpfd)).
:- use_module(library(pio)).
:- set_prolog_flag(double_quotes,codes).

all_chars([Atom]) --> [Head], { [Head] \= "\n", atom_codes(Atom, [Head]) }.
all_chars([Atom|Tail]) --> [Head], { [Head] \= "\n", atom_codes(Atom, [Head]) }, all_chars(Tail).
parse([Line]) --> all_chars(Line), "\n".
parse([Line|Tail]) -->  all_chars(Line), "\n", parse(Tail).

corruptedScore([], _, 0).
corruptedScore([Head|Tail], Stack, Result) :-
    member(Head, [ '(', '[', '{', '<' ]),
    corruptedScore(Tail, [Head|Stack], Result).
corruptedScore([')'|Tail], ['('|Stack], Result) :- corruptedScore(Tail, Stack, Result).
corruptedScore([']'|Tail], ['['|Stack], Result) :- corruptedScore(Tail, Stack, Result).
corruptedScore(['}'|Tail], ['{'|Stack], Result) :- corruptedScore(Tail, Stack, Result).
corruptedScore(['>'|Tail], ['<'|Stack], Result) :- corruptedScore(Tail, Stack, Result).
corruptedScore([')'|_], [Top|_], 3) :- Top \= '('.
corruptedScore([']'|_], [Top|_], 57) :- Top \= '['.
corruptedScore(['}'|_], [Top|_], 1197) :- Top \= '{'.
corruptedScore(['>'|_], [Top|_], 25137) :- Top \= '<'.

corruptedScores([], Accumulator, Accumulator).
corruptedScores([Line|Tail], Accumulator, Result) :-
    corruptedScore(Line, [], Score),
    NewAccumulator #= Accumulator + Score,
    corruptedScores(Tail, NewAccumulator, Result).

main :-
    phrase_from_file(parse(Data), "input"),
    corruptedScores(Data, 0, Result),
    writeln(Result).