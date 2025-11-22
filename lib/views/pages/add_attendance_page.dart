import 'dart:developer';
import 'package:attendance/views/data/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:attendance/views/widgets/carousel_picker_widget.dart';

class AddAttendancePage extends StatefulWidget {
  const AddAttendancePage({super.key});

  @override
  State<AddAttendancePage> createState() => _AddAttendancePageState();
}

class _AddAttendancePageState extends State<AddAttendancePage> {
  DateTime today = DateTime.now();

  DateTime dateTime = DateTime.now();
  String? teacher;
  String? subject;
  int numberOfLectures = 1;
  List<String?> lab = List.filled(4, null);
  List<TimeOfDay?> time = List.filled(4, null);
  List<bool?> present = List.filled(4, true);

  bool isSubmittable() {
    if (teacher == null && subject == null) {
      return false;
    }
    switch (numberOfLectures) {
      case 4:
        if (lab[3] == null || time[3] == null || present[3] == null) {
          return false;
        }
        break;
      case 3:
        if (lab[2] == null || time[2] == null || present[2] == null) {
          return false;
        }
        break;
      case 2:
        if (lab[1] == null || time[1] == null || present[1] == null) {
          return false;
        }
        break;
      case 1:
        if (lab[0] == null || time[0] == null || present[0] == null) {
          return false;
        }
        break;
    }
    return true;
  }

