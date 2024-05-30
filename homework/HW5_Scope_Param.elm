module HW5_Scope_Param exposing (..)

-- EXERCISE 1 --
-- 1 {   int x;
-- 2     int y;
-- 3     y := 1 ;
-- 4     {   int f(int x) {
-- 5         if x=0 then {
-- 6             y := 1 }
-- 7         else {
-- 8             y := f(x-1)*y+1 };
-- 9         return y
-- 10        };
-- 11        x := f(2);                  
-- 12   }
-- 13}

-- STACK --
-- ATTEMPT 1
[]
[x:?]
[y:?, x:?]
[y:1, x:?]
[f:{}, y:1, x:?]
>>
    [x:2, f{}, y:1, x:?]
    >>
        [x:1, x:2, f{}, y:1, x:?]
        >>
            [x:0, x:1, x:2, f{}, y:1, x:?]
            [x:0, x:1, x:2, f{}, y:1, x:?]         (y is the same) 
            [res:1, x:0, x:1, x:2, f{}, y:1, x:?]
        <<
        [x:1, x:2, f{}, y:2, x:?]
        [res: 2, x:1, x:2, f{}, y:2, x:?]
    <<
    [x:2, f{}, y:5, x:?]
    [res:5, x:2, f{}, y:5, x:?]
<<
[f{}, y:5, x:5]


-- ATTEMPT 2
-- []
-- [x:?] Push
-- [y:?, x:?] Push
-- [y:1, x:?]
-- [f:{}, y:1, x:?] Push
-- [[x:2, f:{}, y:1, x:?], [f:{}, y:1, x:?]] Push
-- [[x:1, f:{}, y:1, x:?], [x:2, f:{}, y:1, x:?], [f:{}, y:1, x:?]] Push 
-- [[x:0, f:{}, y:1, x:?], [x:1, f:{}, y:1, x:?], [x:2, f:{}, y:1, x:?], [f:{}, y:1, x:?]] Push
-- [[x:0, f:{}, y:1, x:?], [x:1, f:{}, y:1, x:?], [x:2, f:{}, y:1, x:?], [f:{}, y:1, x:?]]
-- [[x:1, f:{}, y:2, x:?], [x:2, f:{}, y:1, x:?], [f:{}, y:1, x:?]] Pop    -- NOTE: the value of y should be encapsulated in the temporary stack, so y should always be 1 in this case(maybe?)
-- [[x:2, f:{}, y:4, x:?], [f:{}, y:1, x:?]] Pop
-- [f:{}, y:1, x:8] Pop
-- [y:1, x:8] Pop
-- [] Pop


-- EXERCISE 2 --
1 { int x;
2   int y;
3   int z;
4   x := 3;
5   y := 7;
6   { int f(int y) { return x*y };
7     int y;
8     y := 11;
9     { int g(int x) { return f(y) };
10       { int y;
11         y := 13;
12         z := g(2)
13       }
14    }
15  }
16}

-- Exercise 2a (Static Scoping) --
-- STACK --
after 5: [z:?, y:7, x:3]
after 6: [f:{}, z:?, y:7, x:3]
after 8: [y:11, f:{}, z:?, y:7, x:3]
after 9: [g:{}, y:11, f:{}, z:?, y:7, x:3]
after 11:[y:13, g:{}, y:11, f:{}, z:?, y:7, x:3]
after 9 (in function): [x: 2, y:13, g:{}, y:11, f:{}, z:?, y:7, x:3]
after 6 (in function): [y:11, x: 2, y:13, g:{}, y:11, f:{}, z:?, y:7, x:3]
after 6 (function return result): [res:33, y:11, x: 2, y:13, g:{}, y:11, f:{}, z:?, y:7, x:3]
after 9 (function return result): [res:33, x:2, y:13, g:{}, y:11, f:{}, z:?, y:7, x:3]

after 12:[y:13, g:{}, y:11, f:{}, z:33, y:7, x:3]

-- Exercise 2b (Dynamic Scoping) --
-- STACK --
after 5: [z:?, y:7, x:3]
after 6: [f:{}, z:?, y:7, x:3]
after 8: [y:11, f:{}, z:?, y:7, x:3]
after 9: [g:{}, y:11, f:{}, z:?, y:7, x:3]
after 11:[y:13, g:{}, y:11, f:{}, z:?, y:7, x:3]
after 9 (in function): [x: 2, y:13, g:{}, y:11, f:{}, z:?, y:7, x:3]
after 6 (in function): [y:13, x: 2, y:13, g:{}, y:11, f:{}, z:?, y:7, x:3]
after 6 (function return result): [res:26, y:11, x: 2, y:13, g:{}, y:11, f:{}, z:?, y:7, x:3]
after 9 (function return result): [res:26, x:2, y:13, g:{}, y:11, f:{}, z:?, y:7, x:3]

after 12:[y:13, g:{}, y:11, f:{}, z:26, y:7, x:3]






3(iii). [13,13]
