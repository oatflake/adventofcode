:- use_module(library(clpfd)).
:- use_module(library(pio)).
:- set_prolog_flag(double_quotes,codes).

:- dynamic node/2.
:- dynamic edge/2.

all_chars([Head]) --> [Head], {[Head] \= "\n", [Head] \= "-"}.
all_chars([Head|Tail]) --> [Head], {[Head] \= "\n", [Head] \= "-"}, all_chars(Tail).
nodeString((NameAsAtom, big)) --> all_chars(Name), { atom_codes(NameAsAtom, Name), [FirstLetter|_] = Name, is_upper(FirstLetter) }.
nodeString((NameAsAtom, small)) --> all_chars(Name), { atom_codes(NameAsAtom, Name), [FirstLetter|_] = Name, is_lower(FirstLetter) }.
parse([(From, To)]) --> nodeString(From), "-", nodeString(To), "\n".
parse([(From, To)|Tail]) -->  nodeString(From), "-", nodeString(To), "\n", parse(Tail).

assertNode(Name, Size) :-
    retractall(node(Name, Size)),
    assert(node(Name, Size)).
assertEdges([]).
assertEdges([((Name1, Size1), (Name2, Size2))|Tail]) :-
    assertNode(Name1, Size1),
    assertNode(Name2, Size2),
    assert(edge(Name1, Name2)),
    assert(edge(Name2, Name1)),
    assertEdges(Tail).

findPath(From, Path, _, From, Path).
findPath(From, Path, Twice, To, ResultPath) :-
    From \= To,
    edge(From, Other),
    node(Other, big),
    findPath(Other, [Other|Path], Twice, To, ResultPath).
findPath(From, Path, false, To, ResultPath) :-
    From \= To,
    edge(From, Other),
    node(Other, small),
    \+ member(Other, [start, end]),
    member(Other, Path),
    findPath(Other, [Other|Path], true, To, ResultPath).
findPath(From, Path, Twice, To, ResultPath) :-
    From \= To,
    edge(From, Other),
    node(Other, small),
    \+ member(Other, Path),
    findPath(Other, [Other|Path], Twice, To, ResultPath).

main :-
    retractall(node(_, _)),
    retractall(edge(_, _)),
    phrase_from_file(parse(Data), "input"),
    assertEdges(Data),
    findall(Path, findPath(start, [start], false, end, Path), Paths),
    length(Paths, Result),
    writeln(Result).
