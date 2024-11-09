class Employee {
  final int? id;
  final String name;
  final Role role;
  final DateTime fromDate;
  final DateTime? toDate;

  Employee({
    this.id,
    required this.name,
    required this.role,
    required this.fromDate,
     this.toDate,
  });
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'role': role.value,
      'fromDate': fromDate.toIso8601String(),
      'toDate': toDate?.toIso8601String(),
    };
  }
  factory Employee.fromMap(Map<String, dynamic> map) {
    return Employee(
      id: map['id'],
      name: map['name'],
      role:roles.firstWhere((role) => role.toString() == map['role']),
      fromDate: DateTime.parse(map['fromDate']),
      toDate: map['toDate'] != null ? DateTime.parse(map['toDate']) : null,
    );
  }
}


class Role {
  final String name;
  final String value;

  const Role({required this.name, required this.value});
}

List<Role> roles = [
  const Role(name: 'Web Designer', value: 'designer'),
  const Role(name: 'Software Developer', value: 'developer'),
  const Role(name: 'Quality Assurance Tester', value: 'tester'),
  const Role(name: 'Project Owner', value: 'owner'),
];