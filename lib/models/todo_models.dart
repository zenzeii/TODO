class Todo {
  int? id;
  String title;
  DateTime date;
  int status;
  int priority;

  Todo(
      {required this.title,
      required this.date,
      required this.status,
      required this.priority});
  Todo.withId(
      {required this.id,
      required this.title,
      required this.date,
      required this.status,
      required this.priority});

  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = id;
    }
    map['title'] = title;
    map['date'] = date.toIso8601String();
    map['status'] = status;
    map['priority'] = priority;
    return map;
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo.withId(
      id: map['id'],
      title: map['title'],
      date: DateTime.parse(map['date']),
      status: map['status'],
      priority: map['priority'],
    );
  }
}
