defmodule Todo.Factory do
  use ExMachina.Ecto, repo: Todo.Repo

  def todo_list_factory do
    %Todo.Todos.TodoList{
      title: Faker.Lorem.sentence()
    }
  end

  def todo_item_factory do
    %Todo.Todos.TodoItem{
      description: Faker.Lorem.sentence(),
      done: false,
      todo_list: build(:todo_list)
    }
  end
end
