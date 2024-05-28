defmodule TodoWeb.TodoItemControllerTest do
  use TodoWeb.ConnCase
  alias TodoWeb.Router.Helpers, as: Routes
  alias Todo.Todos
  import Todo.Factory

  @valid_attrs %{description: "A task to be done", done: false}
  @invalid_attrs %{description: nil, done: nil}

  setup do
    todo_list = insert(:todo_list)
    {:ok, todo_list: todo_list}
  end

  describe "GET /api/todo_lists/:todo_list_id/todo_items/:id" do
    test "returns the todo item when it exists", %{conn: conn, todo_list: todo_list} do
      todo_item = insert(:todo_item, todo_list: todo_list)

      conn = get(conn, Routes.todo_list_todo_item_path(conn, :show, todo_list.id, todo_item.id))
      assert json_response(conn, 200)["data"]["description"] == todo_item.description
    end

    test "returns 404 when the todo item does not exist", %{conn: conn, todo_list: todo_list} do
      conn = get(conn, Routes.todo_list_todo_item_path(conn, :show, todo_list.id, -1))
      assert json_response(conn, 404)["errors"]["detail"] == "Not Found"
    end
  end

  describe "POST /api/todo_lists/:todo_list_id/todo_items" do
    test "creates a todo item when data is valid", %{conn: conn, todo_list: todo_list} do
      conn =
        post(conn, Routes.todo_list_todo_item_path(conn, :create, todo_list.id),
          todo_item: @valid_attrs
        )

      assert %{"id" => id} = json_response(conn, 201)["data"]
      assert Todos.get_todo_item(id)
    end

    test "returns errors when data is invalid", %{conn: conn, todo_list: todo_list} do
      conn =
        post(conn, Routes.todo_list_todo_item_path(conn, :create, todo_list.id),
          todo_item: @invalid_attrs
        )

      assert json_response(conn, 422)["errors"] != %{}
    end

    test "returns 404 when the todo list does not exist", %{conn: conn} do
      conn =
        post(conn, Routes.todo_list_todo_item_path(conn, :create, -1), todo_item: @valid_attrs)

      assert json_response(conn, 404)["errors"]["detail"] == "Not Found"
    end
  end

  describe "PUT /api/todo_lists/:todo_list_id/todo_items/:id" do
    test "updates a todo item when data is valid", %{conn: conn, todo_list: todo_list} do
      todo_item = insert(:todo_item, todo_list: todo_list)
      update_attrs = %{description: "Updated task", done: true}

      conn =
        put(conn, Routes.todo_list_todo_item_path(conn, :update, todo_list.id, todo_item.id),
          todo_item: update_attrs
        )

      assert %{"id" => id} = json_response(conn, 200)["data"]
      assert Todos.get_todo_item(id).description == "Updated task"
    end

    test "returns errors when data is invalid", %{conn: conn, todo_list: todo_list} do
      todo_item = insert(:todo_item, todo_list: todo_list)

      conn =
        put(conn, Routes.todo_list_todo_item_path(conn, :update, todo_list.id, todo_item.id),
          todo_item: @invalid_attrs
        )

      assert json_response(conn, 422)["errors"] != %{}
    end

    test "returns 404 when the todo item does not exist", %{conn: conn, todo_list: todo_list} do
      conn =
        put(conn, Routes.todo_list_todo_item_path(conn, :update, todo_list.id, -1),
          todo_item: @valid_attrs
        )

      assert json_response(conn, 404)["errors"]["detail"] == "Not Found"
    end
  end

  describe "DELETE /api/todo_lists/:todo_list_id/todo_items/:id" do
    test "deletes a todo item", %{conn: conn, todo_list: todo_list} do
      todo_item = insert(:todo_item, todo_list: todo_list)

      conn =
        delete(conn, Routes.todo_list_todo_item_path(conn, :delete, todo_list.id, todo_item.id))

      assert response(conn, 204)
      assert is_nil(Todos.get_todo_item(todo_item.id))
    end

    test "returns 404 when the todo item does not exist", %{conn: conn, todo_list: todo_list} do
      conn = delete(conn, Routes.todo_list_todo_item_path(conn, :delete, todo_list.id, -1))
      assert json_response(conn, 404)["errors"]["detail"] == "Not Found"
    end
  end

  describe "PUT /api/todo_lists/:todo_list_id/todo_items/:id/done" do
    test "marks a todo item as done", %{conn: conn, todo_list: todo_list} do
      todo_item = insert(:todo_item, todo_list: todo_list)

      conn =
        put(
          conn,
          Routes.todo_list_todo_item_mark_done_path(conn, :mark_done, todo_list.id, todo_item.id)
        )

      assert %{"id" => id} = json_response(conn, 200)["data"]
      assert Todos.get_todo_item(id).done == true
    end

    test "returns 404 when the todo item does not exist", %{conn: conn, todo_list: todo_list} do
      conn =
        put(conn, Routes.todo_list_todo_item_mark_done_path(conn, :mark_done, todo_list.id, -1))

      assert json_response(conn, 404)["errors"]["detail"] == "Not Found"
    end
  end
end
