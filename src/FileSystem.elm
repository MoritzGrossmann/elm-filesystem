module FileSystem exposing (FileSystem, Msg(..), init, update)

import Dict exposing (Dict)
import Node exposing (Node)


type alias FileSystem =
    { rootNodes : Dict String Node }


init : Dict String Node -> FileSystem
init nodes =
    { rootNodes = nodes }


type Msg
    = NoOp
    | NodeMsg Node.Msg


update : Msg -> FileSystem -> ( FileSystem, Cmd Msg )
update msg fileSystem =
    case msg of
        NoOp ->
            ( fileSystem, Cmd.none )

        NodeMsg nodeMsg ->
            case nodeMsg of
                Node.NodeSelected identifier ->
                    let
                        concernNode =
                            identifier |> String.split "/" |> List.take 2 |> String.join "/"

                        newNodes =
                            fileSystem.rootNodes
                                |> Dict.update concernNode
                                    (\mn ->
                                        mn
                                            |> Maybe.map
                                                (\n ->
                                                    let
                                                        ( newNode, _ ) =
                                                            Node.update (Node.NodeSelected identifier) ( concernNode, n )
                                                    in
                                                    newNode
                                                )
                                    )
                    in
                    ( { fileSystem | rootNodes = newNodes }, Cmd.none )
