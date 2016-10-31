module Players.Update exposing (..)

import Navigation
import Players.Messages exposing (Msg(..))
import Players.Models exposing (Player, PlayerId, Players, PartialPlayer, generateNewPlayer)
import Players.Commands exposing (save, delete, create)


update : Msg -> Players -> PartialPlayer -> Bool -> ( Players, PartialPlayer, Bool, Cmd Msg )
update msg players newPlayer editing =
    case msg of
        FetchAllDone newPlayers ->
            (  newPlayers, newPlayer, editing, Cmd.none )

        FetchAllFail error ->
            ( players, newPlayer, editing, Cmd.none )

        ChangeLevel id howMuch ->
            ( players, newPlayer, editing, changeLevelCommands id howMuch players |> Cmd.batch )

        SaveSuccess updatedPlayer ->
            ( updatePlayer updatedPlayer players, newPlayer, editing, Cmd.none )

        SaveFail err ->
            ( players, newPlayer, editing, Cmd.none )

        ShowPlayers ->
            ( players, newPlayer, editing, Navigation.newUrl "#players" )

        ShowPlayer playerId ->
            ( players, newPlayer, editing, Navigation.newUrl ("#players/" ++ (toString playerId)) )

        DeletePlayer id ->
            ( players, newPlayer, editing, deletePlayerCommands id players |> Cmd.batch )

        DeleteFail err ->
            ( players, newPlayer, editing, Cmd.none )

        DeleteSuccess id ->
            ( removePlayer id players, newPlayer, editing, Cmd.none )

        CreatePlayerForm ->
            (players, newPlayer, editing, Navigation.newUrl "#player/new" )        

        UpdateNewPlayer newNameValue ->
            (players, {newPlayer | name = newNameValue }, editing, Cmd.none )

        CreateNewPlayer ->
            (players, newPlayer, editing, saveNewPlayerCommand newPlayer)
        
        CreateNewPlayerSuccess newPlayer ->
            (addNewPlayerToList newPlayer players, generateNewPlayer, editing, Navigation.newUrl "players")

        CreateNewPlayerFail err ->
            (players, newPlayer, editing, Cmd.none)

        ChangeName id newName ->
            (players, newPlayer, editing, List.append (changeNameCommand id newPlayer.name players) [Navigation.newUrl "players"] |> Cmd.batch)

        UpdateFormName updatedName ->
            (players, {newPlayer | name = updatedName}, editing, Cmd.none)
        
        ToggleEdit player ->
            let
              (updatedNewPlayer, updatedEdit) = 
                copyPlayerToPartailOrClear player newPlayer editing
            in
            ( players, updatedNewPlayer, updatedEdit , Cmd.none )

copyPlayerToPartailOrClear : Player -> PartialPlayer -> Bool -> ( PartialPlayer, Bool )
copyPlayerToPartailOrClear player newPlayer editing =
    if editing == True then
        ( generateNewPlayer, False )
    else 
        ({ newPlayer | name = player.name, level = player.level}, True )

addNewPlayerToList : Player -> Players ->Players
addNewPlayerToList newPlayer players =  
    let
      allPlayers = newPlayer :: players
    in
      List.sortBy .id allPlayers


saveNewPlayerCommand : PartialPlayer -> Cmd Msg
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

changeNameCommand : PlayerId -> String -> Players -> List (Cmd Msg)
changeNameCommand playerId newName players =  
    let
        cmdForPlayer existingPlayer =
            if existingPlayer.id == playerId then
                save { existingPlayer | name = newName }
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
