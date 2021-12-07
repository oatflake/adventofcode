:- use_module(library(clpfd)).
:- use_module(library(pio)).
:- set_prolog_flag(double_quotes,codes).

all_chars([Head]) --> [Head], {[Head] \= "\n", [Head] \= ","}.
all_chars([Head|Tail]) --> [Head], {[Head] \= "\n", [Head] \= ","}, all_chars(Tail).
parse([Number]) --> all_chars(Number), "\n".
parse([Number|Tail]) -->  all_chars(Number), "," , parse(Tail).

distance(Positions, TargetPosition, Result) :-
    foldl({TargetPosition}/[X, Y, Z]>>( D #= abs(X - TargetPosition), Z #= Y + ((D * (D + 1)) div 2) ), Positions, 0, Result).

binSearch(Positions, Start, End, Mid) :-
    Mid #= (End + Start) div 2,
    A #= Mid - 1,
    B #= Mid + 1,
    distance(Positions, Mid, Dist),
    distance(Positions, A, DistA),
    distance(Positions, B, DistB),
    Dist #< DistA,
    Dist #< DistB.
binSearch(Positions, Start, End, X) :-
    Mid #= (End + Start) div 2,
    A #= Mid - 1,
    distance(Positions, Mid, Dist),
    distance(Positions, A, DistA),
    DistA #< Dist,
    binSearch(Positions, Start, A, X).
binSearch(Positions, Start, End, X) :-
    Mid #= (End + Start) div 2,
    B #= Mid + 1,
    distance(Positions, Mid, Dist),
    distance(Positions, B, DistB),
    Dist #> DistB,
    binSearch(Positions, B, End, X).

main :-
    phrase_from_file(parse(DataAsStrings), "input"),
    maplist(number_codes, Numbers, DataAsStrings),
    min_list(Numbers, Min),
    max_list(Numbers, Max),
    binSearch(Numbers, Min, Max, Pos),
    distance(Numbers, Pos, Result),
    writeln(Result).
