import 'package:flutter/material.dart';

class TeacherAttendancePage extends StatelessWidget {
  const TeacherAttendancePage({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(child: Text(name)),
    );
  }
}
