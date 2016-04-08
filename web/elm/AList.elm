module AList where

import StartApp
import Html exposing (..)
import Html.Attributes exposing (class)
import Effects exposing (Effects, Never)
import Title exposing (view)
import Book exposing (..)
import Task exposing (Task)


app = StartApp.start
  { init = init
  , update = update
  , view = view
  , inputs = [bookListReceived, bookUpdateReceived]
  }


main : Signal Html
main = app.html


port tasks : Signal (Task Never ())
port tasks =
  app.tasks

-- MODEL


type alias Model =
  List Book.Book


type Action
  = BooksReceived Model
  | Updated Book Book.Action
  | NoOp
  | BookUpdated Book


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
      (model, remoteUpdateBook (Book.update action book))
    BookUpdated book ->
      let updateBook bookFromModel =
        if bookFromModel.id == book.id then
          book
        else bookFromModel
      in
        (List.map updateBook model, Effects.none)
    NoOp ->
      (model, Effects.none)

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



port bookUpdated : Signal Book


bookUpdateReceived: Signal Action
bookUpdateReceived =
  Signal.map BookUpdated bookUpdated


-- EFFECTS


port bookRequest : Signal Book
port bookRequest =
  bookBox.signal


bookBox : Signal.Mailbox Book
bookBox =
  Signal.mailbox (Book "" "" 0 False)


remoteUpdateBook : Book -> Effects Action
remoteUpdateBook book =
  Signal.send bookBox.address book
  |> Effects.task
  |> Effects.map (always NoOp)
