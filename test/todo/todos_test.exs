defmodule Todo.TodosTest do
  use Todo.DataCase

  alias Todo.Todos

  describe "todo_lists" do
    alias Todo.Todos.TodoList

    import Todo.TodosFixtures

    @invalid_attrs %{title: nil}

    setup do
      {:ok, todo_list: todo_list_fixture()}
    end

    test "list_todo_lists/0 returns all todo_lists", %{todo_list: todo_list} do
      assert Todos.list_todo_lists() |> Enum.map(&Repo.preload(&1, :todo_items)) == [
               Repo.preload(todo_list, :todo_items)
             ]
    end

    test "get_todo_list/1 returns the todo_list with given id", %{todo_list: todo_list} do
      assert Todos.get_todo_list(todo_list.id) |> Repo.preload(:todo_items) ==
               Repo.preload(todo_list, :todo_items)
    end

    test "create_todo_list/1 with valid data creates a todo_list" do
      valid_attrs = %{title: "some title"}

      assert {:ok, %TodoList{} = todo_list} = Todos.create_todo_list(valid_attrs)
      assert todo_list.title == "some title"
    end

    test "create_todo_list/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Todos.create_todo_list(@invalid_attrs)
    end

    test "update_todo_list/2 with valid data updates the todo_list", %{todo_list: todo_list} do
      update_attrs = %{title: "some updated title"}

      assert {:ok, %TodoList{} = updated_todo_list} =
               Todos.update_todo_list(todo_list, update_attrs)

      assert updated_todo_list.title == "some updated title"
    end

    test "update_todo_list/2 with invalid data returns error changeset", %{todo_list: todo_list} do
      assert {:error, %Ecto.Changeset{}} = Todos.update_todo_list(todo_list, @invalid_attrs)
      reloaded_todo_list = Todos.get_todo_list(todo_list.id) |> Repo.preload(:todo_items)
      assert reloaded_todo_list == Repo.preload(todo_list, :todo_items)
    end

    test "delete_todo_list/1 deletes the todo_list", %{todo_list: todo_list} do
      assert {:ok, %TodoList{}} = Todos.delete_todo_list(todo_list)
      assert Todos.get_todo_list(todo_list.id) |> is_nil()
    end

    test "change_todo_list/1 returns a todo_list changeset", %{todo_list: todo_list} do
      assert %Ecto.Changeset{} = Todos.change_todo_list(todo_list)
    end
  end

  describe "todo_items" do
    alias Todo.Todos.TodoItem

    import Todo.TodosFixtures

    @invalid_attrs %{"done" => nil, "description" => nil}

    setup do
      todo_list = todo_list_fixture()
      {:ok, todo_list: todo_list}
    end

    test "lists all items for a given todo list", %{todo_list: todo_list} do
      {:ok, todo_item1} =
        Todos.create_todo_item(todo_list.id, %{"description" => "item 1", "done" => false})

      {:ok, todo_item2} =
        Todos.create_todo_item(todo_list.id, %{"description" => "item 2", "done" => false})

      assert Todos.list_todo_items(todo_list.id) == [todo_item1, todo_item2]
    end

    test "returns empty list when no items exist", %{todo_list: todo_list} do
      assert Todos.list_todo_items(todo_list.id) == []
    end

    test "get_todo_item/1 returns the todo_item with given id" do
      todo_item = todo_item_fixture()
      assert Todos.get_todo_item(todo_item.id) == todo_item
    end

    test "create_todo_item/1 with valid data creates a todo_item", %{todo_list: todo_list} do
      valid_attrs = %{"done" => true, "description" => "some description"}

      assert {:ok, %TodoItem{} = todo_item} = Todos.create_todo_item(todo_list.id, valid_attrs)
      assert todo_item.done == true
      assert todo_item.description == "some description"
    end

    test "create_todo_item/1 with invalid data returns error changeset", %{todo_list: todo_list} do
      assert {:error, %Ecto.Changeset{}} = Todos.create_todo_item(todo_list.id, @invalid_attrs)
    end

    test "update_todo_item/2 with valid data updates the todo_item" do
      todo_item = todo_item_fixture()
      update_attrs = %{"done" => false, "description" => "some updated description"}

      assert {:ok, %TodoItem{} = updated_todo_item} =
               Todos.update_todo_item(todo_item, update_attrs)

      assert updated_todo_item.done == false
      assert updated_todo_item.description == "some updated description"
    end

    test "update_todo_item/2 with invalid data returns error changeset" do
      todo_item = todo_item_fixture()
      assert {:error, %Ecto.Changeset{}} = Todos.update_todo_item(todo_item, @invalid_attrs)
      assert todo_item == Todos.get_todo_item(todo_item.id)
    end

    test "delete_todo_item/1 deletes the todo_item" do
      todo_item = todo_item_fixture()
      assert {:ok, %TodoItem{}} = Todos.delete_todo_item(todo_item)
      assert Todos.get_todo_item(todo_item.id) |> is_nil()
    end

    test "change_todo_item/1 returns a todo_item changeset" do
      todo_item = todo_item_fixture()
      assert %Ecto.Changeset{} = Todos.change_todo_item(todo_item)
    end
  end
end
