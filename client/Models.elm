module Models exposing (..)

import Routing

import Players.Models exposing (Player, Players)

type alias Model 
    = { players : Players
      , route : Routing.Route
      }

initialModel : Routing.Route -> Model
initialModel route =
    { players = []
    , route = route
    }