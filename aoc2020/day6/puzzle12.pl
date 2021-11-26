:- use_module(library(pio)).
:- use_module(library(clpfd)).
:- set_prolog_flag(double_quotes,codes).

all_chars([Head]) --> [Head], {[Head] \= "\n"}.
all_chars([Head|Tail]) --> [Head], {[Head] \= "\n"}, all_chars(Tail).
group([Head|Tail]) --> all_chars(Head), "\n", group(Tail).
group([Head]) --> all_chars(Head), "\n".
parse([Group|Tail]) --> group(Group), "\n", parse(Tail).
parse([Group]) --> group(Group).

group_intersection([IntersectionResult], IntersectionResult).
group_intersection([First,Second|Tail], IntersectionResult) :-
    intersection(First, Second, Intersection),
    group_intersection([Intersection|Tail], IntersectionResult).

sumOfGroupWiseAgreeingAnswers([], 0).
sumOfGroupWiseAgreeingAnswers([Head|Tail], Result) :-
    group_intersection(Head, Intersection),
    length(Intersection, Length),
    Result #= Length + Rest,
    sumOfGroupWiseAgreeingAnswers(Tail, Rest).

main :-
    phrase_from_file(parse(Data), "input"),
    sumOfGroupWiseAgreeingAnswers(Data, Result),
    writeln(Result).
