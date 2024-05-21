module Midterm_Practice exposing (..)
import HW1_Def exposing (..)

-- Homework 1 --
--Exercise 1 
ex1 = [(1,3), (3,4), (2,6), (7,1)]
ex2 = [1,2,3,3,4,4,7,8,9,3,2,15]

ins : a -> Bag a -> Bag a
ins a b = case b of
    []         -> [(a, 1)]
    (x, i)::xs -> if x == a then (x, i + 1)::xs else (x, i)::(ins a xs)

del : a -> Bag a -> Bag a
del a b = case b of
    []         -> []
    (x, i)::xs -> if x == a then 
                    if i - 1 == 0 then xs else (x, i - 1)::xs 
                  else (x, i)::(del a xs)

bag : List a -> Bag a
bag a = case a of 
    []    -> []
    x::xs -> ins x (bag xs)

subbag : Bag a -> Bag a -> Bool 
subbag a b = case a of
    []         -> True
    (x, i)::xs -> if findInteger x b >= i then subbag xs b else False

findInteger : a -> Bag a -> Int
findInteger a b = case b of
    []         -> 0
    (x, i)::xs -> if x == a then i else findInteger a xs

isSet : Bag a -> Bool
isSet a = case a of
    []         -> True
    (_, i)::xs -> if i > 1 then False else isSet xs

size : Bag a -> Int
size a = case a of
    [] -> 0
    -- (_, i)::xs -> i + size xs
    l  -> sum(map snd l)

-- Exercise 2
g1 : Graph
g1 = [(1,2),(1,3),(2,3),(2,4),(3,4)]
h1 : Graph
h1 = [(1,2),(1,3),(2,1),(3,2),(4,4)]

nodes : Graph -> List Node
nodes g = case g of
    []    -> []
    (u, v)::xs -> asSet (u::v::nodes xs)

suc : Node -> Graph -> List Node
suc n g = case g of
    [] -> []
    _  -> map snd (filter (\r -> fst r == n) g)

detach : Node -> Graph -> Graph
detach n g = case g of
    [] -> []
    _  -> filter (\r -> fst r /= n && snd r /= n) g

-- Homework 2 --
-- cmd ::= pen mode
-- | moveto (pos,pos)
-- | def name ( pars ) cmd
-- | call name ( vals )
-- | cmd; cmd
-- mode ::= up | down
-- pos ::= num | name
-- pars ::= name, pars | name
-- vals ::= num, vals | num

type Cmd = Pen Mode | MoveTo (Pos, Pos) | Def String Pars Cmd | Call String Vals | Seq Cmd Cmd
type Mode = Up | Down
type Pos = Con Int | Nam String
type Pars = MultP String Pars | SingleP String
type Vals = MultV String Vals | SingleV Int

vector : Cmd
vector = Def "vector" (MultP "x1" (MultP "y1" (MultP "x2" (SingleP "y2"))))
        (Seq (Pen Up) 
            (Seq (MoveTo (Nam "x1", Nam "y1"))
                (Seq (Pen Down) 
                    (MoveTo (Nam "x2", Nam "y2"))
                )
            )
        )

