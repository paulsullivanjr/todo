defmodule Todo.Todos.TodoItem do
  use Ecto.Schema
  import Ecto.Changeset

  schema "todo_items" do
    field :done, :boolean, default: false
    field :description, :string
    belongs_to :todo_list, Todo.Todos.TodoList

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(todo_item, attrs) do
    todo_item
    |> cast(attrs, [:description, :done, :todo_list_id])
    |> validate_required([:description, :done, :todo_list_id])
    |> foreign_key_constraint(:todo_list_id,
      name: :todo_items_todo_list_id_fkey,
      message: "does not exist"
    )
  end
end
