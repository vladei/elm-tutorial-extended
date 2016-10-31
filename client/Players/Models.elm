module Players.Models exposing (..)


type alias PlayerId =
    Int


type alias Player =
    { id : PlayerId
    , name : String
    , level : Int
    }


type alias PartialPlayer =
    { name : String
    , level : Int
    }


type alias Players =
    List Player


generateNewPlayer : PartialPlayer
generateNewPlayer =
    { name = ""
    , level = 1
    }
