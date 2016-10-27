module Players.Commands exposing (..)

import Http
import Json.Encode as Encode
import Json.Decode as Decode exposing ((:=))
import Task exposing (..)
import Players.Models exposing (PlayerId, Player, Players)
import Players.Messages exposing (..)


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
