module AList where

import StartApp
import Html exposing (..)
import Html.Attributes exposing (class)
import Effects exposing (Effects)
import Title exposing (view)
import Book exposing (..)


app = StartApp.start
  { init = init
  , update = update
  , view = view
  , inputs = [bookListReceived]
  }


main : Signal Html
main = app.html

-- MODEL


type alias Model =
  List Book.Book


type Action
  = BooksReceived Model
  | Updated Book Book.Action


init : (Model, Effects Action)
init =
  ([], Effects.none)

-- UPDATE


update : Action -> Model -> (Model, Effects Action)
update action model =
  case action of
    BooksReceived books ->
      (books, Effects.none)
    Updated book action ->
      let updateBook bookFromModel =
        if bookFromModel.id == book.id then
          Book.update action book
        else
          bookFromModel
      in
        (List.map updateBook model, Effects.none)

-- VIEW


view : Signal.Address Action -> Model -> Html
view address model =
  div
    [ class "container"]
    [ Title.view
    , bookList address model ]


bookList : Signal.Address Action -> Model -> Html
bookList address books =
  let
    bookView book =
      Book.view (Signal.forwardTo address (Updated book)) book
  in
    div [] (List.map bookView books)


-- SIGNALS


port bookLists : Signal Model

bookListReceived: Signal Action
bookListReceived =
  Signal.map BooksReceived bookLists
