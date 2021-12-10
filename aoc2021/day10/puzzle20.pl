:- use_module(library(clpfd)).
:- use_module(library(pio)).
:- set_prolog_flag(double_quotes,codes).

all_chars([Atom]) --> [Head], { [Head] \= "\n", atom_codes(Atom, [Head]) }.
all_chars([Atom|Tail]) --> [Head], { [Head] \= "\n", atom_codes(Atom, [Head]) }, all_chars(Tail).
parse([Line]) --> all_chars(Line), "\n".
parse([Line|Tail]) -->  all_chars(Line), "\n", parse(Tail).

isCorrupted([], Stack, Stack, false).
isCorrupted([Head|Tail], Stack, ResultingStack, Result) :-
    member(Head, [ '(', '[', '{', '<' ]),
    isCorrupted(Tail, [Head|Stack], ResultingStack, Result).
isCorrupted([')'|Tail], ['('|Stack], ResultingStack, Result) :- isCorrupted(Tail, Stack, ResultingStack, Result).
isCorrupted([']'|Tail], ['['|Stack], ResultingStack, Result) :- isCorrupted(Tail, Stack, ResultingStack, Result).
isCorrupted(['}'|Tail], ['{'|Stack], ResultingStack, Result) :- isCorrupted(Tail, Stack, ResultingStack, Result).
isCorrupted(['>'|Tail], ['<'|Stack], ResultingStack, Result) :- isCorrupted(Tail, Stack, ResultingStack, Result).
isCorrupted([')'|_], [Top|_], _, true) :- Top \= '('.
isCorrupted([']'|_], [Top|_], _, true) :- Top \= '['.
isCorrupted(['}'|_], [Top|_], _, true) :- Top \= '{'.
isCorrupted(['>'|_], [Top|_], _, true) :- Top \= '<'.

incompleteScore([], Accumulator, Accumulator).
incompleteScore(['('|Tail], Accumulator, Result) :- 
    NewAccumulator #= 5 * Accumulator + 1, incompleteScore(Tail, NewAccumulator, Result).
incompleteScore(['['|Tail], Accumulator, Result) :- 
    NewAccumulator #= 5 * Accumulator + 2, incompleteScore(Tail, NewAccumulator, Result).
incompleteScore(['{'|Tail], Accumulator, Result) :- 
    NewAccumulator #= 5 * Accumulator + 3, incompleteScore(Tail, NewAccumulator, Result).
incompleteScore(['<'|Tail], Accumulator, Result) :- 
    NewAccumulator #= 5 * Accumulator + 4, incompleteScore(Tail, NewAccumulator, Result).

incompleteScores([], Scores, Scores).
incompleteScores([Line|Tail], Scores, Result) :-
    isCorrupted(Line, [], _, true),
    incompleteScores(Tail, Scores, Result).
incompleteScores([Line|Tail], Scores, Result) :-
    isCorrupted(Line, [], Stack, false),
    incompleteScore(Stack, 0, Score),
    incompleteScores(Tail, [Score|Scores], Result).

main :-
    phrase_from_file(parse(Data), "input"),
    incompleteScores(Data, [], Scores),
    sort(Scores, SortedScores),
    length(SortedScores, Length),
    Middle #= Length div 2,
    nth0(Middle, SortedScores, Result),
    writeln(Result).