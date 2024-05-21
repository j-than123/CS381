module Hw2_syntax exposing (..)module Hw2_syntax exposing (..)
----------------------------------------------------------
-- 1
----------------------------------------------------------


---------------
-- a
---------------

-- cmd ::= pen mode
-- | moveto (pos,pos)
-- | def name ( pars ) cmd
-- | call name ( vals )
-- | cmd; cmd

-- mode ::= up | down
-- pos ::= num | name
-- pars ::= name, pars | name
-- vals ::= num, vals | num

type Cmd = Pen Mode |
            MoveTo (Pos, Pos) |
            Def String Pars Cmd |
            Call String Vals |
            Seq Cmd Cmd

type Mode = Up | Down
            
type Pos = Num Int| Name String

type Pars = Many String Pars | Single String

type Vals = Multiple Int Vals | Singular Int


---------------
-- b
---------------

-- def vector (x1, y1, x2, y2) {
--     pen up;
--     moveto (x1, y1);
--     pen down;
--     moveto (x2, y2);
--}



vector : Cmd 
vector = Def "vector" (Many "x1" (Many "y1" (Many "x2" (Single "y2")))) 
    (Seq (Pen Up)
        (Seq (MoveTo (Name "x1", Name "y1"))
            (Seq (Pen Down)
                (MoveTo (Name "x2", Name "y2"))
            )
        )
    )

---------------
-- c
---------------


makestep : Int -> Int -> Cmd
makestep x y = Seq (Pen Up) 
                    (Seq (MoveTo (Num x, Num y)) 
                        (Seq (Pen Down) 
                            (Seq (MoveTo (Num (x), Num (y + 1))) 
                                (MoveTo (Num (x + 1), Num (y + 1)))
                            )
                        )
                    )

steploop : Int -> Int -> Int -> Cmd
steploop n x y = case n of
    0 -> Pen Up
    _ -> Seq (makestep x y) (steploop (n - 1) (x + 1) (y + 1))

steps : Int -> Cmd
steps n = steploop n 0 0

----------------------------------------------------------
-- 2
----------------------------------------------------------

---------------
-- a
---------------

-- grammar ::= prod ; . . . ; prod
-- prod ::= nt ::= rhs | . . . | rhs
-- rhs ::= symbol∗
-- symbol ::= nt | term

type alias NonTerm = String

type alias Term = String

type alias Grammar = List Prod

type Prod = Production NonTerm RHS

type alias RHS = List Symbol

type Symbol = NonTerminal NonTerm | Terminal Term




---------------
-- b
---------------

-- cond ::= T |not cond |( cond )
-- stmt ::=skip |while cond do { stmt } |stmt; stmt

tCond : Prod
tCond = Production "cond" [Terminal "T"]

notCond : Prod
notCond = Production "cond" 
                [
                    Terminal "not", 
                    NonTerminal "cond"
                ]

parenthesisCond : Prod
parenthesisCond = Production "cond" 
                [
                    Terminal "(", 
                    NonTerminal "cond", 
                    Terminal ")"
                ]

skipStmt : Prod
skipStmt = Production "cond" [Terminal "skip"]


whileStmt : Prod
whileStmt = Production "stmt" 
                [  
                    Terminal "while", 
                    NonTerminal "cond", 
                    Terminal "do",
                    Terminal "{",
                    NonTerminal "stmt",
                    Terminal "}"
                ]

seqStmt : Prod
seqStmt = Production "stmt" 
                [
                    NonTerminal "stmt", 
                    Terminal ";", 
                    NonTerminal "stmt"
                ]
imp : Grammar
imp = [tCond, notCond, parenthesisCond, skipStmt, whileStmt, seqStmt]

---------------
-- c
---------------
unique : List String -> List String
unique a = case a of
    [] -> []
    x::xs -> x::unique(List.filter(\val -> val /= x) xs)



nonterminals : Grammar -> List NonTerm
nonterminals g = unique(List.map extractNT g)

extractNT : Prod -> NonTerm
extractNT (Production nt _) = nt




terminals : Grammar -> List Term
terminals grammar = unique(List.concatMap extractT grammar)

extractT : Prod -> List Term
extractT (Production _ rhs) = extractSymbolFromRHS rhs

extractSymbolFromRHS : RHS -> List Term
extractSymbolFromRHS rhs = List.concatMap extractTermFromSymbol rhs

extractTermFromSymbol : Symbol -> List Term
extractTermFromSymbol s = case s of 
    NonTerminal _ -> []
    Terminal t    -> [t]