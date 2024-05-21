module Practice2 exposing (..)module Practice2 exposing (..)

replFst : a -> List a -> List a
replFst y l = case l of
    []    -> []
    x::xs -> y::xs

ys = [2,3]
zs = replFst 5 ys
bs = ys ++ [99]

type Tree = Node Int Tree Tree | Leaf

inorder : Tree -> List Int
inorder t = case t of
    Leaf       -> []
    Node x l r -> inorder l ++ [x] ++ inorder r

find : Int -> Tree -> Bool
find n t = case t of
    Leaf       -> False
    Node k l r -> k==n || find n l || find n r

mkTriple x y z = (x,y,z)

map : (a -> b) -> List a -> List b
map f l = case l of
    []    -> []
    x::xs -> f x::map f xs

isEven : Int -> Bool
isEven n = case n of
    0 -> True
    1 -> False
    k -> isEven (k-2)

upTo n = List.range 1 n

foldr : (a -> a -> a) -> a -> List a -> a
foldr f u l = case l of
    []    -> u
    x::xs -> f x (foldr f u xs)

(<<) : (b -> c) -> (a -> b) -> a -> c
(f << g) x = f (g x)
