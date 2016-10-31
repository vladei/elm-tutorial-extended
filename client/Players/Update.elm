module Players.Update exposing (..)

import Navigation
import Players.Messages exposing (Msg(..))
import Players.Models exposing (Player, PlayerId, Players, NewPlayer, generateNewPlayer)
import Players.Commands exposing (save, delete, create)


update : Msg -> Players -> NewPlayer -> ( Players, NewPlayer, Cmd Msg )
update msg players newPlayer =
    case msg of
        FetchAllDone newPlayers ->
            (  newPlayers, newPlayer, Cmd.none )

        FetchAllFail error ->
            ( players, newPlayer, Cmd.none )

        ChangeLevel id howMuch ->
            ( players, newPlayer, changeLevelCommands id howMuch players |> Cmd.batch )

        SaveSuccess updatedPlayer ->
            ( updatePlayer updatedPlayer players, newPlayer, Cmd.none )

        SaveFail err ->
            ( players, newPlayer, Cmd.none )

        ShowPlayers ->
            ( players, newPlayer, Navigation.newUrl "#players" )

        ShowPlayer playerId ->
            ( players, newPlayer, Navigation.newUrl ("#players/" ++ (toString playerId)) )

        DeletePlayer id ->
            ( players, newPlayer, deletePlayerCommands id players |> Cmd.batch )

        DeleteFail err ->
            ( players, newPlayer, Cmd.none )

        DeleteSuccess id ->
            ( removePlayer id players, newPlayer, Cmd.none )

        CreatePlayerForm ->
            (players, newPlayer, Navigation.newUrl "#player/new" )        

        UpdateNewPlayer newNameValue ->
            (players, {newPlayer | name = newNameValue } , Cmd.none )

        CreateNewPlayer ->
            (players, newPlayer, saveNewPlayerCommand newPlayer)
        
        CreateNewPlayerSuccess newPlayer ->
            (addNewPlayerToList newPlayer players, generateNewPlayer, Navigation.newUrl "players")
        
        CreateNewPlayerFail err ->
            (players, newPlayer, Cmd.none)

addNewPlayerToList : Player -> Players ->Players
addNewPlayerToList newPlayer players =  
    let
      allPlayers = newPlayer :: players
    in
      List.sortBy .id allPlayers


saveNewPlayerCommand : NewPlayer -> Cmd Msg
saveNewPlayerCommand newPlayer =
    create newPlayer

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
