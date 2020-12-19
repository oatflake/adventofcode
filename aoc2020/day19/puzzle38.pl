:- use_module(library(clpfd)).
:- use_module(library(pio)).
:- set_prolog_flag(double_quotes,codes).

all_chars([H]) --> [H], {[H] \= "\n", [H] \= " ", [H] \= "|", [H] \= [34]}.
all_chars([H|T]) --> [H], {[H] \= "\n", [H] \= " ", [H] \= "|", [H] \= [34]}, all_chars(T).

subrule([A]) --> all_chars(A).
subrule([A|T]) --> all_chars(A), " ", subrule(T).
subrules([R]) --> subrule(R).
subrules([R|T]) --> subrule(R), " | ", subrules(T).
rule(rule(ID, subrules(SubRules))) --> all_chars(ID), ": ", subrules(SubRules).
rule(rule(ID, terminal(A))) --> all_chars(ID), ": ", [34], [A], [34].
rules([H|T]) --> rule(H), "\n", rules(T).
rules([H]) --> rule(H), "\n".
inputs([H|T]) --> all_chars(H), "\n", inputs(T).
inputs([H]) --> all_chars(H), "\n".
parse([Rules, Inputs]) --> rules(Rules), "\n", inputs(Inputs).

assert_rule(_, []).
assert_rule(RuleHead, [RuleBody|T]) :-
    maplist(append("rule"), RuleBody, RuleBody1),
    maplist(atom_codes, RuleBodyAtomList, RuleBody1),
    list_to_tuple(RuleBodyAtomList, Z),
    expand_term((RuleHead-->Z), T1), T1=[_,T2],
    assert(T2),
    assert_rule(RuleHead, T).

assert_rules([]).
assert_rules([rule(ID, subrules(L))|T]) :-
    append("rule", ID, Rule),
    atom_codes(Rule1, Rule),
    assert_rule(Rule1, L),
    assert_rules(T).
assert_rules([rule(ID, terminal(A))|T]) :-
    append("rule", ID, Rule),
    atom_codes(Rule1, Rule),
    expand_term((Rule1-->([A])), T1), T1=[_,T2], 
    assert(T2),
    assert_rules(T).

count_inputs([], 0).
count_inputs([H|T], N) :-
    X =.. [rule0, H, []],
    (X -> 
    N #= N1 + 1;
    N #= N1),
    count_inputs(T, N1). 

main :-
    phrase_from_file(parse([Rules, Inputs]), "input"),
    assert_rules(Rules),
    Tmp =.. [rule8,_,_],
    retractall(Tmp),
    Tmp1 =.. [rule11,_,_],
    retractall(Tmp1),
    assert_rules([rule("8", subrules([["42"],["42","8"]])),
                rule("11", subrules([["42", "31"],["42","11","31"]]))]),
    count_inputs(Inputs, N),
    writeln(N).


% --- based on: https://stackoverflow.com/questions/4065388/dynamic-rule-assertion-in-swi-prolog ---
list_to_tuple([X],X).
list_to_tuple([H|T],(H,Rest_Tuple)) :-
    list_to_tuple(T,Rest_Tuple).
% --------------------------------------------------------------------------------------------------