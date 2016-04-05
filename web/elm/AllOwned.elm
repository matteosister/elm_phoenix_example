module AllOwned where

import Html exposing (..)
import Html.Attributes exposing (class)

view : String -> Html
view buttonText =
  button [ class "success button" ] [ text buttonText ]
