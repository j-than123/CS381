module Syntax_Practice exposing (..)

import String exposing (fromInt,join)
map = List.map

-- IMPERATIVE LANGUAGE
--
-- expr  ::=  num  |  var  |  expr * expr
-- stmt  ::=  var := expr  |  stmt ; stmt
--        |  FOR var := expr TO expr DO stmt END

type Expr = Con Int | Var String | Times Expr Expr
type Stmt = Assg String Expr
          | Seq Stmt Stmt
          | For String Expr Expr Stmt
            -- (f) Extend language
          | Proc String (List String) Stmt
          | Call String (List Expr)

-- x := 1; FOR y := 2*x TO 7 DO x := x*y

x = Var "x"
y = Var "y"

c1 = Con 1
c2 = Con 2
c7 = Con 7

prog : Stmt
prog = Seq (Assg "x" c1)
           (For "y" (Times c2 x) c7
                (Assg "x" (Times x y))
           )

ppE : Expr -> String
ppE e = case e of
    Con i -> fromInt i
    Var s -> s
    -- Times e1 e2 -> ppE e1 ++ "*" ++ ppE e2
    Times e1 e2 -> "(" ++ ppE e1 ++ ")" ++ "*" ++ "(" ++ ppE e2 ++")"

ppS : Stmt -> String
ppS s = case s of
    Assg v e      -> v ++ " := " ++ ppE e
    Seq s1 s2     -> ppS s1 ++ "; " ++ ppS s2
    For v e1 e2 b -> "FOR " ++ v ++ " := " ++ ppE e1 ++ " TO "
                     ++ ppE e2 ++ " DO " ++ ppS b ++ " END"
    -- For v e1 e2 b -> "for " ++ v ++ " = " ++ ppE e1 ++ " to "
    --                  ++ ppE e2 ++ " { " ++ ppS b ++ " }"
        -- FOR var := expr TO expr DO stmt END
    -- (g) Extend language
    Proc v vs b   -> "PROC " ++ v ++ "(" ++ join " " vs
                     ++") { " ++ ppS b ++ " }"
    Call v es     -> "CALL " ++ v ++ "(" ++ join " " (map ppE es)
                     ++")"

genFac : Int -> Stmt
genFac n = Seq (Assg "fac" c1)
               (For "x" c2 (Con n)
                    (Assg "fac" (Times x (Var "fac")))
               )
-- fac := 1; FOR x := 2 TO n DO fac := x*fac

-- (h)
-- Represent:
-- PROC dbl(x result) { result := 2*x }; CALL dbl(7 x)

dbl : Stmt
dbl = Seq (Proc "dbl" ["x","result"] (Assg "result" (Times c2 x)))
          (Call "dbl" [c7,x])


-- 0 * e --> 0
-- 1 * e --> e
opt : Expr -> Expr
opt e = case e of
    Times (Con 0) _ -> Con 0
    Times _ (Con 0) -> Con 0
    Times (Con 1) r -> r
    Times l (Con 1) -> l
    Times l r       -> opt (Times (opt l) (opt r))
    other           -> other

c0 = Con 0

e07 = Times c0 c7
e17 = Times c1 c7
e77 = Times c7 c7
e1_07 = Times c1 e07
e1_17 = Times c1 e17
e07_17 = Times e07 e17
e11_17 = Times (Times c1 c1) e17

tests = [e07,e17,e77,e1_07,e1_17,e07_17,e11_17]

-- opt repeatedly traverses an expression top-down, whereas
-- optimize performs a single bottom-up traversal

optimize : Expr -> Expr
optimize e = case e of
    Times e1 e2 ->
        case (optimize e1,optimize e2) of
             (Con 0,_) -> Con 0
             (_,Con 0) -> Con 0
             (Con 1,r) -> r
             (l,Con 1) -> l
             (l,r)     -> Times l r
    other     -> other
