import 'package:flutter/material.dart';

import '../models/employee.dart';
import 'package:intl/intl.dart';

class EmployeeCard extends StatelessWidget {
  final Employee employee;

  const EmployeeCard({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(employee.name, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(employee.role.name, style: const TextStyle(color: Colors.grey)),
          Text(
            employee.toDate==null
                ? 'From ${DateFormat('d MMM, yyyy').format(employee.fromDate)}'
                : '${DateFormat('d MMM, yyyy').format(employee.fromDate)} - ${DateFormat('d MMM, yyyy').format(employee.toDate!)}',
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}