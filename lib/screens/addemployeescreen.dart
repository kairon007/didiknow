import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../widgets/custom_date_field.dart';
import '../widgets/custom_dropdown.dart';
import '../widgets/custom_text_field.dart';

import '../widgets/calendar_page.dart';
import '../models/employee.dart';
import '../cubit/employeecubit.dart';

enum Calendar { day, week, month, year }

class AddEmployeeScreen extends StatefulWidget {
  final Employee? employee;

  const AddEmployeeScreen({Key? key, this.employee}) : super(key: key);

  @override
  _AddEmployeeScreenState createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  DateTime fromDate = DateTime.now();
  DateTime? toDate;
  Role? selectedRole;
  bool editEnabled = false;

  @override
  void initState() {
    super.initState();
    if (widget.employee != null) {
      editEnabled = true;
      _nameController.text = widget.employee!.name;
      selectedRole = widget.employee!.role;
      fromDate = widget.employee!.fromDate;
      toDate = widget.employee!.toDate;
    }
  }

  void showCustomDatePicker(bool from) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    List<bool> isSelectedFirstRow = [false, false];
    List<bool> isSelectedSecondRow = [false, false];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: SizedBox(
            width: screenWidth * 0.95,
            height: screenHeight * 0.7,
            child: CalendarPage(
              onSave: (selectedDate) {
                Navigator.pop(context);
                setState(() {
                  if (from) {
                    if (toDate == null || toDate!.isAfter(selectedDate)) {
                      fromDate = selectedDate;
                    }
                  } else {
                    if (selectedDate.isAfter(fromDate)) {
                      toDate = selectedDate;
                    }
                  }
                });
              },
              onCancel: () {
                Navigator.pop(context);
              },
            ),
          ),
        );
      },
    );
  }

  void _saveForm() {
    if (_formKey.currentState!.validate() && selectedRole != null) {
      final employee = Employee(
        id: widget.employee?.id ?? 0,
        name: _nameController.text,
        role: selectedRole!,
        fromDate: fromDate,
        toDate: toDate,
      );
      if (widget.employee != null) {
        context.read<EmployeeCubit>().updateEmployee(employee);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Employee details updated!')),
        );
      } else {
        context.read<EmployeeCubit>().addEmployee(employee);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Employee details saved!')),
        );
      }
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please provide relevant info!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          editEnabled ? 'Edit Employee Details' : 'Add Employee Details',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  CustomTextField(
                    controller: _nameController,
                    label: 'Employee Name',
                    icon: Icons.person,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter employee name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomDropdown(
                    value: selectedRole != null ? selectedRole!.name : "",
                    items: roles.map((role) {
                      return role.name;
                    }).toList(),
                    label: 'Position',
                    icon: Icons.work,
                    onChanged: (String? value) {
                      setState(() {
                        selectedRole =
                            roles.firstWhere((role) => role.name == value);
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a position';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: CustomDateField(
                          label: fromDate == null
                              ? 'From Date'
                              : DateFormat('d MMM yyyy').format(fromDate),
                          value: null,
                          icon: Icons.calendar_today,
                          onChanged: (date) {},
                          onTap: () => showCustomDatePicker(true),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          child: const Icon(
                            Icons.arrow_forward,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      Expanded(
                        child: CustomDateField(
                          label: toDate == null
                              ? 'No Date'
                              : DateFormat('d MMM yyyy').format(toDate!),
                          value: null,
                          icon: Icons.calendar_today,
                          onChanged: (date) {},
                          onTap: () => showCustomDatePicker(false),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, -1),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _saveForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: const Text('Save'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}
