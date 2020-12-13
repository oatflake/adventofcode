:- use_module(library(clpfd)).
:- use_module(library(pio)).
:- set_prolog_flag(double_quotes,codes).

all_chars([H]) --> [H], {[H] \= "\n", [H] \= " ", [H] \= ",", [H] \= "x" }.
all_chars([H|T]) --> [H], {[H] \= "\n", [H] \= " ", [H] \= ",", [H] \= "x" }, all_chars(T).
parse([X,T], 0) --> all_chars(X), "\n", parse(T, 1).
parse([X|T], 1) --> all_chars(X), ",", parse(T, 1).
parse(T, 1) --> "x,", parse(T, 1).
parse([X|T], 1) --> all_chars(X), "\n", parse(T, 2).
parse([], 2) --> [].

convert_buses_data([],[]).
convert_buses_data([H|T], [B|Buses]) :-
    number_codes(B, H),
    convert_buses_data(T, Buses).

convert_data([T,B], Time, Buses) :-
    number_codes(Time, T),
    convert_buses_data(B, Buses).

solve(Time, [], ID, Result) :- Result #= (ID - (Time mod ID)) * ID.
solve(Time, [H|T], ID, Result) :-
    (H - (Time mod H) #< ID - (Time mod ID) 
    -> MinID #= H; 
    MinID #= ID), 
    solve(Time, T, MinID, Result).

main :-
    phrase_from_file(parse(D, 0), "input"),
    convert_data(D, Time, [H|Buses]),
    solve(Time, Buses, H, Result),
    writeln(Result).