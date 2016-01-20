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

type Action
    = Reset
    | Tick
    | SetSpeed String

frame_rate = 1

port tick : Signal (Task x ())
port tick = Signal.map (\t -> Signal.send actions.address Tick)
                       (Time.fps frame_rate)

actions = Signal.mailbox Tick

update : Action -> Model -> Model
update action model =
    case action of
        Reset ->
            { model | ship_time = 0, earth_time = 0 }
        Tick ->
            { model | ship_time = model.ship_time
                                + (lorentz <| scale_speed model.speed) / frame_rate
                    , earth_time = model.earth_time + 1 / frame_rate }
        SetSpeed sliderValue ->
            case String.toFloat sliderValue of
                Ok value -> { model | speed = value }
                Err msg -> { model | speed = 0 }

scale_speed in_value = in_value / 100.0

lorentz v = sqrt(1 - v * v)

star_distance  = 4.367 -- light years

years_to_star v = star_distance / v

-- Because apparently Elm doesn't have a text formatting system built in
-- and it's not worth an external dependency just to round to two
-- decimal places.
to_2dp number =
  let
    text_value = toString number
    indices = String.indices "." text_value
  in
    case List.head indices of
      Just value -> String.slice 0 (value + 3) text_value
      Nothing -> text_value

view : Signal.Address Action -> Model -> Html
view address model =
    div [ Html.Attributes.style global_style ]
        [ Clock.view model.ship_time "Ship Time"
        , div [Html.Attributes.style [ ("display", "inline-block")
                                     , ("vertical-align", "top")
                                     , ("margin", "40px")
                                     , ("text-align", "center") ]]
              [ div [Html.Attributes.style speed_value_style]
                    [ text <| "Speed "
                           ++ (toString <| scale_speed model.speed)
                           ++ "c" ]
              , input [ type' "range"
                      , value (toString model.speed)
                      , Html.Attributes.min "0"
                      , Html.Attributes.max "100"
                      , on "change" targetValue
                           (\x -> Signal.message address (SetSpeed x))
                      , Html.Attributes.style speed_slider_style
                      ] []
              , input [ type' "button"
                      , value "Reset"
                      , on "click" targetValue
                           (\x -> Signal.message address Reset)
                      , Html.Attributes.style reset_button_style
                      ] []
              , div [ Html.Attributes.style speed_value_style ]
                    [ text "Distance to Alpha Centauri" ]
              , div [ Html.Attributes.style speed_value_style ]
                    [ text "25,672,000,000,000 miles" ]
              , div [ Html.Attributes.style speed_value_style ]
                    [ text "Time to Alpha Centauri" ]
              , div [ Html.Attributes.style speed_value_style ]
                    [ text <| (to_2dp <| years_to_star <| scale_speed model.speed)
                           ++ " years"]
              ]
        , Clock.view model.earth_time "Earth Time"
        ]

global_style = [ ("font-family", "monospace")
               , ("font-variant", "small-caps")
               , ("color", "orange")
               , ("background", "black")
               , ("padding", "30px")
               ]
reset_button_style = [ ("display", "block")
                     , ("color", "white")
                     , ("background", "black")
                     , ("border", "1px solid orange")
                     , ("text-align", "center")
                     , ("margin", "30px auto")
                     , ("width", "100px")
                     , ("height", "40px")
                     , ("font-family", "monospace")
                     , ("font-variant", "small-caps")
                     , ("font-size", "140%")
                     ]
speed_value_style  = [ ("font-size", "140%")
                     , ("margin-top", "1ex")
                     ]
speed_slider_style = [ ("margin-top", "30px")

                     ]

main =
    Signal.map (view actions.address)
            <| Signal.foldp update (init 50.0) actions.signal
