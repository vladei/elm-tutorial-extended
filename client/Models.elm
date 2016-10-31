module Models exposing (..)

import Routing
import Players.Models exposing (Players, Player, PartialPlayer, generateNewPlayer)


type alias Model =
    { players : Players
    , newPlayer : PartialPlayer
    , route : Routing.Route
    , editing : Bool
    }


initialModel : Routing.Route -> Model
initialModel route =
    { players = []
    , newPlayer = generateNewPlayer
    , route = route
    , editing = False
    }
