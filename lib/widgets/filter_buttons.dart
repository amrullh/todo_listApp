import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/todo_provider.dart';

class FilterButtons extends StatelessWidget {
  const FilterButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TodoProvider>(
      builder: (context, todoProvider, child) {
        return ToggleButtons(
          borderRadius: BorderRadius.circular(8.0),
          isSelected: [
            todoProvider.filter == TodoFilter.all,
            todoProvider.filter == TodoFilter.active,
            todoProvider.filter == TodoFilter.done,
          ],
          onPressed: (index) {
            final newFilter = TodoFilter.values[index];
            todoProvider.setFilter(newFilter);
          },
          children: const [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text('All'),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text('Active'),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text('Done'),
            ),
          ],
        );
      },
    );
  }
}