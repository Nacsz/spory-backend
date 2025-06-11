import 'package:flutter/material.dart';
import '../diary_service.dart';
import '../models/diary.dart';

class DiaryListScreen extends StatefulWidget {
  const DiaryListScreen({super.key});

  @override
  State<DiaryListScreen> createState() => _DiaryListScreenState();
}

class _DiaryListScreenState extends State<DiaryListScreen> {
  List<Diary> _diaries = [];
  final _service = DiaryService();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadDiaries();
  }

  Future<void> _loadDiaries() async {
    try {
      final diaries = await _service.fetchDiaries();
      setState(() {
        _diaries = diaries;
      });
    } catch (e) {
      print("❌ 에러: $e");
    }
  }

  Future<void> _createDiary() async {
    final title = _titleController.text;
    final content = _contentController.text;

    if (await _service.createDiary(title, content)) {
      _titleController.clear();
      _contentController.clear();
      _loadDiaries();
      Navigator.pop(context); // 모달 닫기
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('다이어리 등록 실패')),
      );
    }
  }

  void _showCreateDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
            left: 16, right: 16, bottom: MediaQuery.of(context).viewInsets.bottom + 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: '제목'),
            ),
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(labelText: '내용'),
              maxLines: 3,
            ),
            ElevatedButton(
              onPressed: _createDiary,
              child: const Text('등록'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("📘 내 다이어리")),
      body: ListView.builder(
        itemCount: _diaries.length,
        itemBuilder: (context, index) {
          final diary = _diaries[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(diary.title),
              subtitle: Text(diary.content),
              trailing: Text(diary.createdTime.split("T")[0]),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
