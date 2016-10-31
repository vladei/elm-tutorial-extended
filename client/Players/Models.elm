module Players.Models exposing (..)


type alias PlayerId =
    Int


type alias Player =
    { id : PlayerId
    , name : String
    , level : Int
    }


type alias NewPlayer =
    { name : String
    , level : Int
    }


type alias Players =
    List Player


generateNewPlayer : NewPlayer
generateNewPlayer =
    { name = ""
    , level = 1
    }
