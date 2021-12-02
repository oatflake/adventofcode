:- use_module(library(clpfd)).
:- use_module(library(pio)).
:- set_prolog_flag(double_quotes,codes).

all_chars([Head]) --> [Head], {[Head] \= "\n", [Head] \= " "}.
all_chars([Head|Tail]) --> [Head], {[Head] \= "\n"}, all_chars(Tail).
parse([(Dir, Units)]) --> all_chars(Dir), " ", all_chars(Units), "\n".
parse([(Dir, Units)|Tail]) --> all_chars(Dir), " ", all_chars(Units), "\n", parse(Tail).

solve([], (Horizontal, Depth), Result) :-
    Result #= Horizontal * Depth.
solve([(up, Units)|Tail], (Horizontal, Depth), Result) :- 
    NewDepth #= Depth - Units,
    solve(Tail, (Horizontal, NewDepth), Result).
solve([(down, Units)|Tail], (Horizontal, Depth), Result) :- 
    NewDepth #= Depth + Units,
    solve(Tail, (Horizontal, NewDepth), Result).
solve([(forward, Units)|Tail], (Horizontal, Depth), Result) :- 
    NewHorizontal #= Horizontal + Units,
    solve(Tail, (NewHorizontal, Depth), Result).

convert((Dir, Units), (DirAsString, UnitsAsString)) :-
    atom_codes(Dir, DirAsString),
    number_codes(Units, UnitsAsString).

main :-
    phrase_from_file(parse(DataAsStrings), "input"),
    maplist(convert, Data, DataAsStrings),
    solve(Data, (0, 0), Result),
    writeln(Result).