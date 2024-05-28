defmodule Todo.Todos do
  @moduledoc """
  The Todos context.
  """

  import Ecto.Query, warn: false
  alias Todo.Repo
  alias Todo.Todos.{TodoList, TodoItem}

  @doc """
  Returns the list of todo_lists.
  """
  def list_todo_lists do
    Repo.all(TodoList)
    |> Repo.preload(:todo_items)
  end

  @doc """
  Gets a single todo_list.

  Returns `nil` if the Todo list does not exist.
  """
  def get_todo_list(id), do: Repo.get(TodoList, id) |> Repo.preload(:todo_items)

  @doc """
  Creates a todo_list.
  """
  def create_todo_list(attrs \\ %{}) do
    items = Map.get(attrs, "todo_items", [])
    changesets = Enum.map(items, &TodoItem.changeset(%TodoItem{}, &1))

    Ecto.Multi.new()
    |> Ecto.Multi.insert(:todo_list, TodoList.changeset(%TodoList{}, attrs))
    |> Ecto.Multi.run(:todo_items, fn repo, %{todo_list: todo_list} ->
      if Enum.all?(changesets, & &1.valid?) do
        items_to_insert =
          Enum.map(changesets, fn changeset ->
            changeset
            |> Ecto.Changeset.put_assoc(:todo_list, todo_list)
            |> Ecto.Changeset.apply_changes()
          end)

        repo.insert_all(TodoItem, items_to_insert)
        {:ok, items_to_insert}
      else
        {:error, changesets}
      end
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{todo_list: todo_list}} ->
        {:ok, Repo.preload(todo_list, :todo_items)}

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        {:error, failed_value}
    end
  end

  @doc """
  Updates a todo_list.
  """
  def update_todo_list(%TodoList{} = todo_list, attrs) do
    todo_list
    |> TodoList.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a todo_list.
  """
  def delete_todo_list(%TodoList{} = todo_list) do
    Repo.delete(todo_list)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking todo_list changes.
  """
  def change_todo_list(%TodoList{} = todo_list, attrs \\ %{}) do
    TodoList.changeset(todo_list, attrs)
  end

  @doc """
  Returns the list of todo_items.
  """
  def list_todo_items(todo_list_id) do
    Repo.all(from t in TodoItem, where: t.todo_list_id == ^todo_list_id)
  end

  @doc """
  Gets a single todo_item.

  Returns `nil` if the Todo item does not exist.
  """
  def get_todo_item(id), do: Repo.get(TodoItem, id)

  @doc """
  Creates a todo_item.
  """
  def create_todo_item(%{"todo_list_id" => todo_list_id, "todo_item" => item}) do
    create_todo_item(todo_list_id, item)
  end

  def create_todo_item(todo_list_id, attrs \\ %{}) do
    case Repo.get(TodoList, todo_list_id) do
      nil ->
        {:error, :not_found}

      %TodoList{} = _todo_list ->
        %TodoItem{todo_list_id: todo_list_id}
        |> TodoItem.changeset(attrs)
        |> Repo.insert()
    end
  end

  @doc """
  Updates a todo_item.
  """
  def update_todo_item(%TodoItem{} = todo_item, attrs) do
    todo_item
    |> TodoItem.changeset(attrs)
    |> Repo.update()
  end

  def update_todo_item(nil, _attrs), do: {:error, :not_found}

  @doc """
  Deletes a todo_item.
  """
  def delete_todo_item(%TodoItem{} = todo_item) do
    Repo.delete(todo_item)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking todo_item changes.
  """
  def change_todo_item(%TodoItem{} = todo_item, attrs \\ %{}) do
    TodoItem.changeset(todo_item, attrs)
  end
end
