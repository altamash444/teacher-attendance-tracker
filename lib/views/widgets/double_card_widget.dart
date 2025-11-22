import 'package:attendance/views/widgets/semester_widget.dart';
import 'package:flutter/material.dart';

class DoubleCardWidget extends StatelessWidget {
  const DoubleCardWidget({
    super.key,
    required this.title,
    required this.icon1,
    required this.semTitle1,
    required this.toDo1,
    required this.toDo2,
    required this.icon2,
    required this.semTitle2,
  });

  final String title;
  final Widget icon1;
  final String semTitle1;
  final Function toDo1;
  final Function toDo2;
  final Widget icon2;
  final String semTitle2;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
          child: Text(title, style: TextStyle(fontSize: 16)),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () {
                toDo1();
              },
              child: SemesterWidget(icon: icon1, title: semTitle1),
            ),
            InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () {
                toDo2();
              },
              child: SemesterWidget(icon: icon2, title: semTitle2),
            ),
          ],
        ),
      ],
    );
  }
}
