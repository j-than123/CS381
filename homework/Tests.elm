module Tests exposing (..)

import Expect exposing(..)
import Test exposing (..)
import HW4_Types exposing (..)

tests : Test
tests =
    describe "HW4_Types Tests"
        [ test "rankOp should return correct rank for LD operation" <|
            \_ ->
                rankOp (LD 5)
                    |> Expect.equal (0,1)
        , test "rankOp should return correct rank for ADD operation" <|
            \_ ->
                rankOp ADD
                    |> Expect.equal (2,1)
        ]

        
bboxTest = TD (LR X X) (LR (TD X X) X)

bboxTest2 = LR (LR X X) (TD X (TD X X))

bboxTest3 = TD (LR (LR X X) X) (LR (LR X X) X)
rankOp (LD 5)
rankP [LD 5, ADD, MULT]
semTC [LD 5, ADD, MULT]
bboxTest3