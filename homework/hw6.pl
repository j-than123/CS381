
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
/* conflict(X, Y) :- where(X, Px) = where(Y, Py), when(X, Tx) = when(Y, Ty), X \= Y. */
conflict(X, Y) :- where(X, Px), when(X, Tx), where(Y, Py), when(Y, Ty), Px = Py, Tx = Ty, X \= Y.

/* meet/2 */
meet(S1, S2) :- enroll(S1, P1), where(P1, X1), enroll(S2, P2), where(P2, X2), X1 = X2, S1 \= S2.

/* Exercise 2 */

