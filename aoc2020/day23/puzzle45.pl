:- use_module(library(clpfd)).
:- use_module(library(pio)).
:- set_prolog_flag(double_quotes,codes).

destination(Current, Cups, Dest) :- Dest #= ((Current + 7) mod 9) + 1, \+ member(Dest, Cups).
destination(Current, Cups, Dest) :- D #= ((Current + 7) mod 9) + 1, member(D, Cups), destination(D, Cups, Dest).

play(L, 0, L).
play([Current,C1,C2,C3|Rest], N, Result) :-
    N #> 0,
    destination(Current, [C1,C2,C3], Dest),
    append(R1, [Dest|R2], Rest),
    append([R1, [Dest,C1,C2,C3|R2], [Current]], L),
    N1 #= N - 1,
    play(L, N1, Result).

clockwise_from_one(List, Result) :-
    append(L, [1|R], List),
    append(R, L, Result).

main :-
    Input = "215694783",
    maplist(([X,Y]>>(Y #= X - 48)), Input, Input1),
    play(Input1, 100, Result),
    clockwise_from_one(Result, Result1),
    maplist(([X,Y]>>(Y #= X + 48)), Result1, ResultStr),
    number_codes(ResultNum, ResultStr),
    writeln(ResultNum).