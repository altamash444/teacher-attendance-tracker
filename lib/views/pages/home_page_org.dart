import 'dart:developer';

import 'package:attendance/views/widgets/teacher_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    Future<(int, int)> getPercent(String teacherName) async {
      try {
        QuerySnapshot totalLectures = await FirebaseFirestore.instance
            .collection('lectures')
            .where('teacher_id', isEqualTo: teacherName)
            .get();
        QuerySnapshot presentLectures = await FirebaseFirestore.instance
            .collection('lectures')
            .where('teacher_id', isEqualTo: teacherName)
            .where('present', isEqualTo: true)
            .get();
        return (
          (presentLectures.docs.length / totalLectures.docs.length * 100)
              .toInt(),
          totalLectures.docs.length,
        );
      } catch (e) {
        log('Error1: $e');
        return (0, 0);
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

    return SingleChildScrollView(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 10),

            FutureBuilder(
              future: getAverageAttendance(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: Text('...'));
                }
                if (snapshot.hasError) {
                  return const Center(child: Text('Error occured'));
                }
                return Text(
                  '${snapshot.data.toString()}%',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 54),
                );
              },
            ),
            // Text(
            //   '20%',
            //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 54),
            // ),
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
                  FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('teachers')
                        .get(),
                    builder: (context, snapshotName) {
                      if (snapshotName.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: Column(
                            children: [
                              SizedBox(height: 150, width: double.infinity),
                              CircularProgressIndicator(),
                            ],
                          ),
                        );
                      }
                      if (!snapshotName.hasData) {
                        return const Center(child: Text('No data found.'));
                      }
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: BouncingScrollPhysics(),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(width: 10),
                            Column(
                              children: [
                                FutureBuilder(
                                  future: getPercent('abu'),
                                  builder: (context, snapshotPercent) {
                                    return TeacherCard(
                                      image:
                                          'assets/images/teacher_images/abu.png',
                                      name: snapshotName.data!.docs[0].get(
                                        'name',
                                      ),
                                      percent: snapshotPercent.data?.$1 ?? 0,
                                      totalLectures:
                                          snapshotPercent.data?.$2 ?? 0,
                                    );
                                  },
                                ),
                                FutureBuilder(
                                  future: getPercent('haroon'),
                                  builder: (context, snapshotPercent) {
                                    return TeacherCard(
                                      image: 'assets/images/webdev.png',
                                      name: snapshotName.data!.docs[1].get(
                                        'name',
                                      ),
                                      percent: snapshotPercent.data?.$1 ?? 0,
                                      totalLectures:
                                          snapshotPercent.data?.$2 ?? 0,
                                    );
                                  },
                                ),
                                FutureBuilder(
                                  future: getPercent('ismail'),
                                  builder: (context, snapshotPercent) {
                                    return TeacherCard(
                                      image:
                                          'assets/images/teacher_images/ismail.png',
                                      name: snapshotName.data!.docs[2].get(
                                        'name',
                                      ),
                                      percent: snapshotPercent.data?.$1 ?? 0,
                                      totalLectures:
                                          snapshotPercent.data?.$2 ?? 0,
                                    );
                                  },
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                FutureBuilder(
                                  future: getPercent('neha'),
                                  builder: (context, snapshotPercent) {
                                    return TeacherCard(
                                      image:
                                          'assets/images/teacher_images/neha.png',
                                      name: snapshotName.data!.docs[3].get(
                                        'name',
                                      ),
                                      percent: snapshotPercent.data?.$1 ?? 0,
                                      totalLectures:
                                          snapshotPercent.data?.$2 ?? 0,
                                    );
                                  },
                                ),
                                FutureBuilder(
                                  future: getPercent('saima'),
                                  builder: (context, snapshotPercent) {
                                    return TeacherCard(
                                      image:
                                          'assets/images/teacher_images/saima.png',
                                      name: snapshotName.data!.docs[4].get(
                                        'name',
                                      ),
                                      percent: snapshotPercent.data?.$1 ?? 0,
                                      totalLectures:
                                          snapshotPercent.data?.$2 ?? 0,
                                    );
                                  },
                                ),
                                FutureBuilder(
                                  future: getPercent('shahid'),
                                  builder: (context, snapshotPercent) {
                                    return TeacherCard(
                                      image:
                                          'assets/images/teacher_images/shahid.png',
                                      name: snapshotName.data!.docs[5].get(
                                        'name',
                                      ),
                                      percent: snapshotPercent.data?.$1 ?? 0,
                                      totalLectures:
                                          snapshotPercent.data?.$2 ?? 0,
                                    );
                                  },
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                FutureBuilder(
                                  future: getPercent('yaseera'),
                                  builder: (context, snapshotPercent) {
                                    return TeacherCard(
                                      image: 'assets/images/webdev.png',
                                      name: snapshotName.data!.docs[6].get(
                                        'name',
                                      ),
                                      percent: snapshotPercent.data?.$1 ?? 0,
                                      totalLectures:
                                          snapshotPercent.data?.$2 ?? 0,
                                    );
                                  },
                                ),
                              ],
                            ),
                            SizedBox(width: 10),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
