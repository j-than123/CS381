module Scope_Var exposing (..)

import List exposing (map,concat)
import Maybe exposing (map2,withDefault)

import Trace exposing (..)


type alias Name = String

type Expr = Lit Int              -- integer constant
          | Plus Expr Expr       -- addition
          | Var Name             -- var. reference
          | Let Name Expr Expr   -- local definition


type alias Val = Maybe Int

-- Note: Storing Vals on the stack is needed for tracing
--
type alias Stack = List (Name,Val)

getVar : Name -> Stack -> Val
getVar n s = case s of
    []        -> Nothing
    (m,v)::s1 -> if n==m then v else getVar n s1


eval : Stack -> Expr -> Val
eval s e = case e of
    Lit i       -> Just i
    Plus e1 e2  -> map2 (+) (eval s e1) (eval s e2)
    Var v       -> getVar v s
    Let v e1 e2 -> case eval s e1 of
                    Just i  -> eval ((v,Just i)::s) e2
                    Nothing -> Nothing


-- "smart constructors" to simplify the construction
-- of syntax trees
--
n1 = Lit 1
n2 = Lit 2
n3 = Lit 3
x  = Var "x"
y  = Var "y"


-- example expressions
--
letx   = Let "x" n1 n1
letx2  = Let "x" n1 x
letxy  = Let "x" n1 (Let "y" n2 (Plus x y))
letxy2 = Let "x" n1 (Plus (Let "y" n2 x) y)
letxy3 = Let "x" n1 (Plus (Let "y" n2 y) x)
letxx  = Let "x" n1 (Let "x" n2 (Plus x x))
letxx2 = Let "x" n1 (Plus (Let "x" n2 x) x)
noRec  = Let "x" x x
loop   = Let "x" (Let "x" x x) x

pl1 = Plus n1 n2
pl2 = Plus pl1 n2
pl3 = Plus n1 pl1
pl4 = Plus pl1 pl1


-- Pretty Printer
--
pp : Expr -> String
pp e = case e of
    Lit i -> String.fromInt i
    Var v       -> v
    Plus e1 e2  -> ppP e1++"+"++ppP e2
    Let v e1 e2 -> "let "++v++"="++pp e1++" in "++pp e2

ppP : Expr -> String
ppP e = case e of
    Lit _ -> pp e
    Var _ -> pp e
    e1    -> "("++pp e1++")"

ppVal : Val -> String
ppVal = withDefault "?" << Maybe.map String.fromInt

ppEV : PP Expr Val
ppEV = {ppE = pp, ppV = ppVal}


-- Tracing Evaluator
--
evalT : Stack -> Expr -> Trace Expr Val
evalT s e = case e of
    Lit i       -> Tr s e (Just i) []
    Var v       -> Tr s e (getVar v s) []
    Plus e1 e2  -> let (t1,t2) = (evalT s e1,evalT s e2)
                    in Tr s e (map2 (+) (getVal t1) (getVal t2)) [t1,t2]
    Let v e1 e2 -> let t1 = evalT s e1
                       t2 = evalT ((v,getVal t1)::s) e2
                    in Tr s e (getVal t2) [t1,t2]


-- Filter out specific expressions from traces
--
notLit : Expr -> Bool
notLit e = case e of
    Lit _ -> False
    _     -> True

notVar : Expr -> Bool
notVar e = case e of
    Var _ -> False
    _     -> True

true _ = True


-- Instantiate tracer for expressions (with filters)
--
traceExpr : (Expr -> Bool) -> Expr -> RTree String
traceExpr = trace ppEV (evalT [])

tr : Expr -> RTree String
tr = traceExpr true

trL : Expr -> RTree String
trL = traceExpr notLit

trLV : Expr -> RTree String
trLV = traceExpr (and notLit notVar)
