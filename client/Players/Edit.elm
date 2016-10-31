module Players.Edit exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, value, href, placeholder, style)
import Html.Events exposing (onClick, onInput)
import Players.Models exposing (..)
import Players.Messages exposing (..)


view : Player -> PartialPlayer ->Bool -> Html Msg
view player copyPlayer editing =
    div []
        [ nav player
        , form player copyPlayer editing
        ]


nav : Player -> Html Msg
nav model =
    div [ class "clearfix mb2 white bg-black p1" ]
        [ listBtn ]


form : Player -> PartialPlayer -> Bool -> Html Msg
form player copyPlayer editing =
    if editing == True then
        div [ class "m12" ]
            [ div []
                [ editableUserName copyPlayer
                , div [ class "m2" ] [ a [ class "btn ml1 h1", onClick (ToggleEdit player) ] [ i [ class "fa fa-edit" ] [] ] ]
                ]
            , formLevel player
            , saveBtn player
            ]
    else
        div [ class "m12" ]
            [ div []
                [ viewOnlyUserName player
                , div [ class "m2" ] [ a [ class "btn ml1 h1", onClick (ToggleEdit player) ] [ i [ class "fa fa-edit" ] [] ] ]
                ]
            , formLevel player
            , saveBtn player
            ]


editableUserName : PartialPlayer -> Html Msg
editableUserName player =
    div [ class "m2" ]
        [ input
            [ placeholder "Player's name"
            , myStyle
            , value player.name
            , onInput UpdateFormName
            ]
            []
        ]


viewOnlyUserName : Player -> Html Msg
viewOnlyUserName player =
    div [ class "m2" ]
        [ h1 [] [ text player.name ] ]


formLevel : Player -> Html Msg
formLevel player =
    div
        [ class "clearfix py1"
        ]
        [ div [ class "col col-5" ] [ text "Level" ]
        , div [ class "col col-7" ]
            [ span [ class "h2 bold" ] [ text (toString player.level) ]
            , btnLevelDecrease player
            , btnLevelIncrease player
            ]
        ]


saveBtn : Player -> Html Msg
saveBtn player =
    button
        [ class "btn regular"
        , onClick (ChangeName player.id player.name)
        ]
        [ i [ class "fa fa-paper-plane-o mr1" ] [], text "Submit" ]


btnLevelDecrease : Player -> Html Msg
btnLevelDecrease player =
    a [ class "btn ml1 h1", onClick (ChangeLevel player.id -1) ]
        [ i [ class "fa fa-minus-circle" ] [] ]


btnLevelIncrease : Player -> Html Msg
btnLevelIncrease player =
    a [ class "btn ml1 h1", onClick (ChangeLevel player.id 1) ]
        [ i [ class "fa fa-plus-circle" ] [] ]


listBtn : Html Msg
listBtn =
    button
        [ class "btn regular"
        , onClick ShowPlayers
        ]
        [ i [ class "fa fa-chevron-left mr1" ] [], text "List" ]


myStyle =
    style
        [ ( "width", "30%" )
        , ( "height", "40px" )
        , ( "padding", "20px 0" )
        , ( "font-size", "2em" )
        , ( "text-align", "center" )
        , ( "margin", "30px" )
        ]
