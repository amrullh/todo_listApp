import 'package:flutter/material.dart';
import '../models/todo_model.dart';
import 'package:uuid/uuid.dart';

enum TodoFilter { all, active, done }

class TodoProvider with ChangeNotifier {
  final List<Todo> _todos = [];
  TodoFilter _filter = TodoFilter.all;

  Todo? _lastDeletedTodo;
  int? _lastDeletedIndex;

  List<Todo> get todos {
    switch (_filter) {
      case TodoFilter.active:
        return _todos.where((todo) => !todo.isCompleted).toList();
      case TodoFilter.done:
        return _todos.where((todo) => todo.isCompleted).toList();
      case TodoFilter.all:
      default:
        return _todos;
    }
  }

  TodoFilter get filter => _filter;

  int get activeTodoCount => _todos.where((todo) => !todo.isCompleted).length;

  void addTodo(String title) {
    if (title.length < 3) return;
    _todos.add(Todo(id: const Uuid().v4(), title: title));
    notifyListeners();
  }

  void toggleTodoStatus(String id) {
    final todo = _todos.firstWhere((t) => t.id == id);
    todo.isCompleted = !todo.isCompleted;
    notifyListeners();
  }

  void removeTodo(String id) {
    final index = _todos.indexWhere((t) => t.id == id);
    if (index != -1) {
      _lastDeletedTodo = _todos[index];
      _lastDeletedIndex = index;
      _todos.removeAt(index);
      notifyListeners();
    }
  }

  void undoLastDelete() {
    if (_lastDeletedTodo != null && _lastDeletedIndex != null) {
      _todos.insert(_lastDeletedIndex!, _lastDeletedTodo!);
      _lastDeletedTodo = null;
      _lastDeletedIndex = null;
      notifyListeners();
    }
  }

  void setFilter(TodoFilter newFilter) {
    _filter = newFilter;
    notifyListeners();
  }
}