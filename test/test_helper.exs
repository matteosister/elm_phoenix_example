ExUnit.start

Mix.Task.run "ecto.create", ~w(-r ElmList.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r ElmList.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(ElmList.Repo)
