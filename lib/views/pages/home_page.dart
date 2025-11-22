import 'dart:developer';

import 'package:attendance/views/pages/dummy/dummy_home_page.dart';
import 'package:attendance/views/widgets/teacher_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    Future<List<(int percent, int total)>> getPercentForTeachers(
      Future<List<String>> futureTeacherNames,
    ) async {
      try {
        final teacherNames = await futureTeacherNames;
        List<(int, int)> results = [];

        for (final teacherName in teacherNames) {
          // Fetch total lectures
          QuerySnapshot totalLectures = await FirebaseFirestore.instance
              .collection('lectures')
              .where('teacher_id', isEqualTo: teacherName)
              .get();

          // Fetch present lectures
          QuerySnapshot presentLectures = await FirebaseFirestore.instance
              .collection('lectures')
              .where('teacher_id', isEqualTo: teacherName)
              .where('present', isEqualTo: true)
              .get();

          int total = totalLectures.docs.length;
          int percent = 0;

          if (total > 0) {
            percent = ((presentLectures.docs.length / total) * 100).toInt();
          }

          results.add((percent, total));
        }

        return results;
      } catch (e) {
        log("Error: $e");
        return [];
      }
    }

    Future<int> getAverageAttendance() async {
      try {
        QuerySnapshot totalLectures = await FirebaseFirestore.instance
            .collection('lectures')
            .get();
        QuerySnapshot totalPresentLectures = await FirebaseFirestore.instance
            .collection('lectures')
            .where('present', isEqualTo: true)
            .get();
        return (totalPresentLectures.docs.length /
                totalLectures.docs.length *
                100)
            .toInt();
      } catch (e) {
        log('Error2: $e');
        return 0;
      }
    }

    Future<List<String>> getTeacherNames() async {
      try {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('teachers')
            .get();

        List<String> names = [];

        for (var doc in querySnapshot.docs) {
          String? name = doc.get('name');
          if (name != null) {
            names.add(name);
          }
        }
        return names;
      } catch (e) {
        log('Error3: $e');
        return [];
      }
    }

    Future<List<String>> getTeacherId() async {
      try {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('teachers')
            .get();

        List<String> ids = [];

        for (var doc in querySnapshot.docs) {
          ids.add(doc.id);
        }
        return ids;
      } catch (e) {
        log('Error4: $e');
        return [];
      }
    }

    Future<List<dynamic>> fetchAllData() async {
      return Future.wait([
        getAverageAttendance(),
        getPercentForTeachers(getTeacherId()),
        getTeacherNames(),
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
                            SizedBox(width: 10),
                            Column(
                              children: [
                                TeacherCard(
                                  image: 'assets/images/teacher_images/abu.png',
                                  name: teacherNames[0],
                                  percent: percentAndTotal[0].$1,
                                  totalLectures: percentAndTotal[0].$2,
                                ),
                                TeacherCard(
                                  image: 'assets/images/webdev.png',
                                  name: teacherNames[1],
                                  percent: percentAndTotal[1].$1,
                                  totalLectures: percentAndTotal[1].$2,
                                ),
                                TeacherCard(
                                  image:
                                      'assets/images/teacher_images/ismail.png',
                                  name: teacherNames[2],
                                  percent: percentAndTotal[2].$1,
                                  totalLectures: percentAndTotal[2].$2,
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                TeacherCard(
                                  image:
                                      'assets/images/teacher_images/neha.png',
                                  name: teacherNames[3],
                                  percent: percentAndTotal[3].$1,
                                  totalLectures: percentAndTotal[3].$2,
                                ),
                                TeacherCard(
                                  image:
                                      'assets/images/teacher_images/saima.png',
                                  name: teacherNames[4],
                                  percent: percentAndTotal[4].$1,
                                  totalLectures: percentAndTotal[4].$2,
                                ),
                                TeacherCard(
                                  image:
                                      'assets/images/teacher_images/shahid.png',
                                  name: teacherNames[5],
                                  percent: percentAndTotal[5].$1,
                                  totalLectures: percentAndTotal[5].$2,
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                TeacherCard(
                                  image: 'assets/images/webdev.png',
                                  name: teacherNames[6],
                                  percent: percentAndTotal[6].$1,
                                  totalLectures: percentAndTotal[6].$2,
                                ),
                              ],
                            ),
                            SizedBox(width: 10),
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
