import 'package:flutter_bloc/flutter_bloc.dart';

import '../utils/dbhelper.dart';
import '../models/employee.dart';
import '../cubit/employeestate.dart';

class EmployeeCubit extends Cubit<CubitState> {
  EmployeeCubit() : super(EmployeeLoading());

  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<void> addEmployee(Employee employee) async {
    try {
      await _databaseHelper.insertEmployee(employee);
      getEmployees();
    } catch (e) {
      emit(EmployeeError(e.toString(), EmployeeState.error));
    }
  }

  Future<void> deleteEmployee(int id) async {
    try {
      await _databaseHelper.deleteEmployee(id);
      getEmployees();
    } catch (e) {
      emit(EmployeeError(e.toString(), EmployeeState.error));
    }
  }

  Future<void> getEmployees() async {
    emit(EmployeeLoading());
    try {
      final employees = await _databaseHelper.getEmployees();
      if (employees.isEmpty) {
        emit(EmployeeEmpty());
      } else {

        List<Employee> currentEmployees =
            employees.where((e) => e.toDate == null).toList();
        List<Employee> exEmployees =
            employees.where((e) => e.toDate != null).toList();


        emit(EmployeeLoadedState(
            currentEmployees, exEmployees, EmployeeState.loaded));
      }
    } catch (e) {
      emit(EmployeeError(e.toString(), EmployeeState.error));
    }
  }
}
