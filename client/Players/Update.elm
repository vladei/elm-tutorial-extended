module Players.Update exposing (..)

import Navigation
import Players.Messages exposing (Msg(..))
import Players.Models exposing (Player, PlayerId, Players)
import Players.Commands exposing (save, delete)


update : Msg -> Players -> ( Players, Cmd Msg )
update msg players =
    case msg of
        FetchAllDone newPlayers ->
            ( newPlayers, Cmd.none )

        FetchAllFail error ->
            ( players, Cmd.none )

        ChangeLevel id howMuch ->
            ( players, changeLevelCommands id howMuch players |> Cmd.batch )

        SaveSuccess updatedPlayer ->
            ( updatePlayer updatedPlayer players, Cmd.none )

        SaveFail err ->
            ( players, Cmd.none )

        ShowPlayers ->
            ( players, Navigation.newUrl "#players" )

        ShowPlayer playerId ->
            ( players, Navigation.newUrl ("#players/" ++ (toString playerId)) )

        DeletePlayer id ->
            ( players, deletePlayerCommands id players |> Cmd.batch )

        DeleteFail err ->
            ( players, Cmd.none )

        DeleteSuccess id ->
            ( removePlayer id players, Cmd.none )


changeLevelCommands : PlayerId -> Int -> Players -> List (Cmd Msg)
changeLevelCommands playerId levelToAdd players =
    let
        cmdForPlayer existingPlayer =
            if existingPlayer.id == playerId then
                save { existingPlayer | level = existingPlayer.level + levelToAdd }
            else
                Cmd.none
    in
        List.map cmdForPlayer players


updatePlayer : Player -> Players -> Players
updatePlayer updatedPlayer players =
    let
        updatePlayerIfNeeded existingPlayer =
            if existingPlayer.id == updatedPlayer.id then
                updatedPlayer
            else
                existingPlayer
    in
        List.map updatePlayerIfNeeded players


deletePlayerCommands : PlayerId -> Players -> List (Cmd Msg)
deletePlayerCommands playerId players =
    let
        cmdForPlayer existingPlayer =
            if existingPlayer.id == playerId then
                delete existingPlayer
            else
                Cmd.none
    in
        List.map cmdForPlayer players


removePlayer : PlayerId -> Players -> Players
removePlayer playerId players =
  let
    removePlayerIfMatch player = 
        player.id /= playerId 
  in
    List.filter removePlayerIfMatch players