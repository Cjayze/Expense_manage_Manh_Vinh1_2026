import 'package:flutter/material.dart';
import 'pages/main_shell.dart';

void main() {
  runApp(const MyApp());
}

class MyGeneric<T> {
  T obj;

  MyGeneric(this.obj);

  void printData() {
    if (obj is List<Map<String, String>>) {
      for (var item in obj as List<Map<String, String>>) {
        print('${item['studentID']} - ${item['fullname']}');
      }
    } else {
      print(obj);
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo Quan li chi tieu',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MainShell(),
    );
  }
}
