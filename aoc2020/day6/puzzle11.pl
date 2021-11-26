:- use_module(library(pio)).
:- use_module(library(clpfd)).
:- set_prolog_flag(double_quotes,codes).

all_chars([Head]) --> [Head], {[Head] \= "\n"}.
all_chars([Head|Tail]) --> [Head], {[Head] \= "\n"}, all_chars(Tail).
% flatten answers of group members into one list
group(List) --> all_chars(Head), "\n", group(Tail), {append(Head, Tail, List)}.
group(Head) --> all_chars(Head), "\n".
parse([Group|Tail]) --> group(Group), "\n", parse(Tail).
parse([Group]) --> group(Group).

printGroups([]).
printGroups([HeadAsString|Tail]) :- atom_codes(HeadAsAtom, HeadAsString), writeln(HeadAsAtom), printGroups(Tail).

removeDuplicates([], []).
removeDuplicates([Head|Tail], [Head|NewList]) :- \+ member(Head, Tail), removeDuplicates(Tail, NewList).
removeDuplicates([Head|Tail], NewList) :- once(member(Head, Tail)), removeDuplicates(Tail, NewList).

sumOfGroupWiseUniqueAnswers([], 0).
sumOfGroupWiseUniqueAnswers([Head|Tail], Result) :-
    removeDuplicates(Head, GroupAnswersWithoutDuplicates),
    length(GroupAnswersWithoutDuplicates, NumberOfUniqueAnswers),
    Result #= NumberOfUniqueAnswers + Rest,
    sumOfGroupWiseUniqueAnswers(Tail, Rest).

main :-
    phrase_from_file(parse(Data), "input"),
    %printGroups(Data),
    sumOfGroupWiseUniqueAnswers(Data, Result),
    writeln(Result).
