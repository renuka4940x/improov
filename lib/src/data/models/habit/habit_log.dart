class HabitLog {
  final String id;
  final String habitId; 
  final DateTime date; 

  HabitLog({
    required this.id,
    required this.habitId,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'habitId': habitId,
    'date': date.toIso8601String(),
  };

  factory HabitLog.fromJson(Map<String, dynamic> json) {
    return HabitLog(
      id: json['id'] ?? '',
      habitId: json['habitId'] ?? '',
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
    );
  }
}