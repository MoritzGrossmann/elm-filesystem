module FontAwesome exposing (Icon(..), Version(..), viewIcon)

import Html exposing (Html, i)
import Html.Attributes exposing (classList)


type Version
    = Solid
    | Regular
    | Light


versionClass : Version -> String
versionClass version =
    case version of
        Solid ->
            "fas"

        Regular ->
            "far"

        Light ->
            "fal"


viewIcon : Version -> Icon -> Html msg
viewIcon version icon =
    i [ classList [ ( version |> versionClass, True ), ( "fa-" ++ iconClass icon, True ) ] ] []


type Icon
    = Folder
    | FolderOpen
    | FileAlt


iconClass : Icon -> String
iconClass icon =
    case icon of
        Folder ->
            "folder"

        FolderOpen ->
            "folder-open"

        FileAlt ->
            "file-alt"
