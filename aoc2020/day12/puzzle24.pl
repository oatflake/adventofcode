:- use_module(library(clpfd)).
:- use_module(library(pio)).
:- set_prolog_flag(double_quotes,codes).

all_chars([H]) --> [H], {[H] \= "\n", [H] \= " "}.
all_chars([H|T]) --> [H], {[H] \= "\n", [H] \= " "}, all_chars(T).
parse([[D, X]|T]) --> [D], all_chars(X), "\n", parse(T).
parse([]) --> [].

convert_data([], []).
convert_data([[D, X]|T], [d(Char, Num)|L]) :-
    number_codes(Num, X),
    atom_char(Char, D),
    convert_data(T, L).

% move(Dir, Num, OldTransform, WayPoint, NewTransform, NewWayPoint)
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
solve([d(Dir, Num)|T], OldTransform, OldWayPoint, NewTransform) :-
    move(Dir, Num, OldTransform, OldWayPoint, Transform2, WayPoint2),
    solve(T, Transform2, WayPoint2, NewTransform).

main :-
    retractall(num(_,_)),
    phrase_from_file(parse(D), "input"),
    convert_data(D, L),
    solve(L, transform(0, 0), waypoint(10, 1), transform(X, Y)),
    Dist #= abs(X) + abs(Y),
    writeln(Dist).