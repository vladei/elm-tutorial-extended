module Players.Commands exposing (..)

import Http
import Json.Encode as Encode
import Json.Decode as Decode exposing ((:=))
import Task exposing (..)

import Players.Models exposing (PlayerId, Player, Players, NewPlayer)
import Players.Messages exposing (..)


create : NewPlayer -> Cmd Msg
create newPlayer =
    createOnServer newPlayer
        |> Task.perform CreateNewPlayerFail CreateNewPlayerSuccess


fetchAll : Cmd Msg
fetchAll =
    Http.get collectionDecoder fetchAllUrl
        |> Task.perform FetchAllFail FetchAllDone

save : Player -> Cmd Msg
save player =
    fetchSingle player
        |> Task.perform SaveFail SaveSuccess


delete : Player -> Cmd Msg
delete player =
    deleteSingle player
        |> Task.perform DeleteFail DeleteSuccess

createOnServer : NewPlayer -> Task.Task Http.Error Player
createOnServer newPlayer =
    let
        body =
            newPlayerEncoder newPlayer
                |> Encode.encode 0
                |> Http.string

        config =
            { verb = "POST"
            , headers = [ ( "Content-Type", "application/json" ) ]
            , url = fetchAllUrl
            , body = body
            }
    in
        Http.send Http.defaultSettings config
            |> Http.fromJson memberDecoder


fetchSingle : Player -> Task.Task Http.Error Player
fetchSingle player =
    let
        body =
            memberEncoder player
                |> Encode.encode 0
                |> Http.string

        config =
            { verb = "PATCH"
            , headers = [ ( "Content-Type", "application/json" ) ]
            , url = signlePlayerUrl player.id
            , body = body
            }
    in
        Http.send Http.defaultSettings config
            |> Http.fromJson memberDecoder


deleteSingle : Player -> Task.Task Http.RawError PlayerId
deleteSingle player =
    let
        config =
            { verb = "DELETE"
            , headers = [ ( "Content-Type", "application/json" ) ]
            , url = signlePlayerUrl player.id
            , body = Http.empty
            }
    in
        Http.send Http.defaultSettings config
            |> Task.map (\_ -> player.id)


fetchAllUrl : String
fetchAllUrl =
    "http://localhost:4000/players"


signlePlayerUrl : PlayerId -> String
signlePlayerUrl playerId =
    "http://localhost:4000/players/" ++ (toString playerId)


collectionDecoder : Decode.Decoder Players
collectionDecoder =
    Decode.list memberDecoder

newPlayerEncoder : NewPlayer -> Encode.Value
newPlayerEncoder player =
    let
        list =
            [ ( "name", Encode.string player.name )
            , ( "level", Encode.int player.level )
            ]
    in
        list
            |> Encode.object


memberEncoder : Player -> Encode.Value
memberEncoder player =
    let
        list =
            [ ( "id", Encode.int player.id )
            , ( "name", Encode.string player.name )
            , ( "level", Encode.int player.level )
            ]
    in
        list
            |> Encode.object


memberDecoder : Decode.Decoder Player
memberDecoder =
    Decode.object3 Player
        ("id" := Decode.int)
        ("name" := Decode.string)
        ("level" := Decode.int)
