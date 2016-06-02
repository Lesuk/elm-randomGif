module Styles exposing (..)

import Html exposing (Attribute)
import Html.Attributes exposing (..)


type alias Colors =
  { offBlack : String
  , offWhite : String
  }


colors : Colors
colors =
  { offBlack = "#333"
  , offWhite = "#F5F5F5"
  }


buttonBackground : String -> String
buttonBackground actionName =
  case actionName of
    "Start" ->
      colors.offBlack

    _ ->
      ""


actionButton : String -> Attribute a
actionButton actionName =
  style
    [ ( "flex-grow", "1" )
    , ( "min-width", "50%" )
    , ( "font-size", "1.2rem" )
    , ( "border", "none" )
    , ( "outline", "none" )
    , ( "padding", "0.4rem" )
    , ( "background", (buttonBackground actionName) )
    ]


buttonRow : Attribute a
buttonRow =
  style
    [ ( "display", "flex" )
    , ( "flex-direction", "row" )
    ]


header : Attribute a
header =
  style
    [ ( "text-transform", "uppercase" )
    , ( "background", colors.offBlack )
    , ( "padding", "0.5em 1rem" )
    , ( "font-size", "1.2rem" )
    , ( "color", "#f5f5f5" )
    , ( "letter-spacing", "0.4rem" )
    , ( "text-align", "center" )
    ]
