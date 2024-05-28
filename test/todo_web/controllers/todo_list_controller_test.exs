defmodule TodoWeb.TodoListControllerTest do
  use TodoWeb.ConnCase
  alias TodoWeb.Router.Helpers, as: Routes
  alias Todo.Todos
  import Todo.Factory

  @valid_attrs %{title: "Valid title"}
  @invalid_attrs %{title: nil}

  setup do
    :ok
  end

  describe "GET /api/todo_lists/:id" do
    test "returns the todo list when it exists", %{conn: conn} do
      todo_list = insert(:todo_list)

      conn = get(conn, Routes.todo_list_path(conn, :show, todo_list.id))
      assert json_response(conn, 200)["data"]["title"] == todo_list.title
    end

    test "returns 404 when the todo list does not exist", %{conn: conn} do
      conn = get(conn, Routes.todo_list_path(conn, :show, -1))
      assert json_response(conn, 404)["errors"]["detail"] == "Not Found"
    end
  end

  describe "POST /api/todo_lists" do
    test "creates and returns a todo list when data is valid", %{conn: conn} do
      conn = post(conn, Routes.todo_list_path(conn, :create), todo_list: @valid_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]
      assert Todos.get_todo_list(id)
    end

    test "returns errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.todo_list_path(conn, :create), todo_list: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "POST /api/todo_lists/:todo_list_id/todo_items" do
    test "creates a todo item when data is valid", %{conn: conn} do
      todo_list = insert(:todo_list)
      valid_item_attrs = %{description: "Some task", done: false}

      conn =
        post(conn, Routes.todo_list_todo_item_path(conn, :create, todo_list.id),
          todo_item: valid_item_attrs
        )

      assert %{"id" => id} = json_response(conn, 201)["data"]
      assert Todos.get_todo_item(id)
    end

    test "returns 404 when the todo list does not exist", %{conn: conn} do
      valid_item_attrs = %{description: "Some task", done: false}

      conn =
        post(conn, Routes.todo_list_todo_item_path(conn, :create, -1),
          todo_item: valid_item_attrs
        )

      assert json_response(conn, 404)["errors"]["detail"] == "Not Found"
    end
  end
end
