module Players.Create exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, value, href, for, id, type', style, placeholder)
import Html.Events exposing (onClick, onInput)
import Players.Models exposing (..)
import Players.Messages exposing (..)


view : NewPlayer -> Html Msg
view model =
    div []
        [ nav
        , form model
        ]
        
nav : Html Msg
nav =
    div [ class "clearfix mb2 white bg-black p1" ]
        [ text "Players" ]


form : NewPlayer -> Html Msg
form model =
    div [ class "m3" ]
        [ h1 [] [ text "Create User" ]
        , div [ class "col-md-offset-2 col-md-8" ]
            [ input
                [ placeholder "Player's name"
                , class "form-control"
                , myStyle
                , value model.name
                , onInput UpdateNewPlayer
                ]
                []
            ]
        , div []
            [ button
                [ class "btn ml1", onClick CreateNewPlayer]
                [ i [ class "fa fa-plus-circle"] [], text " Submit" ]
            ]
        ]
        

myStyle =
    style
        [ ( "width", "50%" )
        , ( "height", "40px" )
        , ( "padding", "20px 0" )
        , ( "font-size", "2em" )
        , ( "text-align", "center" )
        , ( "margin", "30px" )
        ]
