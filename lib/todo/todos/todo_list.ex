defmodule Todo.Todos.TodoList do
  use Ecto.Schema
  import Ecto.Changeset

  schema "todo_lists" do
    field :title, :string
    has_many :todo_items, Todo.Todos.TodoItem

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(todo_list, attrs) do
    todo_list
    |> cast(attrs, [:title])
    |> validate_required([:title])
    |> validate_length(:title, min: 1, max: 255)
  end
end
