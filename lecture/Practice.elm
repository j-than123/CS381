module Practice exposing (..)module Practice exposing (..)

type Nat = Zero | Suc Nat

pp : Nat -> Int
pp n = case n of
    Zero  -> 0
    Suc k -> 1+pp k

fromInt : Int -> Nat
fromInt i = case i of
    0 -> Zero
    k -> Suc (fromInt (k-1))

one = Suc Zero
two = Suc one
v   = fromInt 5
vi  = fromInt 6
-- x   = fromInt 10

add : Nat -> Nat -> Nat
add n m = case n of
    Zero  -> m
    Suc k -> Suc (add k m)

isEmpty : List a -> Bool
isEmpty l = case l of
    [] -> True
    _  -> False

-- type Maybe a = Just a | Nothing

head : List a -> Maybe a
head l = case l of
    []   -> Nothing
    x::_ -> Just x

sum : List Int -> Int
sum l = case l of
    []    -> 0
    x::xs -> x + sum xs

length : List a -> Int
length l = case l of
    []    -> 0
    _::xs -> 1 + length xs

member : a -> List a -> Bool
member y l = case l of
    []    -> False
    -- x::xs -> if x==y then True else member y xs
    x::xs -> x==y || member y xs

snd : List a -> Maybe a
snd l = case l of
    _::y::_ -> Just y
    _       -> Nothing
    -- x::(y::ys) -> Just y
    -- [_]        -> Nothing
    -- []         -> Nothing
    -- []    -> Nothing
    -- x::xs -> head xs
