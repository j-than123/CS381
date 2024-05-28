module LineCursor exposing (State, Move,
    initState,lineCursor,upAndDown,readKeys,
    initStateHtml,lineCursorHtml,upAndDownHtml,readKeysHtml)

import Browser
import Browser.Events exposing (onKeyDown)
import Html exposing (..)
import Html.Events exposing (on,keyCode,onClick)
import Html.Attributes exposing (..)
import Json.Decode as Decode
import List exposing (range,length,indexedMap)

testData : List String
testData = ["First line", "Second line", "Third line", "Fourth line"]

testDataHtml : List (Html Move)
testDataHtml = List.map (\s->div [] [text s]) testData

type alias PP a = a -> String
type alias State a = (Int,List a,PP a)
type alias StateHtml = (Int,List (Html Move))

initState : List a -> PP a -> () -> (State a, Cmd Move)
initState data pp _ = noCmd (0,data,pp)

initStateHtml : List (Html Move) -> () -> (StateHtml, Cmd Move)
initStateHtml data _ = noCmd (0,data)


main = Browser.element {
    -- init = initState testData (\x->x),
    -- init = initStateHtml testData (\x->div [] [text x]),
    init = initStateHtml testDataHtml,
    view = lineCursorHtml "Line Cursor",
    update = upAndDownHtml,
    subscriptions = readKeysHtml }

lineCursor : String -> State a -> Html Move
lineCursor title (cnt,s,pp) =
    Html.div [style "display" "list-item"]
        ((h4 [] [text title]) ::
         indexedMap (formatLine pp cnt) s ++
         buttons)

lineCursorHtml : String -> StateHtml -> Html Move
lineCursorHtml title (cnt,s) =
    Html.div [style "display" "list-item"]
        ((h4 [] [text title]) ::
         indexedMap (formatLineHtml cnt) s ++
         buttons)

upAndDown : Move -> State a -> (State a,Cmd Move)
upAndDown m (cnt,s,pp) = noCmd (wrapAround (length s) (m cnt),s,pp)

upAndDownHtml : Move -> StateHtml -> (StateHtml,Cmd Move)
upAndDownHtml m (cnt,s) = noCmd (wrapAround (length s) (m cnt),s)


-- Line formatting
--
highlight : List (Attribute a)
highlight = [style "background-color" "PapayaWhip"]
-- highlight = [style "background-color" "LightGray"]
-- highlight = [style "background-color" "Bisque"]
-- highlight = [style "background-color" "Linen"]

formatLine : PP a -> Int -> Int -> a -> Html b
formatLine pp c k x =
    div (if c==k then highlight else [])
        [code [] [text (pp x)]]

formatLineHtml : Int -> Int -> Html Move -> Html Move
formatLineHtml c k h =
    div (if c==k then highlight else []) [h]


-- Up and Down movement
--
type alias Move = Int -> Int

prev : Int -> Int
prev x = x-1

next : Int -> Int
next = (+) 1

wrapAround : Int -> Int -> Int
wrapAround n c = if c>=n then 0   else
                 if c<0  then n-1 else c


-- Key strokes and buttons
--
keyDecoder : Decode.Decoder Move
keyDecoder = Decode.map toDirection (Decode.field "key" Decode.string)

toDirection : String -> Move
toDirection s = case s of
    "ArrowUp"    -> prev
    "ArrowLeft"  -> prev
    "ArrowDown"  -> next
    "ArrowRight" -> next
    _            -> \x->x

readKeys : State a -> Sub Move
readKeys _ = Sub.batch [onKeyDown keyDecoder]

readKeysHtml : StateHtml -> Sub Move
readKeysHtml _ = Sub.batch [onKeyDown keyDecoder]

buttons : List (Html Move)
buttons = [button [onClick prev] [text "<<"],
           button [onClick next] [text ">>"]]


-- Auxiliary functions
--
noCmd : a -> (a, Cmd b)
noCmd x = (x,Cmd.none)
