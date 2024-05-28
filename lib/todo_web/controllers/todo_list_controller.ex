defmodule TodoWeb.TodoListController do
  use TodoWeb, :controller

  alias TodoWeb.Router.Helpers, as: Routes
  alias Todo.Todos
  alias Todo.Todos.TodoList
  alias TodoWeb.TodoListJSON

  action_fallback TodoWeb.FallbackController

  def index(conn, _params) do
    todo_lists = Todos.list_todo_lists()

    conn
    |> put_view(TodoListJSON)
    |> render("index.json", todo_lists: todo_lists)
  end

  def create(conn, %{"todo_list" => todo_list_params}) do
    case Todos.create_todo_list(todo_list_params) do
      {:ok, todo_list} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", Routes.todo_list_path(conn, :show, todo_list))
        |> put_view(TodoListJSON)
        |> render("show.json", todo_list: todo_list)

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  def show(conn, %{"id" => id}) do
    case Todos.get_todo_list(id) do
      nil ->
        {:error, :not_found}

      todo_list ->
        conn
        |> put_view(TodoListJSON)
        |> render("show.json", todo_list: todo_list)
    end
  end

  def update(conn, %{"id" => id, "todo_list" => todo_list_params}) do
    todo_list = Todos.get_todo_list(id)

    case Todos.update_todo_list(todo_list, todo_list_params) do
      {:ok, todo_list} ->
        conn
        |> put_view(TodoListJSON)
        |> render("show.json", todo_list: Todos.get_todo_list(todo_list.id))

      error ->
        error
    end
  end

  def delete(conn, %{"id" => id}) do
    todo_list = Todos.get_todo_list(id)

    with {:ok, %TodoList{}} <- Todos.delete_todo_list(todo_list) do
      send_resp(conn, :no_content, "")
    end
  end
end
