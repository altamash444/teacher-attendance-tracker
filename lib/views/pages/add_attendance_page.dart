import 'dart:developer';
import 'package:attendance/views/data/notifiers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:attendance/views/widgets/carousel_picker_widget.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

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

  late final String secretCode;
  TextEditingController secretCodeController = TextEditingController();
  bool isCodeCorrect = false;
  bool isCodeVisible = false;
  String phone = '918369048072';
  String message =
      "Hey! I think I will be a responsible user at adding teacher's attendance.";

  Future<void> launchWhatsApp({required String url}) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      // Handle the case where WhatsApp cannot be launched (e.g., not installed)
      log('Could not launch $url');
    }
  }

  bool isSubmittable() {
    if (teacher == null ||
        subject == null ||
        secretCodeController.text.trim() == '' ||
        !isCodeCorrect) {
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
    secretCodeController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    dateTime = toSecondFormat(dateTime);
    getSecretCode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 5,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: TextField(
                        autofocus: true,
                        controller: secretCodeController,
                        onTapOutside: (event) {
                          setState(() {
                            FocusScope.of(context).unfocus();
                            if (secretCodeController.text.trim() ==
                                secretCode) {
                              isCodeCorrect = true;
                              log("Correct code");
                            } else {
                              isCodeCorrect = false;
                              log("wrong code");
                            }
                          });
                        },
                        onEditingComplete: () {
                          setState(() {
                            if (secretCodeController.text.trim() ==
                                secretCode) {
                              isCodeCorrect = true;
                              log("Correct code");
                            } else {
                              isCodeCorrect = false;
                              log("wrong code");
                            }
                          });
                        },
                        obscureText: !isCodeVisible,
                        onSubmitted: (value) {
                          FocusScope.of(context).unfocus();
                        },
                        decoration: InputDecoration(
                          labelText: 'Secret code',
                          hintText: "Enter secret code",
                          helperText: isCodeCorrect
                              ? 'correct code'
                              : 'wrong code',
                          helperStyle: TextStyle(
                            color: isCodeCorrect
                                ? Colors.green
                                : Colors.red.shade300,
                            fontWeight: FontWeight.bold,
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                isCodeVisible = !isCodeVisible;
                              });
                            },
                            icon: Icon(
                              isCodeVisible
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Get secret code'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Contact us on Whatsapp and we will decide to share with you or not. \nThis is only to prevent platform abuse.",
                                  style: TextStyle(fontSize: 12),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Click to request code:'),
                                    IconButton(
                                      onPressed: () {
                                        String whatsappUrl =
                                            'whatsapp://send?phone=$phone&text=${Uri.encodeComponent(message)}';
                                        launchWhatsApp(url: whatsappUrl);
                                        Navigator.pop(context);
                                      },
                                      icon: SvgPicture.asset(
                                        'assets/icon/whatsapp.svg',
                                        colorFilter: ColorFilter.mode(
                                          Colors.green,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            actions: [
                              OutlinedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('Close'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Text(
                      "Don't have code?",
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ),
                Divider(),
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
                        FocusScope.of(context).requestFocus(FocusNode());
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
                              initialEntryMode:
                                  DatePickerEntryMode.calendarOnly,
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
                        FocusScope.of(context).requestFocus(FocusNode());
                        final selected = await carouselPickerWidget(
                          context: context,
                          title: "Select Teacher",
                          items: teacherNamesNotifier.value,
                        );
                        if (selected != null) {
                          setState(() {
                            teacher = selected;
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
                        FocusScope.of(context).requestFocus(FocusNode());
                        final selected = await carouselPickerWidget(
                          context: context,
                          title: "Select Subject",
                          items: labSubjectNotifier.value,
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
                            FocusScope.of(context).requestFocus(FocusNode());
                            final selected = await carouselPickerWidget(
                              context: context,
                              title: 'Select Lab',
                              items: labNamesNotifier.value,
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
                            FocusScope.of(context).requestFocus(FocusNode());
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

                SizedBox(width: double.infinity, height: 20),
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
                    fixedSize: Size.fromWidth(
                      MediaQuery.of(context).size.width,
                    ),
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
      ),
    );
  }

  Future<void> getSecretCode() async {
    try {
      DocumentSnapshot constants = await FirebaseFirestore.instance
          .collection('data')
          .doc('constants')
          .get();
      final data = constants.data() as Map<String, dynamic>?;
      if (data != null) {
        secretCode = data['secret_code'];
        log(secretCode);
      }
    } catch (e) {
      log("Error: $e");
    }
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
    await ref.add({
      // .add() will be in future
      'datetime': mergeDateTime(dateTime, time[index]!),
      'entry_at': toSecondFormat(DateTime.now()),
      'lab': lab[index],
      'present': present[index],
      'sem': currentSemNotifier.value,
      'subject_id': subject?.toLowerCase(),
      'teacher_id': teacher?.split(' ')[0].toLowerCase(),
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
