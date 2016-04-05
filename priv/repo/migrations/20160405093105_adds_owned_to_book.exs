defmodule ElmList.Repo.Migrations.AddsOwnedToBook do
  use Ecto.Migration

  def change do
    alter table(:books) do
      add :owned, :boolean
    end
  end
end
