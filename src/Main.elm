module Main exposing (main)

import Browser
import Dict exposing (Dict)
import FileSystem exposing (FileSystem)
import FontAwesome
import Html exposing (Attribute, Html)
import Html.Attributes as A
import Html.Events as Ev
import Node exposing (Node, NodeName(..), NodeType)


main =
    Browser.document
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


type alias Model =
    { fileSystem : FileSystem
    , content : String
    }


childs : Dict String Node
childs =
    [ ( "/entwicklung/inode1", { name = NodeName "File 1", type_ = Node.File {} } )
    , ( "/entwicklung/inode2", { name = NodeName "File 2", type_ = Node.File {} } )
    , ( "/entwicklung/inoed3", { name = NodeName "File 3", type_ = Node.File {} } )
    , ( "/entwicklung/folder2"
      , { name = NodeName "Subfolder"
        , type_ =
            Node.Directory
                { open = False
                , childs =
                    [ ( "/entwicklung/folder2/inode1", { name = NodeName "File 1", type_ = Node.File {} } )
                    , ( "/entwicklung/folder2/inode2", { name = NodeName "File 2", type_ = Node.File {} } )
                    , ( "/entwicklung/folder2/inode3", { name = NodeName "File 3", type_ = Node.File {} } )
                    ]
                        |> Dict.fromList
                }
        }
      )
    ]
        |> Dict.fromList


initNodes : Dict String Node
initNodes =
    [ ( "/entwicklung", { name = NodeName "Entwicklung", type_ = Node.Directory { open = False, childs = childs } } )
    ]
        |> Dict.fromList


init : () -> ( Model, Cmd Msg )
init flags =
    ( { fileSystem = FileSystem.init initNodes, content = "" }, Cmd.none )


type Msg
    = NoOp
    | FileSystemMsg FileSystem.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case Debug.log "Message" msg of
        NoOp ->
            ( model, Cmd.none )

        FileSystemMsg fileSystemMsg ->
            let
                ( newFileSystem, fileSystemCmd ) =
                    FileSystem.update fileSystemMsg model.fileSystem
            in
            ( { model | fileSystem = newFileSystem }, fileSystemCmd |> Cmd.map FileSystemMsg )


view : Model -> Browser.Document Msg
view model =
    { title = ""
    , body =
        [ Html.div [ A.class "container-fluid" ]
            [ Html.div [ A.class "row flex-xl-nowrap" ]
                [ Html.div [ A.class "d-none d-xl-block col-xl-2 bd-toc" ]
                    [ Html.form [ A.class "bd-search d-flex align-items-center" ] []
                    , viewNodes model.fileSystem.rootNodes
                    ]
                , Html.main_ [ A.class "col-12 col-md-9 col-xl-8 py-md-3 pl-md-5 bd-content" ]
                    [ viewContent ]
                , Html.div [ A.class "col-12 col-md-3 col-xl-2 bd-sidebar" ] []
                ]
            ]
        ]
    }


viewContent : Html Msg
viewContent =
    Html.div []
        [ Html.h1 [] [ Html.text "Content ..." ]
        ]


viewNodes : Dict String Node -> Html Msg
viewNodes nds =
    Html.ul [ A.class "section-nav" ]
        (nds |> Dict.toList |> List.map viewNode)


viewNode : ( String, Node ) -> Html Msg
viewNode node =
    let
        ( identifier, n ) =
            node

        frame =
            nodeFrame n.type_
    in
    frame [ A.class "toc-entry toc-h2" ]
        (nodeContent node)


nodeContent : ( String, Node ) -> List (Html Msg)
nodeContent ( identitfier, node ) =
    case node.type_ of
        Node.File _ ->
            [ Html.span
                [ Ev.onClick (Node.NodeSelected identitfier) ]
                [ FontAwesome.viewIcon FontAwesome.Regular FontAwesome.FileAlt, Html.span [ A.class "ml-2" ] [ Html.text (Node.nodeNameToString node.name) ] ]
                |> Html.map FileSystem.NodeMsg
                |> Html.map FileSystemMsg
            ]

        Node.Directory dir ->
            let
                icon =
                    case dir.open of
                        True ->
                            FontAwesome.viewIcon FontAwesome.Regular FontAwesome.FolderOpen

                        False ->
                            FontAwesome.viewIcon FontAwesome.Regular FontAwesome.Folder
            in
            [ Html.span
                [ Ev.onClick (Node.NodeSelected identitfier) ]
                [ icon, Html.span [ A.class "ml-2" ] [ Html.text (Node.nodeNameToString node.name) ] ]
                |> Html.map FileSystem.NodeMsg
                |> Html.map FileSystemMsg
            , case dir.open of
                False ->
                    Html.text ""

                True ->
                    Html.ul [] (dir.childs |> Dict.toList |> List.map viewNode)
            ]

        Node.Pointer _ ->
            []


nodeFrame : NodeType -> (List (Attribute msg) -> List (Html msg) -> Html msg)
nodeFrame type_ =
    case type_ of
        Node.Directory _ ->
            Html.li

        Node.File _ ->
            Html.li

        Node.Pointer node ->
            nodeFrame node.type_


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
