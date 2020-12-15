:- use_module(library(clpfd)).
:- use_module(library(pio)).
:- use_module(library(rbtrees)).

take_turn(_, 30000000, LastNumber, LastNumber).
take_turn(Dict, LastTurn, LastNumber, Result) :-
    LastTurn #< 30000000,
    (rb_lookup(LastNumber, PreviousTurn, Dict) ->
    Age #= LastTurn - PreviousTurn;
    Age #= 0),
    rb_insert(Dict, LastNumber, LastTurn, Dict2),
    CurrentTurn #= LastTurn + 1,
    take_turn(Dict2, CurrentTurn, Age, Result).

initialize_dict([], _, Dict, Dict).
initialize_dict([H|T], Turn, Dict, NewDict) :-
    rb_insert_new(Dict, H, Turn, Dict2),
    Turn1 #= Turn + 1,
    initialize_dict(T, Turn1, Dict2, NewDict).

main :-
    FirstInputNumbers = [1,12,0,20,8],
    LastInputNumber = 16,
    LastInputTurn = 6,
    rb_empty(EmptyDict),
    initialize_dict(FirstInputNumbers, 1, EmptyDict, Dict),
    take_turn(Dict, LastInputTurn, LastInputNumber, Result),
    writeln(Result).