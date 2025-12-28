import 'package:attendance/utils/fetch_data.dart';
import 'package:attendance/views/data/notifiers.dart';
import 'package:attendance/views/pages/dummy/dummy_home_page.dart';
import 'package:attendance/views/widgets/teacher_card.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    Future<List<dynamic>> fetchAllData() async {
      return Future.wait([
        // DON'T CHANGE THE ORDER (IT'S DESTRUCTIVE)
        getAverageAttendance(),
        getPercentForTeachers(getTeacherId()),
        getTeacherNames(),
        getLabNames(),
        getSubjectNames(),
        getCurrentSem(),
        getTeacherId(),

        // ALWAYS ADD FUNCTIONS HERE
      ]);
    }

    return FutureBuilder(
      future: fetchAllData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return DummyHomePage();
        }
        if (snapshot.hasError) {
          return Center(
            child: Text('Some error occured,\ncheck internet connection.'),
          );
        }

        int averageAttendance = snapshot.data?[0];
        List<(int, int)> percentAndTotal = snapshot.data?[1];
        List<String> teacherNames = snapshot.data?[2];
        for (int i = 0; i < teacherNames.length; i++) {
          if (teacherNamesNotifier.value.length != teacherNames.length) {
            teacherNamesNotifier.value.add(teacherNames[i]);
          }
        }
        List<String> labNames = snapshot.data?[3];
        for (int i = 0; i < labNames.length; i++) {
          if (labNamesNotifier.value.length != labNames.length) {
            labNamesNotifier.value.add(labNames[i]);
          }
        }
        List<String> subjectNames = snapshot.data?[4];
        for (int i = 0; i < subjectNames.length; i++) {
          if (labSubjectNotifier.value.length != subjectNames.length) {
            labSubjectNotifier.value.add(subjectNames[i]);
          }
        }
        currentSemNotifier.value = snapshot.data?[5];

        return SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 10),

                Text(
                  '${averageAttendance.toString()}%',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 54),
                ),
                Text(
                  'Average Attendance',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                ),
                SizedBox(height: 40),

                SizedBox(
                  height: 330,
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 16.0,
                          top: 8.0,
                          bottom: 8.0,
                        ),
                        child: Text('Teachers', style: TextStyle(fontSize: 20)),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: BouncingScrollPhysics(),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(width: 10), // Left padding
                            // Loop through the list, jumping by 3 (the number of items per column)
                            for (int i = 0; i < teacherNames.length; i += 3)
                              Column(
                                children: [
                                  // Inner loop: generate the cards for this specific column
                                  // We ensure 'j' doesn't go out of bounds (j < teacherNames.length)
                                  for (
                                    int j = i;
                                    j < i + 3 && j < teacherNames.length;
                                    j++
                                  )
                                    TeacherCard(
                                      image:
                                          'assets/images/teacher_images/${snapshot.data?[6][j]}.png',
                                      name: teacherNames[j],
                                      percent: percentAndTotal[j].$1,
                                      totalLectures: percentAndTotal[j].$2,
                                    ),
                                ],
                              ),

                            SizedBox(width: 10), // Right padding
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
