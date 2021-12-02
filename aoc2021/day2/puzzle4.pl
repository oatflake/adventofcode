:- use_module(library(clpfd)).
:- use_module(library(pio)).
:- set_prolog_flag(double_quotes,codes).

all_chars([Head]) --> [Head], {[Head] \= "\n", [Head] \= " "}.
all_chars([Head|Tail]) --> [Head], {[Head] \= "\n"}, all_chars(Tail).
parse([(Dir, Units)]) --> all_chars(Dir), " ", all_chars(Units), "\n".
parse([(Dir, Units)|Tail]) --> all_chars(Dir), " ", all_chars(Units), "\n", parse(Tail).

solve([], (Horizontal, Depth), _, Result) :-
    Result #= Horizontal * Depth.
solve([(up, Units)|Tail], Position, Aim, Result) :- 
    NewAim #= Aim - Units,
    solve(Tail, Position, NewAim, Result).
solve([(down, Units)|Tail], Position, Aim, Result) :- 
    NewAim #= Aim + Units,
    solve(Tail, Position, NewAim, Result).
solve([(forward, Units)|Tail], (Horizontal, Depth), Aim, Result) :- 
    NewHorizontal #= Horizontal + Units,
    NewDepth #= Depth + Aim * Units,
    solve(Tail, (NewHorizontal, NewDepth), Aim, Result).

convert((Dir, Units), (DirAsString, UnitsAsString)) :-
    atom_codes(Dir, DirAsString),
    number_codes(Units, UnitsAsString).

main :-
    phrase_from_file(parse(DataAsStrings), "input"),
    maplist(convert, Data, DataAsStrings),
    solve(Data, (0, 0), 0, Result),
    writeln(Result).