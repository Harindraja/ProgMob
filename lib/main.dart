import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'package:get_storage/get_storage.dart';
import 'package:dio/dio.dart';

void main() async {
  await GetStorage.init();
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});

  final _dio = Dio();
  final _storage = GetStorage();
  final _apiUrl = 'https://mobileapis.manpits.xyz/api';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(dio: _dio, storage: _storage, apiUrl: _apiUrl),
    );
  }
}