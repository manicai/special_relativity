module Clock where 

import Html exposing (div,h1,text)
import Svg exposing (circle, line, svg)
import Svg.Attributes exposing (..)

view address model =
    div [clockStyle]
        [ h1 [] [text "Earth Time"]
        , svg [viewBox "0 0 102 102"]
          [ circle [ cx  "51"
                   , cy  "51"
                   , r "50"
                   , drawingStyle
                   ] []
          , line [ x1 "51"
                 , y1 "51"
                 , x2 "51"
                 , y2 "0"
                 , Svg.Attributes.transform "rotate 51 51 90"
                 , drawingStyle
                 ] []
          ]
        ]


clockStyle : Svg.Attribute
clockStyle =
    Svg.Attributes.style 
        [ ("width", "200px")
        , ("height", "200px") 
        ]

drawingStyle : Svg.Attribute
drawingStyle = 
    Svg.Attributes.style 
        [ ("stroke", "orange")
        , ("stroke-width", "1")
        , ("fill", "black")
        ]  
