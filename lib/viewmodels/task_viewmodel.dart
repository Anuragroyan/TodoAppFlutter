import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../models/task_model.dart';

enum Filter { all, completed, pending }

class TaskViewModel extends ChangeNotifier {
  final Box box = Hive.box('tasksBox');
  final uuid = const Uuid();

  List<Task> _tasks = [];
  Filter _filter = Filter.all;
  String _searchQuery = "";

  List<Task> get tasks {
    List<Task> filtered = _tasks;

    if (_filter == Filter.completed) {
      filtered = filtered.where((t) => t.isCompleted).toList();
    } else if (_filter == Filter.pending) {
      filtered = filtered.where((t) => !t.isCompleted).toList();
    }

    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where((t) =>
          t.title.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    return filtered;
  }

  Filter get currentFilter => _filter;

  TaskViewModel() {
    loadTasks();
  }

  void loadTasks() {
    _tasks.clear();
    for (var key in box.keys) {
      final data = box.get(key);
      _tasks.add(Task(
        id: key,
        title: data['title'],
        isCompleted: data['isCompleted'],
        dueDate: data['dueDate'] != null
            ? DateTime.parse(data['dueDate'])
            : null,
      ));
    }
    notifyListeners();
  }

  void addTask(String title, DateTime? dueDate) {
    final id = uuid.v4();
    final task = Task(id: id, title: title, dueDate: dueDate);
    _tasks.add(task);
    box.put(id, {
      "title": title,
      "isCompleted": false,
      "dueDate": dueDate?.toIso8601String(),
    });
    notifyListeners();
  }

  void deleteTask(String id) {
    _tasks.removeWhere((t) => t.id == id);
    box.delete(id);
    notifyListeners();
  }

  void editTask(String id, String newTitle, DateTime? dueDate) {
    final task = _tasks.firstWhere((t) => t.id == id);
    task.title = newTitle;
    task.dueDate = dueDate;
    box.put(id, {
      "title": newTitle,
      "isCompleted": task.isCompleted,
      "dueDate": dueDate?.toIso8601String(),
    });
    notifyListeners();
  }

  void toggleTask(String id) {
    final task = _tasks.firstWhere((t) => t.id == id);
    task.isCompleted = !task.isCompleted;
    box.put(id, {
      "title": task.title,
      "isCompleted": task.isCompleted,
      "dueDate": task.dueDate?.toIso8601String(),
    });
    notifyListeners();
  }

  void setFilter(Filter filter) {
    _filter = filter;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }
}