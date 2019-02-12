module Node exposing (Node, NodeName(..), NodeType(..), nodeNameToString)

import NodeTypes


type alias Node =
    { type_ : NodeType
    , name : NodeName
    }


type NodeType
    = Directory (NodeTypes.Directory Node)
    | File NodeTypes.File
    | Pointer Node


type Operation
    = NodeSelected


updateNode : Operation -> Node -> Node
updateNode op node =
    case op of
        NodeSelected ->
            case node.type_ of
                Directory dir ->
                    { node | type_ = Directory { dir | open = not dir.open } }

                File file ->
                    node

                Pointer n ->
                    updateNode op n


isLeave : Node -> Bool
isLeave node =
    case node.type_ of
        Directory d ->
            List.length d.childs == 0

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
