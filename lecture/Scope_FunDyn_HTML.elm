module Scope_FunDyn_HTML exposing (..)-- Use with "elm reactor"

import Trace exposing (..)
import LineCursor exposing (..)
import Html exposing (Html)
import Browser

import Scope_FunDyn exposing (..)

main = Browser.element {
    init = initStateHtml (tr letfx),
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
-}

traceExpr : (Expr -> Bool) -> Expr -> List (Html a)
traceExpr = htmlTrace ppEV (evalT [])

tr : Expr -> List (Html a)
tr = traceExpr true

trL : Expr -> List (Html a)
trL = traceExpr notLit

trLF : Expr -> List (Html a)
trLF = traceExpr (and notLit notFun)

trLV : Expr -> List (Html a)
trLV = traceExpr (and notLit notVar)
