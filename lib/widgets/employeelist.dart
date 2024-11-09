import 'package:flutter/material.dart';
import '../models/employee.dart';
import 'package:realtime/cubit/employeecubit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:realtime/cubit/employeestate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:realtime/utils/constants.dart';
import 'package:realtime/widgets/employeecard.dart';
import 'package:realtime/screens/addemployeescreen.dart';

class EmployeeList extends StatelessWidget {
  const EmployeeList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmployeeCubit, CubitState>(
      builder: (context, state) {
        switch (state) {
          case EmployeeLoading():
            return const Center(
              child: CircularProgressIndicator(),
            );
          case EmployeeEmpty():
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.string(noRecordsImg),
                  const Text('No employees found.'),
                ],
              ),
            );
          case EmployeeLoadedState():
            return ListView(
              children: [
                _buildSectionHeader('Current Employees'),
                ...state.currentEmployees
                    .map((e) => _buildListItem(e, context))
                    .toList(),
                _buildSectionHeader('Previous Employees'),
                ...state.exEmployees
                    .map((e) => _buildListItem(e, context))
                    .toList(),
              ],
            );
          case EmployeeError():
            return Text('Error loading employees ${state.error}');
          default:
            return Container();
        }
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      color: Colors.grey[200],
      width: double.infinity,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
    );
  }

  Widget _buildListItem(Employee employee, BuildContext context) {
    return Dismissible(
      key: Key(employee.id.toString()),
      background: Container(color: Colors.red),
      onDismissed: (direction) {
        context.read<EmployeeCubit>().toggleEmployeeDelete(employee.id!);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Employee data has been deleted'),
              action: SnackBarAction(
                label: 'Undo',
                onPressed: () {
                  context
                      .read<EmployeeCubit>()
                      .toggleEmployeeDelete(employee.id!);
                },
              )),
        );
      },
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddEmployeeScreen(
                  employee: employee), // Pass the employee for editing
            ),
          );
        },
        child: EmployeeCard(employee: employee),
      ),
    );
  }
}
