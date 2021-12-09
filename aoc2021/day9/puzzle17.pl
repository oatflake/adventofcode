% slow enough as it is, switching to c++ for part 2...

:- use_module(library(clpfd)).
:- use_module(library(pio)).
:- set_prolog_flag(double_quotes,codes).

:- dynamic location/3.

digit(Digit) --> [Char], { [Char] \= "\n", number_codes(Digit, [Char]) }.
parse(X,Y,[(X,Y,Height)|Tail]) --> digit(Height), { IncreasedX #= X + 1 }, parse(IncreasedX, Y, Tail).
parse(_,Y,Locations) --> "\n", { IncreasedY #= Y + 1 }, parse(0, IncreasedY, Locations).
parse(_,_,[]) --> "\n".

assertLocations([]).
assertLocations([(X, Y, Height)|Tail]) :- assert(location(X, Y, Height)), assertLocations(Tail).

lowpoint(X, Y, Height) :- 
    location(X, Y, Height), 
    abs(X - X1) + abs(Y - Y1) #= 1,
    Height1 #=< Height,
    \+ location(X1, Y1, Height1).

main :-
    retractall(locations(_,_,_)),
    phrase_from_file(parse(0, 0, Locations), "input"),
    assertLocations(Locations),
    findall(Height, lowpoint(_, _, Height), List),
    sum(List, #=, HeightsSum),
    length(List, NumberOfLowpoints),
    Result #= HeightsSum + NumberOfLowpoints,
    writeln(Result).

