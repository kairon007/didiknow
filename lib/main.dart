import 'package:flutter/material.dart';
import 'package:realtime/screens/employeescreen.dart';
import 'package:realtime/screens/addemployeescreen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:realtime/cubit/employeecubit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EmployeeCubit(),
      child: MaterialApp(
        title: 'Employee List',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
          useMaterial3: true,
        ),
        home: const EmployeeScreen(),
      ),
    );
  }
}


