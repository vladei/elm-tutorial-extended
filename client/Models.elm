module Models exposing (..)

import Routing
import Players.Models exposing (Players, NewPlayer, generateNewPlayer)


type alias Model =
    { players : Players
    , newPlayer : NewPlayer
    , route : Routing.Route
    }


initialModel : Routing.Route -> Model
initialModel route =
    { players = []
    , newPlayer = generateNewPlayer
    , route = route
    }
