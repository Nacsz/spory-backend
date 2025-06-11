// models/diary.dart
class Diary {
  final int id;
  final int userId;
  final String title;
  final String content;
  final String createdTime;

  Diary({
    required this.id,
    required this.userId,
    required this.title,
    required this.content,
    required this.createdTime,
  });

  factory Diary.fromJson(Map<String, dynamic> json) {
    return Diary(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      createdTime: json['created_time'] ?? '',
    );
  }

}
