defmodule TodoWeb.TodoItemController do
  use TodoWeb, :controller

  alias TodoWeb.Router.Helpers, as: Routes
  alias Todo.Todos
  alias TodoWeb.TodoItemJSON
  alias Todo.Todos.TodoItem

  action_fallback TodoWeb.FallbackController

  def index(conn, %{"todo_list_id" => todo_list_id}) do
    todo_items = Todos.list_todo_items(todo_list_id)

    conn
    |> put_view(TodoItemJSON)
    |> render("index.json", todo_items: todo_items)
  end

  def create(conn, %{"todo_list_id" => todo_list_id, "todo_item" => todo_item_params}) do
    todo_list_id = String.to_integer(todo_list_id)

    case Todos.create_todo_item(todo_list_id, todo_item_params) do
      {:ok, todo_item} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", Routes.todo_list_path(conn, :show, todo_list_id))
        |> put_view(TodoItemJSON)
        |> render("show.json", todo_item: todo_item)

      {:error, %Ecto.Changeset{} = changeset} ->
        {:error, changeset}

      {:error, :not_found} ->
        {:error, :not_found}
    end
  end

  def show(conn, %{"todo_list_id" => _todo_list_id, "id" => id}) do
    case Todos.get_todo_item(id) do
      nil ->
        {:error, :not_found}

      todo_item ->
        conn
        |> put_view(TodoItemJSON)
        |> render("show.json", todo_item: todo_item)
    end
  end

  def update(conn, %{"todo_list_id" => _todo_list_id, "id" => id, "todo_item" => todo_item_params}) do
    todo_item = Todos.get_todo_item(id)

    case Todos.update_todo_item(todo_item, todo_item_params) do
      {:ok, todo_item} ->
        conn
        |> put_view(TodoItemJSON)
        |> render("show.json", todo_item: todo_item)

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  def delete(conn, %{"todo_list_id" => _todo_list_id, "id" => id}) do
    case Todos.get_todo_item(id) do
      nil ->
        {:error, :not_found}

      todo_item ->
        with {:ok, %TodoItem{}} <- Todos.delete_todo_item(todo_item) do
          send_resp(conn, :no_content, "")
        else
          {:error, changeset} ->
            {:error, changeset}
        end
    end
  end

  def mark_done(conn, %{"todo_list_id" => _todo_list_id, "todo_item_id" => todo_item_id}) do
    todo_item = Todos.get_todo_item(todo_item_id)

    case Todos.update_todo_item(todo_item, %{done: true}) do
      {:ok, todo_item} ->
        conn
        |> put_view(TodoItemJSON)
        |> render("show.json", todo_item: todo_item)

      {:error, changeset} ->
        {:error, changeset}
    end
  end
end
