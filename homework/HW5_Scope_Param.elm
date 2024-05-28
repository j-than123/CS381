module HW5_Scope_Param exposing (..)
1. {   int x;
2.     int y;
3.     y := 1 ;
4.     {   int f(int x) {
5.         if x=0 then {
6.             y := 1 }
7.         else {
8.             y := f(x-1)*y+1 };
9.         return y
10.        };
11.        x := f(2);                  
12.   }
13.}

-- STACK --
-- ATTEMPT 1
[]
[x:?] Push
[y:?, x:?] Push
[y:1, x:?]
[f:{}, y:1, x:?] Push
[x:2, f{}, y:1, x:?]
[x:1, x:2, f{}, y:1, x:?]
[x:0, x:1, x:2, f{}, y:1, x:?]
[x:1, x:2, f{}, y:1, x:?]
...

-- ATTEMPT 2
[]
[x:?] Push
[y:?, x:?] Push
[y:1, x:?]
[f:{}, y:1, x:?] Push
[[x:2, f:{}, y:1, x:?], [f:{}, y:1, x:?]] Push
[[x:1, f:{}, y:1, x:?], [x:2, f:{}, y:1, x:?], [f:{}, y:1, x:?]] Push 
[[x:0, f:{}, y:1, x:?], [x:1, f:{}, y:1, x:?], [x:2, f:{}, y:1, x:?], [f:{}, y:1, x:?]] Push
[[x:0, f:{}, y:1, x:?], [x:1, f:{}, y:1, x:?], [x:2, f:{}, y:1, x:?], [f:{}, y:1, x:?]]
[[x:1, f:{}, y:2, x:?], [x:2, f:{}, y:1, x:?], [f:{}, y:1, x:?]] Pop    -- NOTE: the value of y should be encapsulated in the temporary stack, so y should always be 1 in this case(maybe?)
[[x:2, f:{}, y:4, x:?], [f:{}, y:1, x:?]] Pop
[f:{}, y:1, x:8] Pop
[y:1, x:8] Pop
[] Pop
