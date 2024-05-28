defmodule Todo.Repo.Migrations.CreateTodoLists do
  use Ecto.Migration

  def change do
    create table(:todo_lists) do
      add :title, :string

      timestamps(type: :utc_datetime)
    end
  end
end
