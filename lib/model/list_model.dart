import 'package:google_tasks_clone/model/task_model.dart';

class GoogleList {
  int id;
  String name;
  List<Task> tasks;

  GoogleList({
    required this.id,
    required this.name,
    required this.tasks,
  });

  GoogleList.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        tasks = (json['tasks'] as List)
            .map((task) => Task.fromJson(task))
            .toList();

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'tasks': tasks.map((task) => task.toJson()).toList(),
  };
}