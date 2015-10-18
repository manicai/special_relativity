module Clock where 

import Html exposing (div,h1,text)
import Svg exposing (circle,line,svg)
import Svg.Attributes exposing (..)
import String

view address model =
    let
        radius = 50
        centre = radius + 1
        strokeColour = "orange"
        angle = 213
        rotation = String.concat [ "rotate("
                                 , String.join ","
                                              [ toString angle
                                              , toString centre
                                              , toString centre
                                              ]
                                 ,")"]
        viewBoxSpec = String.join " " [ "0"
                                      , "0"
                                      , toString (2 * centre)
                                      , toString (2 * centre)]
    in
        div [ style "width: 200px; height 200px;" ]
            [ h1 [ style "font-family: monospace;"] 
                 [ Html.text "Earth Time" ]
            , svg [viewBox viewBoxSpec]
              [ circle [ cx (toString centre)
                       , cy (toString centre)
                       , r  (toString radius)
                       , fill "black"
                       , stroke strokeColour
                       , strokeWidth "1"
                       ] []
              , line [ x1 (toString centre)
                     , y1 (toString centre)
                     , x2 (toString centre)
                     , y2 (toString (centre - radius))
                     , Svg.Attributes.transform rotation
                     , fill "black"
                     , stroke strokeColour
                     , strokeWidth "1"
                     ] []
              ]
            ]              
