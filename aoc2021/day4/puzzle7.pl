:- use_module(library(clpfd)).
:- use_module(library(pio)).
:- set_prolog_flag(double_quotes,codes).

all_chars([Head]) --> [Head], {[Head] \= "\n", [Head] \= " ", [Head] \= ","}.
all_chars([Head|Tail]) --> [Head], {[Head] \= "\n", [Head] \= " ", [Head] \= ","}, all_chars(Tail).
numbers([Number]) --> all_chars(Number), "\n".
numbers([Number|Tail]) --> all_chars(Number), ",", numbers(Tail).
whitespaces --> "". % this is due to the first number in a row possibly not being preceeded by a whitespace
whitespaces --> " ".
whitespaces --> "  ".
row([X1, X2, X3, X4, X5]) --> 
    whitespaces, all_chars(X1), 
    whitespaces, all_chars(X2),
    whitespaces, all_chars(X3),
    whitespaces, all_chars(X4),
    whitespaces, all_chars(X5), "\n".
board([R1, R2, R3, R4, R5]) --> row(R1), row(R2), row(R3), row(R4), row(R5).
boards([Board]) --> board(Board).
boards([Board|Tail]) --> board(Board), "\n", boards(Tail).
parse((Numbers, Boards)) --> numbers(Numbers), "\n", boards(Boards).

convertRow(RowAsStrings, Row) :- maplist(number_codes, Row, RowAsStrings).
convertBoard(BoardAsStrings, Board) :- maplist(convertRow, BoardAsStrings, Board).
convertData((NumbersAsStrings, BoardsAsStrings), (Numbers, Boards)) :- 
    maplist(number_codes, Numbers, NumbersAsStrings),
    maplist(convertBoard, BoardsAsStrings, Boards).

initialRowState(Row) :- length(Row, 5), maplist(=(unmarked), Row).
initialBoardState(Rows) :- length(Rows, 5), maplist(initialRowState, Rows).

updateRowEntry(Number, Number, _, marked).
updateRowEntry(Number, RowEntry, RowEntryState, RowEntryState) :- Number #\= RowEntry.
markRow(Number, Row, RowState, NewRowState) :- maplist(updateRowEntry(Number), Row, RowState, NewRowState).
markBoard(Number, Board, BoardState, NewBoardState) :- maplist(markRow(Number), Board, BoardState, NewBoardState).
drawNumber(Number, Boards, BoardStates, NewBoardStates) :- maplist(markBoard(Number), Boards, BoardStates, NewBoardStates).

rowMarked(RowState) :- maplist(=(marked), RowState).
columnMarked(BoardState, ColumnIndex) :- maplist({ColumnIndex}/[Row]>>nth0(ColumnIndex, Row, marked), BoardState).
hasWon(BoardState) :- member(Row, BoardState), rowMarked(Row) ; ColumnIndex in 0..4, label([ColumnIndex]), columnMarked(BoardState, ColumnIndex).

drawNumbers([Number|_], Boards, BoardStates, (Number, Board, NewBoardState)) :-
    drawNumber(Number, Boards, BoardStates, NewBoardStates),
    member(NewBoardState, NewBoardStates),
    hasWon(NewBoardState),
    nth0(WinnerIndex, NewBoardStates, NewBoardState),
    nth0(WinnerIndex, Boards, Board).
drawNumbers([Number|NumbersTail], Boards, BoardStates, Result) :-
    drawNumber(Number, Boards, BoardStates, NewBoardStates),
    \+ (member(NewBoardState, NewBoardStates), hasWon(NewBoardState)),
    drawNumbers(NumbersTail, Boards, NewBoardStates, Result).

addToScore(_, marked, Sum, Sum).
addToScore(Element, unmarked, Sum, NewSum) :- NewSum #= Sum + Element.
score((Number, Board, BoardState), Score) :- 
    flatten(Board, FlattenedBoard),
    flatten(BoardState, FlattenedBoardState),
    foldl(addToScore, FlattenedBoard, FlattenedBoardState, 0, Sum), 
    Score #= Number * Sum.

main :-
    phrase_from_file(parse(DataAsStrings), "input"),
    convertData(DataAsStrings, (Numbers, Boards)),
    length(Boards, NumberOfBoards),
    length(BoardStates, NumberOfBoards),
    maplist(initialBoardState, BoardStates),
    drawNumbers(Numbers, Boards, BoardStates, Winner),
    score(Winner, Result),
    writeln(Result).