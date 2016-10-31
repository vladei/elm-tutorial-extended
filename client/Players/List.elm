module Players.List exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Players.Messages exposing (..)
import Players.Models exposing (Player, Players)


view : Players -> Html Msg
view players =
    div []
        [ nav players
        , list players
        , create
        ]


nav : Players -> Html Msg
nav players =
    div [ class "clearfix mb2 white bg-black" ]
        [ div [ class "left p2" ] [ text "Players" ]
        ]


list : Players -> Html Msg
list players =
    div [ class "p2" ]
        [ table []
            [ thead []
                [ tr []
                    [ th [] [ text "Id" ]
                    , th [] [ text "Name" ]
                    , th [] [ text "Level" ]
                    , th [] [ text "Actions" ]
                    ]
                ]
            , tbody [] (List.map playerRow players)
            ]
        ]

create : Html Msg
create =
    div []
        [createBtn]

createBtn : Html Msg
createBtn =
    button
        [ class "btn regular"
        , onClick CreatePlayerForm
        ]
        [ i [ class "fa fa-pencil mr1" ] [], text "Create Player" ]


playerRow : Player -> Html Msg
playerRow player =
    tr []
        [ td [] [ text (toString player.id) ]
        , td [] [ text player.name ]
        , td [] [ text (toString player.level) ]
        , td []
            [ editBtn player, deletePlayerBtn player ]
        ]


editBtn : Player -> Html Msg
editBtn player =
    button
        [ class "btn regular"
        , onClick (ShowPlayer player.id)
        ]
        [ i [ class "fa fa-pencil mr1" ] [], text "Edit" ]


deletePlayerBtn : Player -> Html Msg
deletePlayerBtn player =
    button
        [ class "btn regular"
        , onClick (DeletePlayer player.id)
        ]
        [ i [ class "fa fa-trash mr1" ] [], text "Delete" ]
