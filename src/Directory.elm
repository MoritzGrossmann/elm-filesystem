module Directory exposing (Directory, add)

import Dict exposing (Dict)


type alias Directory a =
    { childs : Dict String a
    , open : Bool
    }


add : a -> String -> Directory a -> Directory a
add child identifier directory =
    { directory | childs = directory.childs |> Dict.insert identifier child }
