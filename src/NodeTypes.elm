module NodeTypes exposing (Directory, File)


type alias File =
    {}


type alias Directory a =
    { childs : List a
    , open : Bool
    }
