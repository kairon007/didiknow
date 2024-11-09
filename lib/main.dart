import 'package:flutter/material.dart';
import 'package:realtime/screens/employeescreen.dart';
import 'package:realtime/screens/addemployeescreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Employee List',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: const EmployeeScreen(),
    );
  }
}


