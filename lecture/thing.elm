module Thing exposing (..)

-- cmd ::= pen mode
-- | moveto (pos,pos)
-- | def name ( pars ) cmd
-- | call name ( vals )
-- | cmd; cmd

-- mode ::= up | down
-- pos ::= num | name
-- pars ::= name, pars | name
-- vals ::= num, vals | num

type Cmd = Pen Mode |
            MoveTo  (Pos,  Pos) |
            Def Name Pars Cmd |
            Call Name Vals |
            Seq Cmd Cmd
            

type Mode = _ Up | _ Down
            

type Pos = Num Int | Name String


type Pars = Tuple Name Pars | Name String


type Vals = Tuple Int Vals | Con Int

