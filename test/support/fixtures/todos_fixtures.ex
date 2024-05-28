defmodule Todo.TodosFixtures do
  alias Todo.Todos

  @doc """
  Generate a todo list.
  """
  def todo_list_fixture(attrs \\ %{}) do
    {:ok, todo_list} =
      attrs
      |> Enum.into(%{title: "some title"})
      |> Todos.create_todo_list()

    todo_list
  end

  @doc """
  Generate a todo item.
  """

  def todo_item_fixture(attrs \\ %{}) do
    todo_list = todo_list_fixture()

    default_attrs = %{
      "description" => "some description",
      "done" => false
    }

    combined_attrs = Enum.into(attrs, default_attrs)

    {:ok, todo_item} = Todos.create_todo_item(todo_list.id, combined_attrs)

    todo_item
  end
end
