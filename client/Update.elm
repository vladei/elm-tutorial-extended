module Update exposing (..)

import Messages exposing (Msg(..))
import Models exposing (Model)
import Players.Update

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        PlayersMsg subMsg->
            let
              (updatedPlayers, updatedNewPlayer, newEditing, cmd) = 
                Players.Update.update subMsg model.players model.newPlayer model.editing
            in
              ( {model | players = updatedPlayers, newPlayer = updatedNewPlayer , editing = newEditing}, Cmd.map PlayersMsg cmd)