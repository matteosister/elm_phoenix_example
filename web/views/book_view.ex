defmodule ElmList.BookView do
  use ElmList.Web, :view

  def render("index.json", %{books: books}) do
    render_many(books, ElmList.BookView, "book.json")
  end

  def render("show.json", %{book: book}) do
    render_one(book, ElmList.BookView, "book.json")
  end

  def render("book.json", %{book: book}) do
    %{id: book.id,
      title: book.title,
      pages: book.pages,
      owned: book.owned}
  end
end
