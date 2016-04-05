defmodule ElmList.BookChannel do
  use ElmList.Web, :channel

  alias ElmList.Book

  def join("books:manager", payload, socket) do
    if authorized?(payload) do
      send self, :after_join
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (books:manager).
  def handle_in("shout", payload, socket) do
    broadcast socket, "shout", payload
    {:noreply, socket}
  end

  def handle_in("book_owned", payload, socket) do
    book = Repo.get! Book, payload["id"]
    params = %{owned: !payload["owned"]}
    changeset = Book.changeset(book, params)
    case Repo.update(changeset) do
      {:ok, book} ->
        broadcast socket, "book_updated", render_one(book)
        {:noreply, socket}
      {:error, _changeset} ->
        {:reply, {:error, %{message: "Something went wrong."}}, socket}
    end
  end

  # This is invoked every time a notification is being broadcast
  # to the client. The default implementation is just to push it
  # downstream but one could filter or change the event.
  def handle_out(event, payload, socket) do
    push socket, event, payload
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end

  def handle_info(:after_join, socket) do
    books = (from b in Book) |> Repo.all
    push socket, "set_books", %{books: render_many(books) }
    {:noreply, socket}
  end

  defp render_one(book) do
    ElmList.BookView.render("book.json", %{book: book})
  end

  defp render_many(books) do
    ElmList.BookView.render("index.json", %{books: books})
  end
end
