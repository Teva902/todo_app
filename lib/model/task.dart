class Task {
  static const String collectionName = 'tasks';
  String id;

  String title;

  String description;
  DateTime dateTime;

  bool isDone;

  Task(
      {this.id = '',
      required this.title,
      required this.description,
      required this.dateTime,
      this.isDone = false});

  Task.fromFireStore(Map<String, dynamic> data)
      : this(
            id: data['id'] as String,
            title: data['title'] as String,
            dateTime: DateTime.fromMillisecondsSinceEpoch(data['dateTime']),
            description: data['description'] as String,
            isDone: data['isDone'] as bool);

  Map<String, dynamic> toFireStore() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dateTime': dateTime.millisecondsSinceEpoch,
      'isDone': isDone
    };
  }
}
