class Task {
  int id;
  String name;
  bool completed = false;

  Task({
    required this.id,
    required this.name,
    required this.completed,
  });

  Task.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        completed = json['completed'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'completed': completed,
  };
}