module View exposing (..)

import Html exposing (Html, div, text)
import Html.App
import Messages exposing (Msg(..))
import Models exposing (Model)
import Routing exposing (Route(..))
import Players.Models exposing (PlayerId)
import Players.List
import Players.Edit
import Players.Create


view : Model -> Html Msg
view model =
    div []
        [ page model ]

page : Model -> Html Msg
page model =
    case model.route of
        PlayersRoute ->
            Html.App.map PlayersMsg (Players.List.view model.players)

        PlayerRoute id ->
            playersEditPage model id

        PlayerCreate ->
            Html.App.map PlayersMsg (Players.Create.view model.newPlayer) 

        NotFoundRoute ->
            notFoundView


playersEditPage : Model -> PlayerId -> Html Msg
playersEditPage model playerId =
    let
        maybePlayer =
            model.players
                |> List.filter (\player -> player.id == playerId)
                |> List.head
    in
        case maybePlayer of
            Just player ->
                Html.App.map PlayersMsg (Players.Edit.view player)

            Nothing ->
                notFoundView


notFoundView : Html Msg
notFoundView =
    div []
        [ text "Not Found"
        ]
