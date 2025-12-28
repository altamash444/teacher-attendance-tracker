import 'package:attendance/utils/convert.dart';
import 'package:attendance/utils/fetch_data.dart';
import 'package:attendance/views/data/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TeacherAttendancePage extends StatefulWidget {
  const TeacherAttendancePage({
    super.key,
    required this.name,
    required this.totalLectures,
    required this.image,
  });

  final String name;
  final String image;
  final int totalLectures;

  @override
  State<TeacherAttendancePage> createState() => _TeacherAttendancePageState();
}

class _TeacherAttendancePageState extends State<TeacherAttendancePage> {
  late final Map<String, String> subjectMap;
  @override
  void initState() {
    // fullSubjectNamesNotifier.value = await getFullSubjectNames();
    // addSubjectNames();
    _subjectDictionary();
    super.initState();
  }

  void _subjectDictionary() async {
    subjectMap = await getSubjectDictionary();
  }

  @override
  Widget build(BuildContext context) {
    List<int> month = [];
    bool isSpacable = false;
    return Scaffold(
      appBar: AppBar(title: Text(widget.name)),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              children: [
                FutureBuilder(
                  future: getTeacherFullData(
                    widget.name.split(' ')[0].toLowerCase(),
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container(
                        width: double.infinity,
                        height: 250,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(24),
                        ),
                      );
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Some error occured.'));
                    }
                    // print(
                    //   snapshot.data?.docs.length.toString() ??
                    //       'full data is null',
                    // );
                    // print(snapshot.data?.docs.toList());

                    late final DateTime? joiningDate;

                    final teacherFullData = snapshot.data;

                    // final teacherFullData = snapshot.data?.docs.elementAt(
                    //   teacherIndex,
                    // );
                    final Timestamp? joiningStamp =
                        teacherFullData?['joining_date'];
                    if (joiningStamp != null) {
                      joiningDate = joiningStamp.toDate();
                    } else {
                      joiningDate = null;
                    }

                    return Container(
                      decoration: BoxDecoration(
                        border: BoxBorder.all(width: 2, color: Colors.white24),
                        borderRadius: BorderRadius.all(Radius.circular(27)),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadiusGeometry.circular(24),
                        child: Stack(
                          children: [
                            Image.asset(
                              widget.image,
                              fit: BoxFit.fitWidth,
                              height: 250,
                              width: double.infinity,
                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                  child: Image.asset(
                                    'assets/images/webdev.png',
                                    height: 250,
                                  ),
                                );
                              },
                            ),
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Colors.transparent, Colors.black],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: 2,
                                children: [
                                  SizedBox(height: 115, width: double.infinity),
                                  Row(
                                    spacing: 15,
                                    children: [
                                      Row(
                                        spacing: IconStyle.iconTextSpacing,
                                        children: [
                                          // Icon(
                                          //   Icons.workspace_premium_outlined,
                                          //   color: Colors.white,
                                          //   size: IconStyle.iconSize,
                                          // ),
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.primaryContainer,
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 6.0,
                                                    vertical: 2.0,
                                                  ),
                                              child: Text(
                                                teacherFullData?['qualification'] ??
                                                    'NA',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      Row(
                                        spacing: IconStyle.iconTextSpacing,
                                        children: [
                                          Icon(
                                            Icons.person_outline_rounded,
                                            color: Colors.white,
                                            size: IconStyle.iconSize,
                                          ),
                                          Text(
                                            teacherFullData?['age'] == null
                                                ? 'NA'
                                                : '~${teacherFullData?['age'].toString()}',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Text(
                                    teacherFullData?['full_name'],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24,
                                    ),
                                  ),
                                  Divider(color: Colors.grey),
                                  Row(
                                    spacing: 25,
                                    children: [
                                      Row(
                                        spacing: IconStyle.iconTextSpacing,
                                        children: [
                                          Icon(
                                            Icons.calendar_today_outlined,
                                            color: Colors.grey,
                                            size: IconStyle.iconSize,
                                          ),
                                          Text(
                                            joiningDate == null
                                                ? 'NA'
                                                : 'joined ${joiningDate.day} ${DateFormat.MMMM().format(joiningDate)} ${joiningDate.year}',
                                            // ' joined {25 October 1999}',
                                            style: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        spacing: IconStyle.iconTextSpacing,
                                        children: [
                                          Icon(
                                            Icons.credit_card,
                                            size: IconStyle.iconSize,
                                            color: Colors.grey,
                                          ),
                                          Text(
                                            teacherFullData?['PAN'] == null
                                                ? 'NA'
                                                : '${teacherFullData?['PAN']}',
                                            // '******248F',
                                            style: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: FutureBuilder(
                    future: getPresentLectures(
                      widget.name.split(' ')[0].toLowerCase(),
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 50.0),
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (snapshot.hasError) {
                        return Text(
                          'Some error occured,\ncheck your internet connection.',
                        );
                      }
                      return Column(
                        children: [
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 36.0,
                                vertical: 16.0,
                              ),
                              child: widget.totalLectures != 0
                                  ? Column(
                                      spacing: 5,
                                      children: [
                                        Text(
                                          '${snapshot.data?.docs.length.toString()} out of ${widget.totalLectures}',
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          'Lectures present',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ],
                                    )
                                  : Text('No lectures conducted.'),
                            ),
                          ),
                          FutureBuilder(
                            future: getAllLectures(
                              widget.name.split(' ')[0].toLowerCase(),
                            ),
                            builder: (context, asyncSnapshot) {
                              if (asyncSnapshot.hasData) {
                                List<QueryDocumentSnapshot<Object?>>? list =
                                    asyncSnapshot.data?.docs;
                                // ignore: prefer_is_empty
                                return list?.length != 0
                                    ? Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              top: 16.0,
                                              bottom: 8.0,
                                              left: 8,
                                            ),
                                            child: Align(
                                              alignment:
                                                  AlignmentGeometry.centerLeft,
                                              child: Text(
                                                'Recent Lectures',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                          ...List.generate(list?.length ?? 0, (
                                            index,
                                          ) {
                                            final int lectureHour =
                                                fromStampToTime(
                                                  list?.elementAt(
                                                    index,
                                                  )['datetime'],
                                                ).hour;
                                            final String amPm = lectureHour > 11
                                                ? 'pm'
                                                : 'am';
                                            final DateTime lectureDate =
                                                asyncSnapshot.data?.docs
                                                    .elementAt(
                                                      index,
                                                    )['datetime']
                                                    .toDate();
                                            final labn = asyncSnapshot
                                                .data
                                                ?.docs
                                                .elementAt(index)['lab'];
                                            month.add(lectureDate.month);
                                            if (month.length > 1) {
                                              if (month.reversed.elementAt(0) ==
                                                  month.reversed.elementAt(1)) {
                                                isSpacable = false;
                                              } else {
                                                isSpacable = true;
                                              }
                                            }
                                            return Column(
                                              children: [
                                                SizedBox(
                                                  height: !isSpacable ? 0 : 18,
                                                ),
                                                isSpacable
                                                    ? Center(
                                                        child: Text(
                                                          DateFormat(
                                                            'MMMM',
                                                          ).format(lectureDate),
                                                          style: TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      )
                                                    : SizedBox.shrink(),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        bottom: 4.0,
                                                      ),
                                                  child: Container(
                                                    width: double.infinity,
                                                    height: 80,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            14,
                                                          ),
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .surfaceContainer,
                                                      border: BoxBorder.all(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .outlineVariant,
                                                      ),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                            12.0,
                                                          ),
                                                      child: Row(
                                                        spacing: 10,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Center(
                                                            child: Container(
                                                              width: 40,
                                                              height: 40,
                                                              decoration:
                                                                  BoxDecoration(
                                                                    color: Colors
                                                                        .black12,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                          50,
                                                                        ),
                                                                  ),
                                                              child: Center(
                                                                child: Text(
                                                                  ((asyncSnapshot.data?.docs.length ??
                                                                              0) -
                                                                          index)
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                    color: Colors
                                                                        .white60,
                                                                    fontSize:
                                                                        20,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Column(
                                                            spacing: 5,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                subjectMap[list!
                                                                        .elementAt(
                                                                          index,
                                                                        )['subject_id']] ??
                                                                    'NA',
                                                                style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 20,
                                                                ),
                                                              ),
                                                              Row(
                                                                spacing: 10,
                                                                children: [
                                                                  Text(
                                                                    '${lectureDate.day} ${DateFormat('MMM').format(lectureDate)} ${lectureDate.year}',
                                                                    style: TextStyle(
                                                                      color: Colors
                                                                          .grey,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    '${lectureHour <= 12 ? lectureHour : lectureHour - 12}:00$amPm',
                                                                    style: TextStyle(
                                                                      color: Colors
                                                                          .grey,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    decoration: BoxDecoration(
                                                                      color: Theme.of(
                                                                        context,
                                                                      ).colorScheme.secondaryContainer,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                            4,
                                                                          ),
                                                                    ),
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.symmetric(
                                                                        vertical:
                                                                            1.0,
                                                                        horizontal:
                                                                            4.0,
                                                                      ),
                                                                      child: Text(
                                                                        '${labn != 'Main Building' ? labn : 'MB'}',
                                                                        style: TextStyle(
                                                                          color: Theme.of(
                                                                            context,
                                                                          ).colorScheme.secondary,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                          Expanded(
                                                            child: SizedBox(),
                                                          ),
                                                          Container(
                                                            width: 60,
                                                            decoration:
                                                                BoxDecoration(
                                                                  color: Colors
                                                                      .black12,
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                        6,
                                                                      ),
                                                                ),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets.symmetric(
                                                                    vertical:
                                                                        6.0,
                                                                  ),
                                                              child: Text(
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                list.elementAt(
                                                                          index,
                                                                        )['present'] ==
                                                                        true
                                                                    ? 'Present'
                                                                    : 'Absent',
                                                                style: TextStyle(
                                                                  color:
                                                                      asyncSnapshot.data?.docs.elementAt(
                                                                            index,
                                                                          )['present'] ==
                                                                          true
                                                                      ? Colors
                                                                            .green
                                                                      : Colors
                                                                            .red,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          }),
                                        ],
                                      )
                                    : SizedBox();
                              }
                              return SizedBox();
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
