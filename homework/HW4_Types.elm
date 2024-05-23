module HW4_Types exposing (..)
import Syntax_Practice exposing (prog)

-- Exercise 1a --
type Op = LD Int | ADD | MULT | DUP | DEC | SWAP | POP Int
type alias Prog = List Op
type alias Rank = Int
type alias OpRank = (Int,Int)
type alias Stack = List Int
type alias D = Stack -> Maybe Stack 

rankOp : Op -> OpRank
rankOp o = case o of 
    LD _  -> (0,1)
    ADD   -> (2,1)
    MULT  -> (2,1)
    DUP   -> (1,2)
    DEC   -> (1,0)
    SWAP  -> (2,2) 
    POP i -> (i,0)
    
rankP : Prog -> Maybe Rank
rankP p = rank p 0 

-- auxillary function
rank : Prog -> Rank -> Maybe Rank
rank prog k = case prog of
    []         -> Just k
    op::oppas  -> let (n, m) = rankOp op in 
                    if k < n 
                        then Nothing 
                        else rank oppas (k - n + m)
    
-- Exercise 1b --
semTC : Prog -> Maybe Stack
semTC s = case rankP s of
    Just _ -> Just (semProg s [])
    _      -> Nothing

semProg : Prog -> Stack -> Stack
semProg prog stack = case prog of 
    [] -> stack
    op :: ops -> case semOp op stack of 
        Just stack2 -> semProg ops stack2
        Nothing -> Debug.todo "Error"

semOp : Op -> D
semOp op stack = case (op,stack) of
    (LD i,s)       -> Just (i::s)
    (DUP, i::s)    -> Just (i::i::s)
    (ADD, i::j::s) -> Just (i+j::s)
    (MULT,i::j::s) -> Just (i*j::s)
    (DEC, i::s)    -> Just (s)
    (SWAP,i::j::s) -> Just (j::i::s) 
    (POP k,i::s)   -> if k > 0 || List.isEmpty(s) then semOp (POP (k - 1)) s else Just s
    _              -> Nothing
        
-- Exercise 2 --

type Shape = X | LR Shape Shape | TD Shape Shape
type alias BBox = (Int, Int)


fst : BBox -> Int
fst (x, _) = x

snd : BBox -> Int
snd (_, y) = y

max : Int -> Int -> Int
max x y = if x > y then x else y

bbox : Shape -> BBox
bbox s = case s of 
    X -> (1,1)
    LR s1 s2 -> ((fst (bbox s1)) + (fst (bbox s2)), max (snd (bbox s1)) (snd (bbox s2)))
    TD s1 s2 -> (max (fst (bbox s1)) (fst (bbox s2)), (snd (bbox s1)) + (snd (bbox s2)))

rect : Shape -> Maybe BBox
rect s = case s of
    X -> Just (1,1)
    LR s1 s2 -> case (rect s1, rect s2) of 
                    (Just (w1,h1), Just (w2, h2)) -> 
                        if (h1 == h2) 
                            then Just (w1+w2, h1) 
                            else Nothing
                    _ -> Nothing
    TD s1 s2 -> case (rect s1, rect s2) of 
                    (Just (w1,h1), Just (w2, h2)) -> 
                        if (w1 == w2) 
                            then Just (w1, h1+h2) 
                            else Nothing
                    _ -> Nothing


bboxTest = TD (LR X X) (LR (TD X X) X)

bboxTest2 = LR (LR X X) (TD X (TD X X))

bboxTest3 = TD (LR (LR X X) X) (LR (LR X X) X)