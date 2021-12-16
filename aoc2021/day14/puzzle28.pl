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

updateTree([], Tree, Tree).
updateTree([K-V|Tail], Tree, Result) :-
    rb_lookup(K, Value, Tree),
    Sum #= Value + V,
    rb_update(Tree, K, Sum, NewTree),
    updateTree(Tail, NewTree, Result).
updateTree([K-V|Tail], Tree, Result) :-
    rb_insert_new(Tree, K, V, NewTree),
    updateTree(Tail, NewTree, Result).

mergeTrees(Tree1, Tree2, Result) :-
    rb_visit(Tree1, Pairs),
    updateTree(Pairs, Tree2, Result).

:- table countInserted/5.
countInserted(0, _, _, _, Result) :- rb_empty(Result).
countInserted(N, Char1, Char2, Rules, Result) :-
    N #> 0,
    \+ member(([Char1, Char2],_), Rules),
    rb_empty(Result).
countInserted(N, Char1, Char2, Rules, Result) :-
    N #> 0,
    member(([Char1, Char2],[Char]), Rules),
    rb_empty(InitialTree),
    rb_insert_new(InitialTree, Char, 1, NewTree),
    DecreasedN #= N - 1,
    countInserted(DecreasedN, Char1, Char, Rules, CountedOccurences1),
    countInserted(DecreasedN, Char, Char2, Rules, CountedOccurences2),
    mergeTrees(NewTree, CountedOccurences1, TmpTree),
    mergeTrees(TmpTree, CountedOccurences2, Result).
    
mostCommon(CountedOccurences, Result) :-
    rb_fold([_-V1,V2, V]>>(V #= max(V1, V2)), CountedOccurences, 0, Result).

leastCommon(CountedOccurences, Result) :-
    rb_fold([_-V1,V2, V]>>(V #= min(V1, V2)), CountedOccurences, 999999999999, Result).

countAllInserted([_], _, _, Accumulator, Accumulator).
countAllInserted([Char1, Char2|Tail], Rules, N, Accumulator, Result) :-
    countInserted(N, Char1, Char2, Rules, CountedOccurences),
    mergeTrees(Accumulator, CountedOccurences, NewAccumulator),
    countAllInserted([Char2|Tail], Rules, N, NewAccumulator, Result).

countInTemplate([], Accumulator, Accumulator).
countInTemplate([Char|Tail], Accumulator, Result) :-
    rb_insert_new(Accumulator, Char, 1, NewAccumulator),
    countInTemplate(Tail, NewAccumulator, Result).
countInTemplate([Char|Tail], Accumulator, Result) :-
    rb_lookup(Char, Value, Accumulator),
    NewValue #= Value + 1,
    rb_update(Accumulator, Char, NewValue, NewAccumulator),
    countInTemplate(Tail, NewAccumulator, Result).

main :-
    phrase_from_file(parse(Template, Rules), "input"),
    rb_empty(EmptyTree),
    countInTemplate(Template, EmptyTree, CountedInTemplate),
    countAllInserted(Template, Rules, 40, EmptyTree, CountedInserted),
    mergeTrees(CountedInTemplate, CountedInserted, CountedOccurences),
    mostCommon(CountedOccurences, Max),
    leastCommon(CountedOccurences, Min),
    Result #= Max - Min,
    writeln(Result).