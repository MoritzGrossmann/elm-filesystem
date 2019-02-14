module Node exposing (Msg(..), Node, NodeName(..), NodeType(..), nodeNameToString, update)

import Dict
import NodeTypes


type alias Node =
    { type_ : NodeType
    , name : NodeName
    }


type NodeType
    = Directory (NodeTypes.Directory Node)
    | File NodeTypes.File
    | Pointer Node


type Msg
    = NodeSelected String


update : Msg -> ( String, Node ) -> ( Node, Cmd Msg )
update msg ( nodeIdentifier, node ) =
    case Debug.log "NodeMessage" msg of
        NodeSelected identiefier ->
            case node.type_ of
                Directory dir ->
                    if nodeIdentifier == identiefier then
                        ( { node | type_ = Directory { dir | open = not dir.open } }, Cmd.none )

                    else
                        let
                            concernNode =
                                identiefier |> String.split "/" |> List.take ((nodeIdentifier |> String.split "/" |> List.length) + 1) |> String.join "/"
                        in
                        ( { node
                            | type_ =
                                Directory
                                    { dir
                                        | childs =
                                            dir.childs
                                                |> Dict.update concernNode
                                                    (\mn ->
                                                        mn
                                                            |> Maybe.map
                                                                (\n ->
                                                                    let
                                                                        ( newNode, nodeCmd ) =
                                                                            update msg ( concernNode, n )
                                                                    in
                                                                    newNode
                                                                )
                                                    )
                                    }
                          }
                        , Cmd.none
                        )

                File file ->
                    ( node, Cmd.none )

                Pointer n ->
                    update msg ( "", n )


isLeave : Node -> Bool
isLeave node =
    case node.type_ of
        Directory d ->
            Dict.size d.childs == 0

        File _ ->
            True

        Pointer n ->
            isLeave n


type NodeName
    = NodeName String


nodeNameToString : NodeName -> String
nodeNameToString nodeName =
    let
        (NodeName str) =
            nodeName
    in
    str
