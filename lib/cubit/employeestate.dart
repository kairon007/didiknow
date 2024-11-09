import '../models/employee.dart';

enum EmployeeState {
  initial,
  loading,
  loaded,
  error,
}
abstract class CubitState {}
class EmployeeLoadedState extends CubitState {

  List<Employee> currentEmployees;
  List<Employee> exEmployees;
  EmployeeState state;
  EmployeeLoadedState(this.currentEmployees,this.exEmployees,this.state);

}


class EmployeeEmpty extends CubitState {}
class EmployeeLoading extends CubitState {

}
class EmployeeError extends CubitState {
  EmployeeState state;
  String error;
  EmployeeError(this.error,this.state);
}