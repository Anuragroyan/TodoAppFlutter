import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/task_viewmodel.dart';
import '../widgets/task_tile.dart';
import '../widgets/task_dialog.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TaskViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Tasks"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showTaskDialog(context),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          // 🔍 SEARCH BAR
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                hintText: "Search tasks...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: vm.setSearchQuery,
            ),
          ),

          // FILTER CHIPS
          Wrap(
            spacing: 8,
            children: Filter.values.map((filter) {
              return ChoiceChip(
                label: Text(filter.name.toUpperCase()),
                selected: vm.currentFilter == filter,
                onSelected: (_) => vm.setFilter(filter),
              );
            }).toList(),
          ),

          const SizedBox(height: 8),

          Expanded(
            child: vm.tasks.isEmpty
                ? const Center(child: Text("No tasks found"))
                : ListView.builder(
              itemCount: vm.tasks.length,
              itemBuilder: (_, index) =>
                  TaskTile(task: vm.tasks[index]),
            ),
          ),
        ],
      ),
    );
  }
}