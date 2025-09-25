import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/todo_provider.dart';
import '../widgets/todo_list_item.dart';
import '../widgets/filter_buttons.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addTodo() {
    if (_formKey.currentState!.validate()) {
      Provider.of<TodoProvider>(
        context,
        listen: false,
      ).addTodo(_controller.text);
      _controller.clear();
    }
  }

  void _showSnackbar(
    BuildContext context,
    String message, {
    VoidCallback? onUndo,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        action: onUndo != null
            ? SnackBarAction(label: 'Undo', onPressed: onUndo)
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Simple To-Do App'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: 'Add a new task...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.length < 3) {
                          return 'Task must be at least 3 characters long.';
                        }
                        return null;
                      },
                      onFieldSubmitted: (value) => _addTodo(),
                    ),
                  ),
                  const SizedBox(width: 10),
                  FloatingActionButton(
                    onPressed: _addTodo,
                    child: const Icon(Icons.add),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Consumer<TodoProvider>(
              builder: (context, todoProvider, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${todoProvider.activeTodoCount} active tasks',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    FilterButtons(),
                  ],
                );
              },
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Consumer<TodoProvider>(
                builder: (context, todoProvider, child) {
                  return ListView.builder(
                    itemCount: todoProvider.todos.length,
                    itemBuilder: (context, index) {
                      final todo = todoProvider.todos[index];
                      return TodoListItem(
                        todo: todo,
                        onToggle: () => todoProvider.toggleTodoStatus(todo.id),
                        onDelete: () {
                          todoProvider.removeTodo(todo.id);
                          _showSnackbar(
                            context,
                            'Task "${todo.title}" removed.',
                            onUndo: todoProvider.undoLastDelete,
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
