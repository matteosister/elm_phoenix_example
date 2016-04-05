defmodule ElmList.BookControllerTest do
  use ElmList.ConnCase

  alias ElmList.Book
  @valid_attrs %{pages: 42, title: "some content", owned: false}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, book_path(conn, :index)
    assert json_response(conn, 200) == []
  end

  test "shows chosen resource", %{conn: conn} do
    book = Repo.insert! %Book{}
    conn = get conn, book_path(conn, :show, book)
    assert json_response(conn, 200) == %{"id" => book.id,
      "owned" => book.owned,
      "title" => book.title,
      "pages" => book.pages}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, book_path(conn, :show, "11111111-1111-1111-1111-111111111111")
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, book_path(conn, :create), book: @valid_attrs
    assert json_response(conn, 201)["id"]
    assert Repo.get_by(Book, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, book_path(conn, :create), book: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    book = Repo.insert! %Book{}
    conn = put conn, book_path(conn, :update, book), book: @valid_attrs
    assert json_response(conn, 200)["id"]
    assert Repo.get_by(Book, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    book = Repo.insert! %Book{}
    conn = put conn, book_path(conn, :update, book), book: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    book = Repo.insert! %Book{}
    conn = delete conn, book_path(conn, :delete, book)
    assert response(conn, 204)
    refute Repo.get(Book, book.id)
  end
end
