module HW3_Semantics%20%281%29 exposing (..)module HW3_Semantics exposing (..)


-- Exercise 1
--
type Op = LD Int | ADD | MULT | DUP
type alias Prog = List Op

type alias Stack = List Int

type alias D = Stack -> Maybe Stack

-- semOp : Op -> Stack -> Maybe Stack
semOp : Op -> D
semOp c l = case (c,l) of
    (LD i,s)       -> Just (i::s)
    (DUP, i::s)    -> Just (i::i::s)
    (ADD, i::j::s) -> Just (i+j::s)
    (MULT,i::j::s) -> Just (i*j::s)
    _              -> Nothing


-- semProg : Prog -> Stack -> Maybe Stack
semProg : Prog -> D
semProg p s = case p of
    []    -> Just s
    o::os -> Maybe.andThen (semProg os) (semOp o s)
    -- o::os -> case semOp o s of
    --     Just s1 -> sem os s1
    --     Nothing -> Nothing

test1 = [LD 3, DUP, ADD, DUP, MULT]
test2 = []
test3 = [LD 3, ADD]
test4 = [LD 3, MULT]
test5 = [DUP]

tests  = [test1,    test2,  test3,  test4,  test5]
expect = [Just [36],Just [],Nothing,Nothing,Nothing]
test = List.map (\p->semProg p []) tests == expect


-- Exercise 2
--
type alias Point = (Int,Int)

type Cmd = Pen Mode
         | MoveTo Point
         | Seq Cmd Cmd

type Mode = Up | Down

type alias Line = (Point,Point)
type alias Lines = List Line
type alias State = (Mode,Point)

semCmd : Cmd -> State -> (State,Lines)
semCmd c s = case (c,s) of
        (Pen Up,   (_,p))     -> ((Up,  p), [])
        (Pen Down, (_,p))     -> ((Down,p), [])
        (MoveTo p, (Up, _))   -> ((Up,  p), [])
        (MoveTo p, (Down, q)) -> ((Down,p), [(q,p)])
        (Seq c1 c2,sl)        -> let (s1,l1) = semCmd c1 sl
                                     (s2,l2) = semCmd c2 s1
                                  in
                                     (s2,l1++l2)

lines : Cmd -> Lines
lines c = Tuple.second (semCmd c (Up,(0,0)))

up : Cmd
up = Pen Up

down : Cmd
down = Pen Down

line : Int -> Int -> Int -> Int -> Cmd
line x1 y1 x2 y2 = Seq up               (
                   Seq (MoveTo (x1,y1)) (
                   Seq down             (
                       (MoveTo (x2,y2)) )))

steps : Int -> Cmd
steps x = case x of
        1 -> Seq (line 0 0 0 1) (MoveTo (1,1))
        n -> Seq (steps (n-1))    (
             Seq (MoveTo (n-1,n)) (
                 (MoveTo (n,n))   ))

logo1 = line 2 3 4 5
logo2 = steps 7
