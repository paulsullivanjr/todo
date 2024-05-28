defmodule TodoWeb.TodoListJSON do
  alias Todo.Todos.{TodoList, TodoItem}

  def render("show.json", %{todo_list: todo_list}) do
    %{
      data: render_todo_list(todo_list)
    }
  end

  def render("index.json", %{todo_lists: todo_lists}) do
    %{
      data: Enum.map(todo_lists, &render_todo_list/1)
    }
  end

  def render("show.json", %{todo_item: todo_item}) do
    %{
      data: render_todo_item(todo_item)
    }
  end

  defp render_todo_list(%TodoList{
         id: id,
         title: title,
         inserted_at: inserted_at,
         updated_at: updated_at,
         todo_items: todo_items
       }) do
    %{
      "id" => id,
      "title" => title,
      "inserted_at" => inserted_at,
      "updated_at" => updated_at,
      "todo_items" => Enum.map(todo_items, &render_todo_item/1)
    }
  end

  defp render_todo_item(%TodoItem{
         id: id,
         description: description,
         done: done,
         inserted_at: inserted_at,
         updated_at: updated_at
       }) do
    %{
      "id" => id,
      "description" => description,
      "done" => done,
      "inserted_at" => inserted_at,
      "updated_at" => updated_at
    }
  end
end
