module Main where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (on, targetValue)
import StartApp.Simple as StartApp
import Clock

update : String -> String -> String
update newValue oldValue =
    newValue

view : Signal.Address String -> String -> Html
view address string =
    div []
        [ div [] [ text string ]
        , input [ type' "range"
                , value string
                , Html.Attributes.min "0"
                , Html.Attributes.max "100"
                , on "change" targetValue (Signal.message address)
                ] []
        , Clock.view "" ""                                                                 
        ]
        

main =
  StartApp.start { model = "50", 
                   view = view,
                   update = update }
