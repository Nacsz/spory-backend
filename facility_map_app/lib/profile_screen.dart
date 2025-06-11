import 'package:flutter/material.dart';
import 'login_screen.dart'; // login_screen이 있는 위치에 따라 경로 수정

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _logout(BuildContext context) {
    // ✅ 로그아웃 처리 로직 (토큰 삭제 등 필요시 여기에)
    // 이후 로그인 화면으로 이동
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('마이페이지')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _logout(context),
          child: const Text("로그아웃"),
        ),
      ),
    );
  }
}
