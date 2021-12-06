:- use_module(library(clpfd)).
:- use_module(library(pio)).
:- set_prolog_flag(double_quotes,codes).
:- use_module(library(rbtrees)).

all_chars([Head]) --> [Head], {[Head] \= "\n", [Head] \= ","}.
all_chars([Head|Tail]) --> [Head], {[Head] \= "\n", [Head] \= ","}, all_chars(Tail).
parse([Number]) --> all_chars(Number), "\n".
parse([Number|Tail]) -->  all_chars(Number), "," , parse(Tail).

countFishes([], Days, Days).
countFishes([Number|Tail], Days, Result) :-
    length(Prefix, Number),
    append(Prefix, [Entry|Postfix], Days),
    NewEntry #= Entry + 1,
    append(Prefix, [NewEntry|Postfix], NewDays),
    countFishes(Tail, NewDays, Result).

simulate(Fishes, Babies, 0, Result) :-
    sum_list(Fishes, Sum1),
    sum_list(Babies, Sum2),
    Result #= Sum1 + Sum2.
simulate([Fishes|FishesTail], [Babies|BabiesTail], RemainingDays, Result) :-
    RemainingDays #> 0,
    append(BabiesTail, [Fishes], NewBabies),
    AdultFishes #= Fishes + Babies,
    append(FishesTail, [AdultFishes], NewFishes),
    DecreasedRemainingDays #= RemainingDays - 1,
    simulate(NewFishes, NewBabies, DecreasedRemainingDays, Result).

main :-
    phrase_from_file(parse(DataAsStrings), "input"),
    maplist(number_codes, Numbers, DataAsStrings),
    length(Zeros, 7),
    maplist(=(0), Zeros),
    countFishes(Numbers, Zeros, Fishes),
    simulate(Fishes, [0,0], 256, Result),
    writeln(Result).
