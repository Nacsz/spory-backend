import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/diary.dart';
import '/base_url.dart';

class DiaryService {

  Future<List<Diary>> fetchDiaries() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    final response = await http.get(
      Uri.parse('$baseUrl/api/diary/'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List data = json.decode(utf8.decode(response.bodyBytes));
      return data.map((e) => Diary.fromJson(e)).toList();
    } else {
      throw Exception('다이어리 목록 불러오기 실패');
    }
  }

  Future<bool> createDiary(String title, String content) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    final response = await http.post(
      Uri.parse('$baseUrl/api/diary/create/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'title': title,
        'content': content,
      }),
    );

    return response.statusCode == 201;
  }
}
