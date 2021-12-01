:- use_module(library(clpfd)).
:- use_module(library(pio)).
:- set_prolog_flag(double_quotes,codes).

all_chars([Head]) --> [Head], {[Head] \= "\n", [Head] \= " "}.
all_chars([Head|Tail]) --> [Head], {[Head] \= "\n", [Head] \= " "}, all_chars(Tail).
parse([[Action, Value]|Tail]) --> [Action], all_chars(Value), "\n", parse(Tail).
parse([]) --> [].

convert_data([], []).
convert_data([[ActionAsString, ValueAsString]|Tail], [data(ActionAsAtom, ValueAsAtom)|List]) :-
    number_codes(ValueAsAtom, ValueAsString),
    atom_char(ActionAsAtom, ActionAsString),
    convert_data(Tail, List).

% move(ACtion, Value, OldTransform, WayPoint, NewTransform, NewWayPoint)
move('N', Num, T, waypoint(WX, WY), T, waypoint(WX, WY1)) :- WY1 #= WY + Num.
move('E', Num, T, waypoint(WX, WY), T, waypoint(WX1, WY)) :- WX1 #= WX + Num.
move('S', Num, T, waypoint(WX, WY), T, waypoint(WX, WY1)) :- WY1 #= WY - Num.
move('W', Num, T, waypoint(WX, WY), T, waypoint(WX1, WY)) :- WX1 #= WX - Num.
move('F', Num, transform(X, Y), waypoint(WX, WY), transform(X1, Y1), waypoint(WX, WY)) :- X1 #= X + WX * Num, Y1 #= Y + WY * Num.
move('R', 90, T, waypoint(WX, WY), T, waypoint(WX1, WY1)) :- WX1 #= WY, WY1 #= -WX.
move('R', 180, T, waypoint(WX, WY), T, waypoint(WX1, WY1)) :- WX1 #= -WX, WY1 #= -WY.
move('R', 270, T, waypoint(WX, WY), T, waypoint(WX1, WY1)) :- WX1 #= -WY, WY1 #= WX.
move('L', Num, T, W, T, W1) :- Num1 #= 360 - Num, move('R', Num1, T, W, T, W1).

solve([], Transform, _, Transform).
solve([data(Action, Num)|Tail], OldTransform, OldWayPoint, NewTransform) :-
    move(Action, Num, OldTransform, OldWayPoint, Transform2, WayPoint2),
    solve(Tail, Transform2, WayPoint2, NewTransform).

main :-
    retractall(num(_,_)),
    phrase_from_file(parse(Data), "input"),
    convert_data(Data, List),
    solve(List, transform(0, 0), waypoint(10, 1), transform(X, Y)),
    Distance #= abs(X) + abs(Y),
    writeln(Distance).