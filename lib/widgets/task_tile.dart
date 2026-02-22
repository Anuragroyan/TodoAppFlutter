import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task_model.dart';
import '../viewmodels/task_viewmodel.dart';
import 'task_dialog.dart';

class TaskTile extends StatelessWidget {
  final Task task;

  const TaskTile({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final vm = context.read<TaskViewModel>();

    return Dismissible(
      key: Key(task.id),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) {
        final deleted = task;
        vm.deleteTask(task.id);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("Task deleted"),
            action: SnackBarAction(
              label: "UNDO",
              onPressed: () =>
                  vm.addTask(deleted.title, deleted.dueDate),
            ),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: ListTile(
          onTap: () => showTaskDialog(context, task: task),
          leading: Checkbox(
            value: task.isCompleted,
            onChanged: (_) => vm.toggleTask(task.id),
          ),
          title: Text(
            task.title,
            style: TextStyle(
              decoration:
              task.isCompleted ? TextDecoration.lineThrough : null,
            ),
          ),
          subtitle: task.dueDate != null
              ? Text("Due: ${task.dueDate!.toLocal().toString().split(' ')[0]}")
              : null,
        ),
      ),
    );
  }
}