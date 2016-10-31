module Update exposing (..)

import Messages exposing (Msg(..))
import Models exposing (Model)
import Players.Update

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        PlayersMsg subMsg->
            let
              (updatedPlayers, updatedNewPlayer, cmd) = 
                Players.Update.update subMsg model.players model.newPlayer
            in
              ( {model | players = updatedPlayers, newPlayer = updatedNewPlayer }, Cmd.map PlayersMsg cmd)