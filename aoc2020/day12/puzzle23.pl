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

% transform(XCoord, YCoord, Rotation)
% move(Action, Value, OldTransform, NewTransform)
move('N', Num, transform(X, Y, R), transform(X, Y1, R)) :- Y1 #= Y + Num.
move('E', Num, transform(X, Y, R), transform(X1, Y, R)) :- X1 #= X + Num.
move('S', Num, transform(X, Y, R), transform(X, Y1, R)) :- Y1 #= Y - Num.
move('W', Num, transform(X, Y, R), transform(X1, Y, R)) :- X1 #= X - Num.
move('F', Num, transform(X, Y, 0), NewTransform) :- move('E', Num, transform(X, Y, 0), NewTransform).
move('F', Num, transform(X, Y, 180), NewTransform) :- move('W', Num, transform(X, Y, 180), NewTransform).
move('F', Num, transform(X, Y, 90), NewTransform) :- move('S', Num, transform(X, Y, 90), NewTransform).
move('F', Num, transform(X, Y, 270), NewTransform) :- move('N', Num, transform(X, Y, 270), NewTransform).
move('R', Num, transform(X, Y, R), transform(X, Y, R1)) :- R1 #= (R + Num + 360) mod 360.
move('L', Num, transform(X, Y, R), transform(X, Y, R1)) :- R1 #= (R - Num + 360) mod 360.

solve([], Transform, Transform).
solve([data(Action, Value)|Tail], OldTransform, NewTransform) :-
    move(Action, Value, OldTransform, Transform2),
    solve(Tail, Transform2, NewTransform).

main :-
    retractall(num(_,_)),
    phrase_from_file(parse(Data), "input"),
    convert_data(Data, List),
    solve(List, transform(0, 0, 0), transform(X, Y, _)),
    Distance #= abs(X) + abs(Y),
    writeln(Distance).