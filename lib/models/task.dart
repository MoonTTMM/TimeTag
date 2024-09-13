class Task {
  final String id;
  final String taskName;
  final String startTime;
  final String duration;

  Task({required this.id, required this.taskName, required this.startTime, required this.duration});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'taskName': taskName,
      'startTime': startTime,
      'duration': duration,
    };
  }
}
