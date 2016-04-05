# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     ElmList.Repo.insert!(%ElmList.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

defmodule Seeds do
  def random_number do
    90..400
    |> Enum.shuffle
    |> hd
  end

  def random_book do
    %ElmList.Book{
      title: Faker.Lorem.sentence(4..6),
      pages: Seeds.random_number,
      owned: hd(Enum.shuffle([true, false]))
    }
  end

  def random_books(num) do
    for _ <- 1..num do
      random_book
    end
  end
end

ElmList.Repo.delete_all(ElmList.Book)

10
|> Seeds.random_books
|> Enum.map(&(ElmList.Repo.insert!(&1)))
