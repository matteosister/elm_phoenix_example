module ApiList where

import StartApp
import Effects exposing (Effects, Never)
import Task exposing (Task)
import Html exposing (..)
import Html.Attributes exposing (class, type', id, for, checked)
import Html.Events exposing (onClick)
import Http
import Json.Decode as Json exposing ((:=))

app = StartApp.start
  { init = init
  , update = update
  , view = view
  , inputs = [incomingActions]
  }

main : Signal Html
main = app.html

port tasks : Signal (Task Never ())
port tasks =
  app.tasks


-- MODEL
init : (Model, Effects Action)
init =
  ([], Effects.none)


type alias Book =
  { id: ID
  , title: String
  , pages: Int
  , owned: Bool
  }

type alias ID = String

type alias Model =
  List Book


-- UPDATE
type Action = SetBooks Model | NoOp | OwnedBook Book | UpdateBook Book


update : Action -> Model -> (Model, Effects Action)
update action model =
  case action of
    SetBooks books ->
      (books, Effects.none)
    OwnedBook book ->
      (model, sendBookOwned book)
    UpdateBook book ->
      let
        updateBook bookFromModel =
          if book.id == bookFromModel.id then
            book
          else bookFromModel
      in
        (List.map updateBook model, Effects.none)
    NoOp ->
      (model, Effects.none)

-- VIEW
view : Signal.Address Action -> Model -> Html
view address model =
  div [ class "books" ] (List.map (bookItem address) model)

bookItem : Signal.Address Action -> Book -> Html
bookItem address book =
  let
    ownedClass =
      if book.owned then "owned" else "not-owned"
  in
    div
      [ class ("book row " ++ ownedClass) ]
      [ div
        [ class "column large-1" ]
        [ (bookSwitch address book) ]
      , div
        [ class "column large-11" ]
        [ text (book.title), " (" ++ toString book.pages ++ " pages)" |> text ]
      ]

bookSwitch : Signal.Address Action -> Book -> Html
bookSwitch address book =
  div [ class "switch" ]
    [ input
      [ class "switch-input"
      , type' "checkbox"
      , id ("book" ++ book.id)
      , onClick address (OwnedBook book)
      , checked book.owned
      ]
      []
    , label
      [ class "switch-paddle"
      , for ("book" ++ book.id)
      ]
      []
    ]

-- SIGNALS
port bookLists : Signal Model

bookListsToSet: Signal Action
bookListsToSet =
  Signal.map SetBooks bookLists

port bookUpdates : Signal Book

bookToUpdate : Signal Action
bookToUpdate =
  Signal.map UpdateBook bookUpdates

incomingActions : Signal Action
incomingActions =
  Signal.merge bookListsToSet bookToUpdate


port bookOwnedRequest : Signal Book
port bookOwnedRequest =
  bookOwnedBox.signal

bookOwnedBox : Signal.Mailbox Book
bookOwnedBox =
  Signal.mailbox (Book "" "" 0 False)


-- EFFECTS
sendBookOwned : Book -> Effects Action
sendBookOwned book =
  Signal.send bookOwnedBox.address book
  |> Effects.task
  |> Effects.map (always NoOp)
