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

frame_rate = 5

actions = Signal.mailbox Tick

update : Action -> Model -> Model
update action model =
    case action of
        Reset ->
            { model | ship_time = 0, earth_time = 0 }
        Tick ->
            { model | ship_time = model.ship_time + (scale_speed model.speed) / frame_rate
                    , earth_time = model.earth_time + 1 / frame_rate }
        SetSpeed sliderValue ->
            case String.toFloat sliderValue of
                Ok value -> { model | speed = value }
                Err msg -> { model | speed = 0 }

scale_speed in_value =
    in_value / 100.0

view : Signal.Address Action -> Model -> Html
view address model =
    div []
        [ Clock.view model.ship_time "Ship Time"
        , div [Html.Attributes.style [ ("display", "inline-block") ]]
              [ div [Html.Attributes.style speed_value_style]
                    [ text (String.concat [(toString (scale_speed model.speed)), "c"]) ]
              , input [ type' "range"
                      , value (toString model.speed)
                      , Html.Attributes.min "0"
                      , Html.Attributes.max "100"
                      , on "change" targetValue (\x -> Signal.message address (SetSpeed x))
                      , Html.Attributes.style speed_slider_style
                      ] []
              , input [ type' "button"
                      , value "Reset"
                      , on "click" targetValue (\x -> Signal.message address Reset)
                      , Html.Attributes.style reset_button_style
                      ] []
              ]
        , Clock.view model.earth_time "Earth Time"
        ]

reset_button_style = [("display", "block"),
                      ("color", "white"),
                      ("background", "black"),
                      ("border", "1px solid orange"),
                      ("text-align", "center"),
                      ("margin", "auto"),
                      ("width", "100px"),
                      ("height", "40px")]
speed_value_style  = [("text-align", "center")]
speed_slider_style = []

port tick : Signal (Task x ())
port tick = Signal.map (\t -> Signal.send actions.address Tick) (Time.fps frame_rate)

main =
    Signal.map (view actions.address) <| Signal.foldp update (init 50.0) actions.signal
