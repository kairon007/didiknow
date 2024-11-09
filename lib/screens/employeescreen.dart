import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/employeecubit.dart';
import 'addemployeescreen.dart';
import '../widgets/employeelist.dart';

class EmployeeScreen extends StatefulWidget {
  const EmployeeScreen({super.key});
  @override
  _EmployeeScreenState createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen>
{
  late final EmployeeCubit _employeeCubit;

  @override
  void initState() {
    super.initState();
    _employeeCubit = EmployeeCubit();
    _employeeCubit.getEmployees();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Employees List',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body:BlocProvider(
        create: (context) => _employeeCubit,
        child: const EmployeeList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (context) => _employeeCubit,
                child: const AddEmployeeScreen(),
              ),
            ),
          );

        },
        child: const Icon(Icons.add,color: Colors.blue),
      ),
    );
  }
}




