module Trace exposing (..)

import Html exposing (Html,Attribute,div,code,text,br)
import Html.Attributes exposing (style)

import List exposing (foldr,concat,map)


type alias Stk v = List (String,v)

type Trace e v = Tr (Stk v) e v (List (Trace e v))

getVal : Trace e v -> v
getVal t = case t of Tr _ _ v _ -> v

getExpr : Trace e v -> e
getExpr t = case t of Tr _ e _ _ -> e

getSub : Trace e v -> List (Trace e v)
getSub t = case t of Tr _ _ _ ts -> ts


-- Managing trace filters
--
and : (a -> Bool) -> (a -> Bool) -> a -> Bool
and p q = \x->p x && q x

filterOut : (e -> Bool) -> Trace e v -> Trace e v
filterOut p (Tr s e v ts) =
    let ts2 = List.filter (p << getExpr) ts
        ts3 = List.map (filterOut p) ts2
     in Tr s e v ts3


-- Pretty printing traces
--
type alias PP e v =
    {ppE : e -> String,
     ppV : v -> String}

ppStk : PP e v -> Stk v -> String
ppStk pp = asList (\(n,v)->n++"➔"++pp.ppV v)

type RTree a = N a (List (RTree a))

asList : (a -> String) -> List a -> String
asList f l = "[" ++ String.join "," (map f l) ++ "]"

ppTrace : PP e v -> Trace e v -> RTree (String,String,String)
ppTrace pp t = case t of
    Tr s e v ts -> N (ppStk pp s,pp.ppE e,pp.ppV v)
                     (map (ppTrace pp) ts)

ppTraceString : PP e v -> Trace e v -> RTree String
ppTraceString pp t = case t of
    Tr s e v ts -> N (ppStk pp s++" : "++pp.ppE e++" 🡪 "++pp.ppV v)
                     (map (ppTraceString pp) ts)

trace : PP e v -> (e -> Trace e v) -> (e -> Bool) -> e -> RTree String
trace pp eval fs = ppTraceString pp << filterOut fs << eval

htmlTrace : PP e v -> (e -> Trace e v) -> (e -> Bool) -> e -> List (Html a)
htmlTrace pp eval fs = tr2html 0 << ppTrace pp << filterOut fs << eval


-- Generate List and HTML output of traces
--
highlight : Attribute a
highlight = style "color" "Brown"

ident : Int -> Html a
ident i = code [style "color" "white"] [text (String.repeat (6*i) "_")]

fmtStack : String -> Html a
fmtStack s = code [highlight] [text s]

line : Int -> String -> String -> String -> Html a
line i s t u =
    div [] [ident i,fmtStack (s++" "),
     code [] [text t],
     code [highlight] [text " ➤➤ "],
     code [] [text u],br [] []]

tr2html : Int -> RTree (String,String,String) -> List (Html a)
tr2html i t = case t of
    N (s,e,v) ts -> line i s e v :: concat (map (tr2html (i+1)) ts)
