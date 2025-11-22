import 'package:flutter/material.dart';

class SemesterResultPage extends StatefulWidget {
  const SemesterResultPage({super.key, required this.title});

  final String title;

  @override
  State<SemesterResultPage> createState() => _SemesterResultPageState();
}

class _SemesterResultPageState extends State<SemesterResultPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(child: Text(widget.title)),
    );
  }
}
