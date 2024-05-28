
# Todo

### Prerequisites

- Elixir 1.16.0-otp-26
- Erlang 26.2.1
- SQLite for the database


### Installation

Clone the repository and fetch the dependencies:

```bash
git clone https://github.com/paulsullivanjr/todo.git

cd todo
``` 

Make sure you have `asdf` installed to manage the versions of Erlang and Elixir. The `.tool-versions` file in the project root will install the right versions when you navigate into the root directory of the project and run the following command.

```
asdf install
```

Get dependencies and setup database
```
mix deps.get && mix deps.compile
mix ecto.setup
MIX_ENV=test mix ecto.setup
```

### Running the Application

```elixir

iex -S mix phx.server
```
#### Create a todo list
```elixir
curl -i -X POST http://localhost:4000/api/todo_lists \
-H "Content-Type: application/json" \
-d '{
  "todo_list": {
    "title": "Foo List"
  }
}'

```

#### View a todo list
```elixir
TODO_LIST_ID=<todo list id>

curl -i -X GET http://localhost:4000/api/todo_lists/$TODO_LIST_ID \
-H "Content-Type: application/json"
```

#### create a todo list item
```elixir
TODO_LIST_ID=<todo list id>

curl -i -X POST http://localhost:4000/api/todo_lists/$TODO_LIST_ID/todo_items \
-H "Content-Type: application/json" \
-d '{
  "todo_item": {
    "description": "My Todo Item",
    "done": false
  }
}'

```
#### View the items on the todo list
```elixir
curl -i -X GET http://localhost:4000/api/todo_lists/$TODO_LIST_ID/todo_items \
-H "Content-Type: application/json"

```

#### Mark the item as done
```elixir
TODO_ITEM_ID=<item id>
curl -i -X PUT http://localhost:4000/api/todo_lists/$TODO_LIST_ID/todo_items/$TODO_ITEM_ID/done \
-H "Content-Type: application/json"

```

#### Remove the item from the list
```elixir
curl -i -X DELETE http://localhost:4000/api/todo_lists/$TODO_LIST_ID/todo_items/$TODO_ITEM_ID \
-H "Content-Type: application/json"

```


