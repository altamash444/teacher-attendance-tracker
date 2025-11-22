import 'package:attendance/views/pages/teacher_attendance_page.dart';
import 'package:flutter/material.dart';

class TeacherCard extends StatelessWidget {
  const TeacherCard({
    super.key,
    required this.image,
    required this.name,
    required this.percent,
    required this.totalLectures,
  });

  final String image;
  final String name;
  final int percent;
  final int totalLectures;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return TeacherAttendancePage(name: name);
            },
          ),
        );
      },
      child: SizedBox(
        width: 310,
        height: 90,
        child: Card.outlined(
          child: Row(
            spacing: 5,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.asset(image, fit: BoxFit.fitWidth),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10, left: 10, bottom: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      totalLectures == 0
                          ? 'No lectures conducted.'
                          : 'Total lectures: $totalLectures',
                    ),
                    Row(
                      spacing: 10,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            Container(
                              width: 155,
                              height: 6,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: totalLectures != 0
                                    ? Colors.grey.shade300
                                    : Colors.transparent,
                              ),
                            ),
                            Container(
                              width: percent * 155 / 100,
                              height: 6,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: Colors.blue.shade800,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          totalLectures != 0 ? '${percent.toString()}%' : '',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
