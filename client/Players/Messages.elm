module Players.Messages exposing (..)

import Http

import Players.Models exposing (PlayerId, Player, Players)

type Msg
  = FetchAllDone Players
  | FetchAllFail Http.Error
  | ChangeLevel PlayerId Int
  | SaveSuccess Player
  | SaveFail Http.Error
  | ShowPlayers
  | ShowPlayer PlayerId
  | DeletePlayer PlayerId
  | DeleteFail Http.RawError 
  | DeleteSuccess PlayerId