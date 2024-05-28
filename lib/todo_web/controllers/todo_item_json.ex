defmodule TodoWeb.TodoItemJSON do
  alias Todo.Todos.TodoItem

  def render("index.json", %{todo_items: todo_items}) do
    %{data: render_todo_items(todo_items)}
  end

  def render("show.json", %{todo_item: todo_item}) do
    %{data: render_todo_item(todo_item)}
  end

  defp render_todo_item(%TodoItem{} = todo_item) do
    %{
      id: todo_item.id,
      description: todo_item.description,
      done: todo_item.done,
      todo_list_id: todo_item.todo_list_id,
      inserted_at: todo_item.inserted_at,
      updated_at: todo_item.updated_at
    }
  end

  defp render_todo_items(todo_items) when is_list(todo_items) do
    Enum.map(todo_items, &render_todo_item/1)
  end
end
