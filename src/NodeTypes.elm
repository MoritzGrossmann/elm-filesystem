module NodeTypes exposing (Directory, File)

import Dict exposing (Dict)


type alias File =
    {}


type alias Directory a =
    { childs : Dict String a
    , open : Bool
    }
