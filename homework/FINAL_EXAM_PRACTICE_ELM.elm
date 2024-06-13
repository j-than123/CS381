module FINAL_EXAM_PRACTICE_ELM exposing(..)


-- Homework 1 --
import HW1_Def exposing (..)
import Midterm_Practice exposing (subbag)
type alias Bag a = List (a, Int)

ins : a -> Bag a -> Bag a
ins val b = case b of
    []        -> [(val, 1)]
    (x,n)::xs -> if x == val then (x,n+1)::xs else (x,n)::(ins val xs)
    

del : a -> Bag a -> Bag a
del val b = case b of
    []         -> []
    (x,1)::xs  -> if x == val then xs else del val xs
    (x,n)::xs  -> if x == val then (x, n - 1)::xs else (x,n)::(del val xs)

bag : List a -> Bag a
bag l = case l of
    []    -> []
    x::xs -> ins x (bag xs)

subbag : Bag a -> Bag a -> Bool
subbag a b = case (a,b) of
    ([],_)    -> True 
    (x::xs,y) -> if subbag_helper x y then subbag xs y else False

subbag_helper : (a,Int) -> Bag a -> Bool
subbag_helper a b = case (a,b) of
    (_,[])             -> False
    ((x,n),(y,m)::ys)  -> if x == y && n <= m then True else subbag_helper a ys




-- Homework 2 --
type alias Name = String
type alias Num = Int
type Cmd = Pen Mode | MoveTo (Pos, Pos) | Def Name Pars Cmd | Call Name Vals | Seq Cmd Cmd
type Mode = Up | Down
type Pos = Con Num | Str Name
type Pars = Mult Name Pars | Sng Name
type Vals = Mult Num Vals | Sng Num

vector : Cmd
vector = Def "vector" (Mult "x1" (Mult "y1" (Mult "x2" (Sng "y2")))) 





