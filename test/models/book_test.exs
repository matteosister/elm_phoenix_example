defmodule ElmList.BookTest do
  use ElmList.ModelCase

  alias ElmList.Book

  @valid_attrs %{pages: 42, title: "some content", owned: false}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Book.changeset(%Book{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Book.changeset(%Book{}, @invalid_attrs)
    refute changeset.valid?
  end
end