  DateTime toSecondFormat(DateTime date) {
    return DateTime(
      date.year,
      date.month,
      date.day,
      date.hour,
      date.minute,
      date.second,
      0,
      0,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    dateTime = toSecondFormat(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adding attendance'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return AddAttendancePage();
                  },
                ),
              );
            },
            icon: Icon(Icons.refresh_rounded),
            tooltip: 'Reset page',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
        child: Center(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Date of the lecture:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  OutlinedButton.icon(
                    label: Text(
                      dateTime.day == today.day
                          ? 'Today'
                          : '${dateTime.day.toString()}/${dateTime.month.toString()}/${dateTime.year.toString()}',
                    ),
                    icon: Icon(Icons.calendar_month_rounded),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(14),
                      ),
                    ),
                    onPressed: () async {
                      dateTime =
                          await showDatePicker(
                            context: context,
                            firstDate: DateTime(
                              today.year,
                              today.month,
                              today.day - 7,
                            ),
                            lastDate: today,
                            helpText: 'Choose lecture date',
                            initialDate: dateTime,
                            initialEntryMode: DatePickerEntryMode.calendarOnly,
                          ) ??
                          dateTime;
                      setState(() {});
                      log(dateTime.toString());
                      log(toSecondFormat(DateTime.now()).toString());
                    },
                  ),
                ],
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                    onPressed: () async {
                      final selected = await carouselPickerWidget(
                        context: context,
                        title: "Select Teacher",
                        items: Names.teacherNames,
                      );
                      if (selected != null) {
                        setState(() {
                          teacher = selected;
                          log(teacher ?? 'no');
                        });
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      fixedSize: Size.fromWidth(190),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(14),
                      ),
                    ),
                    child: Text(teacher ?? 'Select teacher'),
                  ),
                  OutlinedButton(
                    onPressed: () async {
                      final selected = await carouselPickerWidget(
                        context: context,
                        title: "Select Subject",
                        items: Names.subjectNames,
                      );
                      if (selected != null) {
                        setState(() {
                          subject = selected;
                        });
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      fixedSize: Size.fromWidth(120),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(14),
                      ),
                    ),
                    child: Text(subject ?? 'Subject'),
                  ),
                ],
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Number of lectures:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Row(
                    spacing: 15,
                    children: [
                      IconButton.outlined(
                        onPressed: () {
                          setState(() {
                            if (numberOfLectures > 1) {
                              numberOfLectures -= 1;
                            }
                          });
                        },
                        icon: Icon(Icons.remove),
                      ),
                      Text(
                        numberOfLectures.toString(),
                        style: TextStyle(fontSize: 18),
                      ),
                      IconButton.outlined(
                        onPressed: () {
                          setState(() {
                            if (numberOfLectures < 4) {
                              numberOfLectures += 1;
                            }
                          });
                        },
                        icon: Icon(Icons.add),
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Center(child: Icon(Icons.keyboard_arrow_down_rounded)),
              ),
              Column(
                children: List.generate(numberOfLectures, (index) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Text((index + 1).toString()),
                      ),
                      OutlinedButton(
                        onPressed: () async {
                          final selected = await carouselPickerWidget(
                            context: context,
                            title: 'Select Lab',
                            items: Names.labNames,
                          );
                          setState(() {
                            if (selected != null) {
                              lab[index] = selected;
                            }
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          fixedSize: Size.fromWidth(120),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadiusGeometry.circular(14),
                          ),
                        ),
                        child: Text(lab[index] ?? 'Lab'),
                      ),
                      OutlinedButton(
                        onPressed: () async {
                          final selected = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay(
                              hour: time[index]?.hour ?? 7,
                              minute: 0,
                            ),
                            helpText: 'Select time of lecture:',
                            initialEntryMode: TimePickerEntryMode.dialOnly,
                          );
                          if (selected != null) {
                            setState(() {
                              time[index] = selected;
                            });
                          }
                        },
                        style: OutlinedButton.styleFrom(
                          fixedSize: Size.fromWidth(120),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadiusGeometry.circular(14),
                          ),
                        ),
                        child: Text(
                          time[index] != null
                              ? '${time[index]!.hour < 13 ? time[index]!.hour : time[index]!.hour - 12}:${time[index]!.minute == 0 ? "00" : "00"}${time[index]!.period == DayPeriod.am ? "am" : "pm"}'
                              : 'Time',
                        ),
                      ),

                      present[index] == true
                          ? IconButton.filled(
                              onPressed: () {
                                setState(() {
                                  present[index] = present[index] == true
                                      ? false
                                      : true;
                                });
                              },
                              icon: Icon(Icons.check),
                            )
                          : IconButton.outlined(
                              onPressed: () {
                                setState(() {
                                  present[index] = present[index] == true
                                      ? false
                                      : true;
                                });
                              },
                              icon: Icon(Icons.close_rounded),
                            ),

                      // presentox(
                      //   value: present,
                      //   shape: CircleBorder(),
                      //   onChanged: (value) {
                      //     setState(() {
                      //       present = !present;
                      //     });
                      //   },
                      // ),
                    ],
                  );
                }),
              ),

              Expanded(child: SizedBox(height: double.infinity)),
              FilledButton(
                onPressed: () {
                  if (isSubmittable()) {
                    readyToPost();
                    // Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Fill details.'),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(8),
                        ),
                        showCloseIcon: true,
                        duration: Duration(seconds: 2),
                      ),
                    );
                    log('NOT submittable');
                  }
                },
                style: FilledButton.styleFrom(
                  fixedSize: Size.fromWidth(MediaQuery.of(context).size.width),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(14),
                  ),
                ),
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> readyToPost() async {
    try {
      switch (numberOfLectures) {
        case 1:
          postData(0);
        case 2:
          postData(0);
          postData(1);
        case 3:
          postData(0);
          postData(1);
          postData(2);
          log('case 3');
        case 4:
          postData(0);
          postData(1);
          postData(2);
          postData(3);
      }
      log('posted');
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Entry submitted.'),
          showCloseIcon: true,
          duration: Duration(seconds: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(8),
          ),
        ),
      );
    } catch (e) {
      log('Error: $e');
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Something went wrong.'),
          showCloseIcon: true,
          duration: Duration(seconds: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(8),
          ),
        ),
      );
    }
  }

  void postData(int index) async {
    final CollectionReference ref = FirebaseFirestore.instance.collection(
      'lectures',
    );
    await ref.doc('test').set({
      // .add() will be in future
      'datetime': mergeDateTime(dateTime, time[index]!),
      'entry_at': toSecondFormat(DateTime.now()),
      'lab': lab[index],
      'present': present[index],
      'subject_id': subject?.toLowerCase(),
      'teacher_id': teacher?.split(' ')[index].toLowerCase(),
    });
  }

  DateTime mergeDateTime(DateTime dateObj, TimeOfDay timeObj) {
    return DateTime(
      dateObj.year,
      dateObj.month,
      dateObj.day,
      timeObj.hour,
      0,
      0,
      0,
      0,
    );
  }
}
