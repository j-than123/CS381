module HW3_Semantics exposing (..)
import Html.Attributes exposing (download)
-- import Browser.Dom exposing (Error)
-- import Html exposing (s)

---------------------- Exercise 1 ---------------------- 

-- prog ::= op | op ; prog
-- op ::= LD num | ADD | MULT | DUP

------ PROVIDED ------
type Op = LD Int | ADD | MULT | DUP
type alias Prog = List Op
type alias Stack = List Int

------ OUR CODE ------

-- Semantic Domain
type alias D = Stack -> Maybe Stack

-- Semantic Function
semOp : Op -> D
semOp op stack = case op of
    LD num -> Just (num :: stack)
    ADD -> case stack of 
        x :: y :: xs -> Just ((x + y) :: xs)
        _ -> Nothing
    -- Temporary
    MULT -> case stack of
        x :: y :: xs -> Just ((x * y) :: xs)
        _ -> Nothing
    DUP -> case stack of
        x :: xs -> Just (x :: x :: xs)
        _ -> Nothing

semProg : Prog -> D
semProg prog stack = case prog of 
    [] -> Just stack
    op :: ops -> case semOp op stack of 
        Nothing -> Nothing
        Just stack2 -> semProg ops stack2

testProg : Prog
testProg = [LD 3,DUP,ADD,DUP,MULT]

testProg2 : Prog
testProg2 = [LD 1, LD 2, LD 3, LD 4]

testProg3 : Prog
testProg3 = [LD 3, ADD]


---------------------- Exercise 2 ---------------------- 
------ PROVIDED ------
type alias Point = (Int, Int)
type Mode = Up | Down 
type Cmd = Pen Mode | MoveTo Point | Seq Cmd Cmd

-- Semantic Domain
type alias State = (Mode, Point)
type alias Line = (Point, Point)
type alias Lines = List Line

------ OUR CODE ------
snd = Tuple.second
fst = Tuple.first

-- Semantic Functions
semCmd : Cmd -> State -> (State, Lines)
semCmd cmd (mode, point) = case cmd of
    Pen Up        -> ((Up, point), [])
    Pen Down      -> ((Down, point), [])
    MoveTo newPnt -> case mode of
        Up   -> ((Up, newPnt), [])
        Down -> ((Down, newPnt), [(point, newPnt)])
    Seq cmd1 cmd2 -> 
        let 
            (state1, lines1) = semCmd cmd1 (mode, point)
            (state2, lines2) = semCmd cmd2 state1 
        in 
            (state2, lines1 ++ lines2)


lines : Cmd -> Lines