module HW1_Elm exposing (..)
import HW1_Def exposing (..)

-- EXERCISE 1

type alias Bag a = List(a, Int) 


-- insert function
ins : a -> Bag a -> Bag a
ins b c = case c of
    [] ->
        [(b, 1)]
    x::xs ->
        if fst(x) == b then 
            [(b, (snd(x)) + 1)] ++ xs 
        else [x] ++ ins b xs

    
-- delete function
del : a -> Bag a -> Bag a
del b c = case c of
    [] ->
        [(b, 1)]
    x::xs ->
        if fst(x) == b then 
            (if snd(x) == 1 then 
                xs 
            else [(b, (snd(x)) - 1)] ++ xs) 
        else [x] ++ del b xs

        
-- bag function
-- create a multiset from list
bag : List a -> Bag a 
bag a = case a of
    [] -> 
        []
    x::xs -> 
        (ins x (bag xs))


-- 'find' helper function (for subbag)
find : a -> Bag a -> Int
find a b = case b of

    [] -> 0

    (x, y)::xs -> if a == x then y else find a xs

    
-- subbag function
-- check if one bag is the subbag of another
subbag : Bag a -> Bag a -> Bool
subbag a g = case a of

     [] -> False

     (x,y)::xs -> if y <= find x g && find x g /= 0 then True else False

 
-- isSet function
-- check if every element in bag occurs only once
isSet : Bag a -> Bool
isSet a = case a of

    [] -> True

    (x,y)::xs -> if y == 1 then isSet xs else False

    
-- size function 
size : Bag a -> Int  
size w = case w of

    [] -> 0
    
    (x,y)::xs -> y + size xs






-- EXERCISE 2


-- 'untuple' helper function (for nodes function)
untuple : Graph -> List Int
untuple a = case a of
    [] ->
        []
    (x,y)::xs ->
        [x,y] ++ untuple(xs)


-- 'unique' helper function (for nodes and detach functions)
unique : List Int -> List Int
unique a = case a of
    [] ->
        []
    x::xs ->
        x::unique(filter(\val -> val /= x) xs)


-- nodes function
-- return all nodes in graph
nodes : Graph -> List Node
nodes g = unique(untuple(g))


-- myFil helper function (for suc and detach)
myFil : Node -> Graph -> Graph
myFil a b = filter(\n -> fst(n) == a) b


-- myMap helper function (for suc and detach)
myMap : Node -> Graph -> List Node
myMap a b = map (\m -> snd(m)) (myFil a b)


-- suc function
-- return all successor nodes for given node
suc : Node -> Graph -> List Node
suc a b = unique(myMap a b)


-- detach function
-- remove a node and all incindent nodes from graph
detach : Node -> Graph -> Graph
detach a b = filter(\n -> (fst(n) /= a && snd(n) /= a)) b


--EXERCISE 3
-- width function
width : Shape -> Length
width shape = case shape of
    Pt _ ->
        0
    Circle _ radius ->
        2 * radius
    Rect _ rectwidth _ ->
        rectwidth

-- bbox function
-- compute bounding box of a shape
bbox : Shape -> BBox
bbox shape = case shape of
    Pt point -> 
        (point, point)
    Circle (x, y) radius -> 
        ((x - radius, y - radius), (x + radius, y + radius))
    Rect (x, y) rectWidth rectHeight ->
        ((x, y), (x + rectWidth, y + rectHeight))

-- minX function
minX : Shape -> Number
minX shape = case shape of
    Pt(x, _) -> 
        x
    Circle(x, _) radius ->
        x - radius
    Rect(x, _) rectWidth rectHeight ->
        x

-- addPoint helper function (for move function)
-- just adds the x and y coordinates
addPoint : Point -> Point -> Point
addPoint (x1, y1) (x2, y2) =
    (x1 + x2, y1 + y2)

-- move function
move : Point -> Shape -> Shape
move vector shape =
    case shape of
        Pt (x, y) -> 
            Pt (addPoint (x,y) vector)
        Circle(x, y) radius ->
            Circle (addPoint (x,y) vector) radius
        Rect(x, y) rectWidth rectHeight ->
            Rect (addPoint (x,y) vector) rectWidth rectHeight