module Scope_FunDyn exposing (..)
-- module Scope_FunDyn exposing (..)

import Maybe exposing (map2)

import Trace exposing (..)


type alias Name = String

type Expr = Lit Int              -- integer constant
          | Plus Expr Expr       -- addition
          | Var Name             -- ref. to a variable
          | Let Name Expr Expr   -- local definition
          | Fun Name Expr        -- function abstracti
          | App Expr Expr        -- application

type Val = I Int              -- integer constants
         | F Name Expr        -- function values
         | Error

type alias Stack = List (Name,Val)

getVar : Name -> Stack -> Val
getVar n s = case s of
    []        -> Error
    (m,v)::s1 -> if n==m then v else getVar n s1

liftIII : (Int -> Int -> Int) -> Val -> Val -> Val
liftIII op v1 v2 = case (v1,v2) of
    (I i,I j) -> I (op i j)
    _         -> Error

eval : Stack -> Expr -> Val
eval s e = case e of
    Lit i       -> I i
    Plus e1 e2  -> liftIII (+) (eval s e1) (eval s e2)
    Var v       -> getVar v s
    Let v e1 e2 -> eval ((v,eval s e1)::s) e2
    Fun v e1    -> F v e1
    App e1 e2   -> case eval s e1 of
                    F v e3 -> eval ((v,eval s e2)::s) e3
                    _      -> Error

-- "smart constructors" to simplify the construction
-- of syntax trees
--
n0 = Lit 0
n1 = Lit 1
n2 = Lit 2
n3 = Lit 3
x  = Var "x"
y  = Var "y"
f  = Var "f"


-- example expressions
--
suc = Fun "y" (Plus y n1)
dbl = Fun "x" (Plus x x)
--- applications
ds3 = App dbl (App suc n3)

letfx = Let "x" (Let "f" suc (App f n1)) x
--- CBValue vs. CBName evaluation
one = Let "x" y n1
four = Let "f" suc (App f (Plus n1 n2))
--- dynamic scope
-- f = Fun "x" (x `Plus` (Fun "y" ()))
dysc = Let "x" n1
           (Let "f" (Fun "y" (Plus y x))
                (Let "x" n2
                     (App f n0)))

-- OLD (from Var)
letx   = Let "x" n1 n1
letxy  = Let "x" n1 (Let "y" n2 (Plus x y))
letxy2 = Let "x" n1 (Plus (Let "y" n2 x) y)
letxy3 = Let "x" n1 (Plus (Let "y" n2 y) x)
letxx  = Let "x" n1 (Let "x" n2 (Plus x x))
letxx2 = Let "x" n1 (Plus (Let "x" n2 x) x)
noRec  = Let "x" x x
loop   = Let "x" (Let "x" x x) x


-- Pretty Printer
--
pp : Expr -> String
pp e = case e of
    Lit i       -> String.fromInt i
    Var v       -> v
    Plus e1 e2  -> ppP e1++"+"++ppP e2
    Let v e1 e2 -> "let "++v++"="++pp e1++" in "++pp e2
    Fun v e1    -> ppF v e1
    App e1 e2   -> case e1 of
                    App _ _ -> pp e1++" "++ppP e2
                    _       -> ppP e1++" "++ppP e2

ppP : Expr -> String
ppP e = case e of
    Lit _ -> pp e
    Var _ -> pp e
    e1    -> "("++pp e1++")"

ppF : Name -> Expr -> String
ppF v e = "λ"++v++"➔"++pp e

ppVal : Val -> String
ppVal val = case val of
    I i   -> String.fromInt i
    F v e -> ppF v e
    Error -> "?"

ppEV : PP Expr Val
ppEV = {ppE = pp, ppV = ppVal}


-- Tracing Evaluator
--
evalT : Stack -> Expr -> Trace Expr Val
evalT s e = case e of
    Lit i       -> Tr s e (I i) []
    Var v       -> Tr s e (getVar v s) []
    Plus e1 e2  -> let (t1,t2) = (evalT s e1,evalT s e2)
                    in Tr s e (liftIII (+) (getVal t1) (getVal t2)) [t1,t2]
    Let v e1 e2 -> let t1 = evalT s e1
                       t2 = evalT ((v,getVal t1)::s) e2
                    in Tr s e (getVal t2) [t1,t2]
    Fun v e1    -> Tr s e (F v e1) []
    App e1 e2   -> case eval s e1 of
             F v e3 -> let t1 = evalT s e2
                           t2 = evalT ((v,getVal t1)::s) e3
                        in Tr s e (getVal t2) [t1,t2]
             _      -> Tr s e Error []


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

notFun : Expr -> Bool
notFun e = case e of
    Fun _ _ -> False
    _       -> True

true _ = True


-- Instantiate tracer for expressions (with filters)
--
traceExpr : (Expr -> Bool) -> Expr -> RTree String
traceExpr = trace ppEV (evalT [])

tr : Expr -> RTree String
tr = traceExpr true

trL : Expr -> RTree String
trL = traceExpr notLit

trLF : Expr -> RTree String
trLF = traceExpr (and notLit notFun)

trLV : Expr -> RTree String
trLV = traceExpr (and notLit notVar)
