module Main exposing (main)

import Browser
import FontAwesome
import Html exposing (Attribute, Html)
import Html.Attributes as A
import Node exposing (Node, NodeName(..), NodeType)


main =
    Browser.document
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


type alias Model =
    { nodes : List Node }


initNodes : List Node
initNodes =
    [ { name = NodeName "Entwicklung", type_ = Node.Directory { open = False, childs = [] } }
    ]


init : () -> ( Model, Cmd Msg )
init flags =
    ( { nodes = initNodes }, Cmd.none )


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )


view : Model -> Browser.Document Msg
view model =
    { title = ""
    , body =
        [ Html.div [ A.class "container-fluid" ]
            [ Html.div [ A.class "row flex-xl-nowrap" ]
                [ Html.div [ A.class "d-none d-xl-block col-xl-2 bd-toc" ]
                    [ Html.form [ A.class "bd-search d-flex align-items-center" ] []
                    , viewNodes model.nodes
                    ]
                , Html.div [ A.class "col-12 col-md-3 col-xl-2 bd-sidebar" ] []
                , Html.main_ [ A.class "col-12 col-md-9 col-xl-8 py-md-3 pl-md-5 bd-content" ]
                    [ viewContent ]
                ]
            ]
        ]
    }


viewContent : Html Msg
viewContent =
    Html.div []
        [ Html.h1 [] [ Html.text "Content" ]
        ]


viewNodes : List Node -> Html Msg
viewNodes nds =
    Html.ul [ A.class "section-nav" ]
        (nds |> List.map viewNode)


viewNode : Node -> Html Msg
viewNode node =
    let
        frame =
            nodeFrame node.type_
    in
    frame [ A.class "toc-entry toc-h2" ]
        (nodeContent node)


nodeContent : Node -> List (Html Msg)
nodeContent node =
    case node.type_ of
        Node.File _ ->
            [ Html.a [] [ FontAwesome.viewIcon FontAwesome.Regular FontAwesome.FileAlt, Html.text (Node.nodeNameToString node.name) ] ]

        Node.Directory dir ->
            let
                icon =
                    case dir.open of
                        True ->
                            FontAwesome.viewIcon FontAwesome.Regular FontAwesome.FolderOpen

                        False ->
                            FontAwesome.viewIcon FontAwesome.Regular FontAwesome.Folder
            in
            [ Html.a [] [ icon, Html.text (Node.nodeNameToString node.name) ]
            , case dir.open of
                False ->
                    Html.text ""

                True ->
                    Html.ul [] (dir.childs |> List.map viewNode)
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
