module Book where

import Html exposing (..)
import Html.Attributes exposing (class, classList)
import Html.Events exposing (onClick)


type alias Book =
  { id: ID
  , title: String
  , pages: Int
  , owned: Bool
  }
type alias Model = Book
type alias ID = String


init : Book -> Model
init book = book


-- UPDATE


type Action = Select | Unselect | Toggle


update : Action -> Model -> Model
update action model =
  case action of
    Select ->
      {model | owned = True}
    Unselect ->
      {model | owned = False}
    Toggle ->
      {model | owned = not model.owned}


-- VIEW

view : Signal.Address Action -> Model -> Html
view address model =
  div [class "book"]
    [ title address model
    , pagesNumber model.pages
    , switchOwned address model.owned ]

title : Signal.Address Action -> Model -> Html
title address book =
  h4
    [ class "text-info"
    , classList [ ("text-success", book.owned), ("text-danger", (not book.owned)) ]
    , onClick address Toggle ]
    [ book.title |> text ]

pagesNumber : Int -> Html
pagesNumber pages =
  small [] [ toString pages |> text, text " pages " ]

switchOwned : Signal.Address Action -> Bool -> Html
switchOwned address owned =
  if owned then
    button [ onClick address Unselect ] [ text "I don't have it :(" ]
  else
    button [ onClick address Select ] [ text "I have it!" ]
