module Main where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (on, targetValue)
import Clock
import String exposing (toFloat)
import Time
import Task exposing (Task)

type alias Model =
    { speed : Float
    , ship_time : Float
    , earth_time : Float
    }

init : Float -> Model
init s =
    { speed = s
    , ship_time = 0
    , earth_time = 0
    }

-- UPDATE

type Action
    = Reset
    | Tick
    | SetSpeed String

frame_rate = 20

actions = Signal.mailbox Tick

update : Action -> Model -> Model
update action model =
    case action of
        Reset ->
            { model | ship_time = 0, earth_time = 0 }
        Tick ->
            { model | ship_time = model.ship_time + model.speed / frame_rate
                    , earth_time = model.earth_time + 1 / frame_rate }
        SetSpeed sliderValue ->
            case String.toFloat sliderValue of
                Ok value -> { model | speed = value }
                Err msg -> { model | speed = 0 }


view : Signal.Address Action -> Model -> Html
view address model =
    div []
        [ Clock.view model.ship_time "Ship Time"
        , div [Html.Attributes.style [ ("display", "inline-block") ]]
              [ div [] [ text (toString model.speed) ]
              , input [ type' "range"
                      , value (toString model.speed)
                      , Html.Attributes.min "0"
                      , Html.Attributes.max "100"
                      , on "change" targetValue (\x -> Signal.message address (SetSpeed x))
                      ] []
              ]
        , Clock.view model.earth_time "Earth Time"
        ]

port tick : Signal (Task x ())
port tick = Signal.map (\t -> Signal.send actions.address Tick) (Time.fps frame_rate)

main =
    Signal.map (view actions.address) <| Signal.foldp update (init 50.0) actions.signal
