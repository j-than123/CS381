
/* Exercise 1 */

when(275,10).
when(261,12).
when(381,11).
when(398,12).
when(399,12).

where(275,owen102).
where(261,dear118).
where(381,cov216).
where(398,dear118).
where(399,cov216).

enroll(mary,275).
enroll(john,275).
enroll(mary,261).
enroll(john,381).
enroll(jim,399).


/* schedule/3 */
schedule(S, P, T) :- enroll(S, X), when(X, T), where(X, P).

/* usage/2 */
usage(P, T) :- where(X, P), when(X, T).

/* conflict/2 */
conflict(X, Y) :- where(X, Px), when(X, Tx), where(Y, Py), when(Y, Ty), Px = Py, Tx = Ty, X \= Y.
/* conflict(X, Y) :- where(X, Px) = where(Y, Py), when(X, Tx) = when(Y, Ty), X \= Y. */

/* meet/2 */
/* meet(S1, S2) :- enroll(S1, P1), where(P1, X1), enroll(S2, P2), where(P2, X2), X1 = X2, S1 \= S2. */
meet(S1, S2) :- enroll(S1, P1), enroll(S2, P2), where(P1, X), where(P2, X), S1 \= S2.













/* Exercise 2 */
append([], L, L).
append([X|L1], L2, [X|L3]) :- append(L1, L2, L3).

member(X,[X|_]).
member(X,[_|Y]) :- member(X,Y).

/* rdup/2 */

/* rdup([], M).
rdup([X|L1], M) :- rdup(L1, [M|X]). */
/*
rdup([], []).
rdup([X, [X|L]], M) :- 
rdup([X|L], [M|Y]) :- X \= Y, rdup(L, [M|X]). */

rdup([X, X|T], M) :-
    rdup([X|T], M).
rdup([X,Y|T], [X|M]) :-
    X \= Y,
    rdup([Y|T], M).


/* flat/2 */

flat([], []).
flat([H|T], F) :-
    is_list(H),
    flat(H, FH),
    flat(T, FT),
    append(FH, FT, F).
flat([H|T], F) :-
    \+ is_list(H),
    flat(T, FT),
    append([H], FT, F).


/* project/3 */

project(Pos, Lst, Res) :-
    proj_helper(Pos, Lst, 1, Res).

proj_helper([], _, _, []). 
proj_helper([P|PT], [L|LT], I, [L|R]) :-
    P =:= I,
    NextI is I + 1,
    proj_helper(PT, LT, NextI, R). 
proj_helper(Pos, [_|LT], I, R) :-
    NextI is I + 1, 
    proj_helper(Pos, LT, NextI, R).