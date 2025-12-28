import 'dart:developer';
import 'package:attendance/views/data/notifiers.dart';
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
          .where('sem', isEqualTo: currentSemNotifier.value)
          .get();

      // Fetch present lectures
      QuerySnapshot presentLectures = await FirebaseFirestore.instance
          .collection('lectures')
          .where('teacher_id', isEqualTo: teacherName)
          .where('present', isEqualTo: true)
          .where('sem', isEqualTo: currentSemNotifier.value)
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
        .where('sem', isEqualTo: currentSemNotifier.value)
        .get();
    QuerySnapshot totalPresentLectures = await FirebaseFirestore.instance
        .collection('lectures')
        .where('present', isEqualTo: true)
        .where('sem', isEqualTo: currentSemNotifier.value)
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

Future<Map<String, String>> getSubjectDictionary() async {
  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('subjects')
        .get();

    Map<String, String> names = {};

    for (var doc in querySnapshot.docs) {
      String? name = doc.get('in_short');
      String? fullName = doc.get('name');
      if (name != null && fullName != null) {
        names[name.toLowerCase()] = fullName;
      }
    }
    return names;
  } catch (e) {
    log('Error fetching full subject dictionary: $e');
    return {};
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

Future<DocumentSnapshot?> getTeacherFullData(String tid) async {
  try {
    final DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('teachers')
        .doc(tid)
        .get();
    return documentSnapshot;
  } catch (e) {
    log('Error fetching full teacher data: $e');
    return null;
  }
}

Future<QuerySnapshot?> getPresentLectures(String tid) async {
  try {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('lectures')
        .where('teacher_id', isEqualTo: tid)
        .where('present', isEqualTo: true)
        .where('sem', isEqualTo: currentSemNotifier.value)
        .get();
    return querySnapshot;
  } catch (e) {
    log('Error fetching present lectures: $e');
    return null;
  }
}

Future<QuerySnapshot?> getAllLectures(String tid) async {
  try {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('lectures')
        .where('teacher_id', isEqualTo: tid)
        .orderBy('datetime', descending: true)
        .where('sem', isEqualTo: currentSemNotifier.value)
        .get();
    return querySnapshot;
  } catch (e) {
    log('Error fetching all lectures: $e');
    return null;
  }
}
