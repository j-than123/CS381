module Scope_Var_HTML exposing (..)-- Use with "elm reactor"
--
import Trace exposing (..)
import LineCursor exposing (..)
import Html exposing (Html)
import Browser

import Scope_Var exposing (..)


main = Browser.element {
    init = initStateHtml (trL letxy3),
    view = lineCursorHtml "Evaluation w/o literals",
    update = upAndDownHtml,
    subscriptions = readKeysHtml }

{-
letx   = Let "x" n1 n1
letx2  = Let "x" n1 x
letxy  = Let "x" n1 (Let "y" n2 (Plus x y))
letxy2 = Let "x" n1 (Plus (Let "y" n2 x) y)
letxy3 = Let "x" n1 (Plus (Let "y" n2 y) x)
letxx  = Let "x" n1 (Let "x" n2 (Plus x x))
letxx2 = Let "x" n1 (Plus (Let "x" n2 x) x)
noRec  = Let "x" x x
loop   = Let "x" (Let "x" x x) x
-}

traceExpr : (Expr -> Bool) -> Expr -> List (Html a)
traceExpr = htmlTrace ppEV (evalT [])

tr : Expr -> List (Html a)
tr = traceExpr true

trL : Expr -> List (Html a)
trL = traceExpr notLit

trLV : Expr -> List (Html a)
trLV = traceExpr (and notLit notVar)
