-- 4/30/24
-- import Syntax_Practice exposing (dbl)
-- 1. Abstract Syntax

-- type Expr = Num Int
--           | Neg Expr
--           | Plus Expr Expr
--           | Mult Expr Expr

-- -- Exercise 1:
-- -- 1. Abstract Syntax
-- type BExpr = T | F | Or BExpr BExpr | And BExpr BExpr | Not BExpr
-- -- 2/3. Semantic Domain & Function
-- sem : BExpr -> Bool
-- sem B = case B of
--     T           -> True
--     F           -> False
--     Or b1 b2    -> sem b1 || sem b2
--     And b1 b2   -> sem b1 && sem b2
--     Not b       -> not (sem b)

-- --------------------------------
-- -- Domain Constructors
-- --------------------------------
-- ---
-- Type Constructors

-- Domain Construction
-- Products of Domains === USe tuple types
-- Union of Domains === Define data types
-- Adding Errors == Use maybe (or error)
-- Adding State
-- ---
-- ---
-- Example: Move Language
-- Language describe movements on a 2d plane
--  - a step is a horizontal or vertical vector
--  - a movement is a sequence of steps

-- -- 1. Concrete Syntax:
-- -- move ::== go up num | go right num | move ; move

-- type Move = GoUp Int | GoRight Int | Seq Move Move

-- -- 2. Semantic Domain
-- type alias Pos = (Int, Int)

-- -- 3. Semantic Function
-- addPos : Pos -> Pos -> Pos
-- addPos (u,v) (x,y) = (u+x,v+y)

-- sem : Move -> Pos
-- sem m = case m of
--     GoUp n    -> (0, n)
--     GoRight n -> (n, 0)
--     Seq m1 m2 -> addPos (sem m1) (sem m2)

-- -- Exercise:
-- -- 1. Abstract Syntax
-- type Step = Up Int | Rgt Int
-- type alias Move = List Step

-- -- 2. Semantic Domain
-- type alias Pos = (Int, Int)

-- -- 3. Semantic Function
-- addPos : Pos -> Pos -> Pos
-- addPos (u,v) (x,y) = (u+x,v+y)

-- sem : Move -> Pos
-- sem m = case m of
--     [] -> (0,0)
--     Up x::xs  -> addsPos (0,n) (sem xs)
--     Rgt x::xs -> addPos (n,0) (sem xs)

-- -- Exercise:
-- -- 1. Abstract Syntax
-- type Step = Up Int | Rgt Int
-- type alias Move = List Step

-- -- 2. Semantic Domain
-- type alias Dist = Int

-- -- 3. Semantic Function
-- sem : Move Dist
-- sem m = case m of
--     [] -> 0
--     Up x::xs  -> x + sem xs
--     Rgt x::xs -> x + sem xs  

-- ---- Error Domains ----
-- -- Example: Divison by Zero

-- -- 1. Abstract Syntax:
-- type Expr = ... | Div Expr Expr

-- -- 2. Semantic Domain:
-- type Value = Maybe Int

-- -- Factoring Error Handling
-- map2 : (a -> b -> c) -> Maybe a -> Maybe b -> Maybe c
-- map2 f m1 m2 = case (m1, m2) of
--     (Just x, Just y) -> Just (f x y)
--     _                -> Nothing

-- -- 3. Semantic Function
-- sem : Expr -> Maybe Int
-- sem e = case e of
--     Num i -> Just i
--     Plus e1 e2 -> map2 (+) (sem e1) (sem e2)
--     Times e1 e2 -> map2 (*) (sem e1) (sem e2)
--     ...

-- -- Unions Domains
-- -- Example: Two-Type Expressions

-- -- 1. Abstract Syntax
-- type Expr = Num Int | Plus Expr Expr | Equal Expr Expr | Not Expr

-- -- 2. Semantic Domain
-- type Val = I Int | B Bool | Undefined

-- -- 3. Semantic Function
-- sem : Expr -> Val
-- sem e = case e of
--     Num I -> I i
--     ...
--     Plus 

---
-- Stateful Computation
---
-- State Update Domain:
-- If V is a type representing a state, then a domain for 

-- Example: Machine Language
-- 1. Abstract Syntax
-- type Op = LD Int | INC | DBL
-- type alias Prog = List Op

-- -- 2. Semantic Domains
-- type alias State = Int
-- type alias Update = State -> State

-- -- 3. Semantic Functions
-- exec : Op -> State -> State
-- exec op s = case op of
--     LD i -> i
--     INC  -> s+1
--     DBL  -> s*2

-- sem : Prog -> State -> State
-- sem p s = case p of 
--     []      -> s
--     op::ops -> sem ops (exec op s)

-- -- Exercise:
-- type Reg = A | B
-- type Op = LD Reg Int | INC Reg | DBL Reg
-- type alias Prog = List Op

-- type alias State = (Int, Int)
-- type alias Update = State -> State

-- -- exec : Op -> State -> State
-- -- exec op (a,b) = case op of
-- --     LD A i -> (i,b)
-- --     LD B i -> (a,i)
-- --     INC A  -> (a+1,b)
-- --     INC B  -> (a,b+1)
-- --     DBL A  -> (a*2,b)
-- --     DBL B  -> (a,b*2)

-- onReg : Reg -> (Int -> Int) -> Update
-- onReg r f (a,b) = case r of
--     A -> (f a,b)
--     B -> (a,f b)

-- exec : Op -> Update
-- exec op = case op of
--     LD  r i -> onReg r (\_->i)
--     INC r   -> onReg r ((+) 1)
--     DBL r   -> onReg r ((*) 2)

module Semantics exposing (..)

-- type Expr = Lit Int | Succ Expr | Sum (List Expr) | IFPOS Expr Expr

-- ex1 = Sum [Lit 2, Sum [Lit 3, IFPOS (Lit 0) (Succ (Lit 3))]]
-- sem : Expr -> Int
-- sem e = case e of
--     Lit i       -> i
--     Succ e1     -> sem e1 + 1
--     Sum l -> List.sum (List.map l)
--     -- Sum l -> case l of
--         -- []      -> 0
--         -- e1:es   -> sem e1 + sem (Sum es)
--     IFPOS e1 e2 -> 
--         if sem e1>0 then sem e1
--             else sem e2


type alias Pos = (Int, Int)
type Move = JumpTo Pos | UpBy Int | Right | AndThen (List Move)
ex2 = AndThen [JumpTo (1,3), UpBy 2, Right, Right]

type alias D = Pos -> Pos

semM : Move -> D
semM m (x,y) = case m of
    JumpTo p       -> p
    UpBy i         -> (x,y+i)
    Right          -> (x+1,y)
    AndThen []     -> (x,y)
    AndThen (m1::ms) -> semM (AndThen ms) (semM m1 (x,y))

