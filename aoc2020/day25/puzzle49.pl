:- use_module(library(clpfd)).
:- use_module(library(pio)).
:- set_prolog_flag(double_quotes,codes).

all_chars([H]) --> [H], {[H] \= "\n"}.
all_chars([H|T]) --> [H], {[H] \= "\n"}, all_chars(T).
parse([K1, K2]) --> all_chars(K1), "\n", all_chars(K2), "\n".

find_loop(Value, Value, Loop, Loop).
find_loop(Value, Key, Loop, Result) :-
    Value #\= Key,
    Value1 #= (Value * 7) mod 20201227,
    Loop1 #= Loop + 1,
    find_loop(Value1, Key, Loop1, Result).

transform(_, Value, 0, Value).
transform(Subject, Value, Loop, Key) :-
    Loop #> 0,
    Value1 #= (Value * Subject) mod 20201227,
    Loop1 #= Loop - 1,
    transform(Subject, Value1, Loop1, Key).

solve(Key1, Key2, Result) :- 
    find_loop(1, Key1, 0, Loop1),
    %transform(7, 1, Loop1, Key1), % using this instead of find_loop blows the stack
    transform(Key2, 1, Loop1, Result).
    
main :-
    phrase_from_file(parse([K1, K2]), "input"),
    number_codes(Key1, K1),
    number_codes(Key2, K2),
    solve(Key1, Key2, Result),
    writeln(Result).