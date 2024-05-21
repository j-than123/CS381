module HW1_Def exposing (..)


-- Some abbreviations
--
fst = Tuple.first
snd = Tuple.second
map = List.map
sum = List.sum
filter = List.filter


-- Exercise 1
--
type alias Bag a = List (a, Int)


-- Exercise 2
--
type alias Node  = Int
type alias Edge  = (Node, Node)
type alias Graph = List Edge


asSet : List comparable -> List comparable
asSet = rmDup << List.sort

rmDup : List comparable -> List comparable
rmDup l = case l of
    x::y::zs -> if x==y then rmDup (y::zs) else x::rmDup (y::zs)
    xs       -> xs


-- Exercise 3
--
type alias Number = Int
type alias Point = (Number, Number)
type alias Length = Number
type Shape = Pt Point
           | Circle Point Length
           | Rect Point Length Length

type alias Figure = List Shape
type alias BBox = (Point, Point)

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
-- semCmd : Cmd -> State -> (State, Lines)
-- semCmd cmd state = case cmd of
--     Pen Up        -> ((Up, snd state), [])
--     Pen Down      -> ((Down, snd state), [])
--     MoveTo point  -> 
--     case fst state of
--         Up   -> ((fst state, point), [])
--         Down -> ((fst state, point), [(snd state, point)])
--     Seq cmd1 cmd2 -> 
            -- let 
             --  (state1, lines1) = semCmd cmd1 state
             --  (state2, lines2) = semCmd cmd2 state1
             -- in
            --  (state2, lines1 ++ lines2)



semCmd : Cmd -> State -> (State, Lines)
semCmd cmd (mode, point) = case cmd of
    Pen Up        -> ((Up, point), [])
    Pen Down      -> ((Down, point), [])
    MoveTo NewPnt -> case mode of
        Up   -> ((Up, NewPnt), [])
        Down -> ((Down, NewPnt), [(point, NewPnt)])
    Seq cmd1 cmd2 -> (semCmd cmd1) :: (semCmd cmd2)

