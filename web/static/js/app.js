// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

import socket from "./socket"

const elmDiv = document.getElementById('elm-main')
const initialState = {bookLists: [], bookUpdates: {id: "", title: "", pages: 0, owned: false}}
const elmApp = Elm.embed(Elm.ApiList, elmDiv, initialState)

let channel = socket.channel("books:manager", {})
channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })

channel.on("set_books", data => {
  console.log("got books!", data.books)
  elmApp.ports.bookLists.send(data.books)
})
channel.on("book_updated", book => {
  elmApp.ports.bookUpdates.send(book)
})

elmApp.ports.bookOwnedRequest.subscribe(book => {
  console.log(book)
  channel.push("book_owned", book)
})
