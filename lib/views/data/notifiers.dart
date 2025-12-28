import 'package:flutter/material.dart';

ValueNotifier<int> selectedPageNotifier = ValueNotifier(0);
ValueNotifier<bool> isDarkModeNotifier = ValueNotifier(true);

ValueNotifier<int> currentSemNotifier = ValueNotifier(4);
ValueNotifier<List<String>> teacherNamesNotifier = ValueNotifier([]);
ValueNotifier<List<String>> labNamesNotifier = ValueNotifier([]);
ValueNotifier<List<String>> labSubjectNotifier = ValueNotifier([]);
ValueNotifier<List<String>> fullSubjectNamesNotifier = ValueNotifier([]);
// ValueNotifier<Map<String,String>> subjectNamesNotifier = ValueNotifier({});
