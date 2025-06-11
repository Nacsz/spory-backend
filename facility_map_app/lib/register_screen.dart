import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '/base_url.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  // ✅ 여기에 들어가는 게 아까 말한 register 함수!
  Future<void> _register() async {
    final url = Uri.parse('$baseUrl/api/accounts/register/');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'id': _emailController.text,
        'password': _passwordController.text,
        'name': _nameController.text,
      }),
    );

    if (response.statusCode == 200) {
      print("✅ 회원가입 성공!");
      Navigator.pop(context); // 로그인 화면으로 이동
    } else {
      print("❌ 실패: ${response.body}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("회원가입")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _emailController, decoration: const InputDecoration(labelText: '이메일')),
            TextField(controller: _passwordController, decoration: const InputDecoration(labelText: '비밀번호'), obscureText: true),
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: '이름')),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _register,  // 🔹 여기서 버튼 누르면 API 호출됨
              child: const Text('회원가입'),
            ),
          ],
        ),
      ),
    );
  }
}
