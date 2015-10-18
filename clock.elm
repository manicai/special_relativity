module Clock where 

import Html exposing (div,h1,text)
import Html.Attributes
import Svg exposing (circle,line,svg)
import Svg.Attributes exposing (..)
import String

view address model =
    let
        radius = 50
        centre = radius + 1
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
        div [ Html.Attributes.style blockStyle ]
            [ h1 [ Html.Attributes.style titleStyle] 
                 [ Html.text "Earth Time" ]
            , svg [viewBox viewBoxSpec]
              [ circle [ cx (toString centre)
                       , cy (toString centre)
                       , r  (toString radius)
                       , Html.Attributes.style drawingStyle
                       ] []
              , line [ x1 (toString centre)
                     , y1 (toString centre)
                     , x2 (toString centre)
                     , y2 (toString (centre - radius))
                     , transform rotation
                     , Html.Attributes.style drawingStyle
                     ] []
              ]
            ]              

blockStyle =
    [ ("width", "200px")
    , ("height", "200px")
    ]

titleStyle = 
    [ ("font-family", "monospace")
    , ("font-variant", "small-caps")
    , ("text-align", "center")
    ]

drawingStyle : List (String, String)
drawingStyle = 
    [ ("stroke", "orange") 
    , ("stroke-width", "1")
    , ("fill", "black")
    ]