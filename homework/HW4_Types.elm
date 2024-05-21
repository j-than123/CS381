module HW4_Types exposing (..)
import Syntax_Practice exposing (prog)

-- Exercise 1 --
type Op = LD Int | ADD | MULT | DUP | DEC | SWAP | POP Int
type alias Prog = List Op

type alias Rank = Int
type alias OpRank = (Int,Int)

rankOp : Op -> OpRank
rankOp o = case o of 
    LD _  -> (0,1)
    ADD   -> (2,1)
    MULT  -> (2,1)
    DUP   -> (1,2)
    DEC   -> (1,0)
    SWAP  -> (1,1) 
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
    
--rankP p = rank p 0  