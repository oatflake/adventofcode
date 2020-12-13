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

% move(Dir, Num, OldTransform, NewTransform)
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
solve([d(Dir, Num)|T], OldTransform, NewTransform) :-
    move(Dir, Num, OldTransform, Transform2),
    solve(T, Transform2, NewTransform).

main :-
    retractall(num(_,_)),
    phrase_from_file(parse(D), "input"),
    convert_data(D, L),
    solve(L, transform(0, 0, 0), transform(X, Y, _)),
    Dist #= abs(X) + abs(Y),
    writeln(Dist).