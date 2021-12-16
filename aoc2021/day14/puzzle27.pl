:- use_module(library(clpfd)).
:- use_module(library(pio)).
:- set_prolog_flag(double_quotes,codes).
:- use_module(library(rbtrees)).

all_chars([Head]) --> [Head], {[Head] \= "\n"}.
all_chars([Head|Tail]) --> [Head], {[Head] \= "\n"}, all_chars(Tail).
template(Template) --> all_chars(Template), "\n".
rules([(Pair,Char)]) --> all_chars(Pair), " -> ", all_chars(Char), "\n".
rules([(Pair,Char)|Tail]) --> all_chars(Pair), " -> ", all_chars(Char), "\n", rules(Tail).
parse(Template, Rules) -->  template(Template), "\n", rules(Rules).

applyRulesToPair([Char1, _], [], [Char1]).
applyRulesToPair([Char1, Char2], [([Char1, Char2],[Char])|_], [Char1, Char]).
applyRulesToPair([Char1, Char2], [([RuleChar1, RuleChar2],_)|RulesTail], Result) :-
    (Char1 \= RuleChar1 ; Char2 \= RuleChar2), !,
    applyRulesToPair([Char1, Char2], RulesTail, Result).

applyRules([Char], _, [Char]).
applyRules([Char1, Char2|TemplateTail], Rules, Result) :- 
    applyRulesToPair([Char1, Char2], Rules, Inserted),
    append(Inserted, ResultTail, Result),
    applyRules([Char2|TemplateTail], Rules, ResultTail).

applyRepeadetly(Template, _, 0, Template).
applyRepeadetly(Template, Rules, N, Result) :-
    N #> 0,
    applyRules(Template, Rules, NewTemplate),
    DecreasedN #= N - 1,
    applyRepeadetly(NewTemplate, Rules, DecreasedN, Result).

countOccurences([], Tree, Tree).
countOccurences([Char|Tail], Tree, Result) :-
    rb_insert_new(Tree, Char, 1, NewTree),
    countOccurences(Tail, NewTree, Result).
countOccurences([Char|Tail], Tree, Result) :-
    rb_lookup(Char, Value, Tree),
    IncreasedValue #= Value + 1,
    rb_insert(Tree, Char, IncreasedValue, NewTree),
    countOccurences(Tail, NewTree, Result).

mostCommon(CountedOccurences, Result) :-
    rb_fold([_-V1,V2, V]>>(V #= max(V1, V2)), CountedOccurences, 0, Result).

leastCommon(CountedOccurences, Result) :-
    rb_fold([_-V1,V2, V]>>(V #= min(V1, V2)), CountedOccurences, 999999999999, Result).

main :-
    phrase_from_file(parse(Template, Rules), "input"),
    applyRepeadetly(Template, Rules, 10, NewTemplate),
    rb_empty(EmptyTree),
    countOccurences(NewTemplate, EmptyTree, CountedOccurences),
    mostCommon(CountedOccurences, Max),
    leastCommon(CountedOccurences, Min),
    Result #= Max - Min,
    writeln(Result).