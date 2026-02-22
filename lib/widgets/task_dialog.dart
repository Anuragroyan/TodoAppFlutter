import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task_model.dart';
import '../viewmodels/task_viewmodel.dart';

Future<void> showTaskDialog(BuildContext context, {Task? task}) async {
  final controller = TextEditingController(text: task?.title ?? '');
  DateTime? selectedDate = task?.dueDate;

  await showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(task == null ? "Add Task" : "Edit Task"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: "Task title"),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Text(selectedDate == null
                    ? "No due date"
                    : "Due: ${selectedDate?.toLocal().toString().split(' ')[0]}"),
              ),
              IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                    initialDate: selectedDate ?? DateTime.now(),
                  );
                  if (picked != null) selectedDate = picked;
                },
              )
            ],
          )
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            if (controller.text.trim().isEmpty) return;
            final vm = context.read<TaskViewModel>();

            if (task == null) {
              vm.addTask(controller.text.trim(), selectedDate);
            } else {
              vm.editTask(task.id, controller.text.trim(), selectedDate);
            }

            Navigator.pop(context);
          },
          child: Text(task == null ? "Add" : "Update"),
        ),
      ],
    ),
  );
}