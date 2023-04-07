import 'package:flutter/cupertino.dart';
import 'package:todo_app_ui_ii_example/model/todo.dart';

class TodosProvider extends ChangeNotifier {
  List<Todo> _todos = [
    Todo(
      createdTime: DateTime.now(),
      title: 'Clean the fish tank 🐟',
      description: '''- Get some scrubs
- Transfer the fishes
- Redesign their home
- Transfer the fish back''',
    ),
    Todo(
      createdTime: DateTime.now(),
      title: 'Buy Coffee',
    ),
    Todo(
      createdTime: DateTime.now(),
      title: 'Go to church 🙏',
    ),
    Todo(
      createdTime: DateTime.now(),
      title: 'Go to the beach 🌊',
      description: '''- Ready some sunscreen
- Prepare the sandwiches
- Pick 3 clothing pairs
- Charge phones''',
    ),
  ];

  List<Todo> get todos => _todos.where((todo) => todo.isDone == false).toList();

  List<Todo> get todosCompleted =>
      _todos.where((todo) => todo.isDone == true).toList();

  void addTodo(Todo todo) {
    _todos.add(todo);

    notifyListeners();
  }

  void removeTodo(Todo todo) {
    _todos.remove(todo);

    notifyListeners();
  }

  bool toggleTodoStatus(Todo todo) {
    todo.isDone = !todo.isDone;
    notifyListeners();

    return todo.isDone;
  }

  void updateTodo(Todo todo, String title, String description) {
    todo.title = title;
    todo.description = description;

    notifyListeners();
  }
}
