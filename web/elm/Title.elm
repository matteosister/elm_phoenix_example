module Title where

import Html exposing (..)
import Html.Attributes exposing (class)

view : Html
view =
  div [class "page-header"]
    [ h1 [] [ text "Book list", small [] [ text " an elm library" ] ]
    ]
