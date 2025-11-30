import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';

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
    log("Error fetching percent and total of teachers and lectures: $e");
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
    return (totalPresentLectures.docs.length / totalLectures.docs.length * 100)
        .toInt();
  } catch (e) {
    log('Error fetching average attendance: $e');
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
    log('Error fetching teacher names: $e');
    return [];
  }
}

Future<List<String>> getLabNames() async {
  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('labs')
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
    log('Error fetching lab names: $e');
    return [];
  }
}

Future<List<String>> getSubjectNames() async {
  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('subjects')
        .get();

    List<String> names = [];

    for (var doc in querySnapshot.docs) {
      String? name = doc.get('in_short');
      if (name != null) {
        names.add(name);
      }
    }
    return names;
  } catch (e) {
    log('Error fetching subject names: $e');
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
    log('Error fetching teacher ids: $e');
    return [];
  }
}

Future<int> getCurrentSem() async {
  try {
    final DocumentSnapshot document = await FirebaseFirestore.instance
        .collection('data')
        .doc('constants')
        .get();
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    return data['current_sem'];
  } catch (e) {
    log('Error fetching current sem: $e');
    return 4;
  }
}
