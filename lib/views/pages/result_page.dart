import 'package:attendance/views/pages/semester_result_page.dart';
import 'package:attendance/views/widgets/double_card_widget.dart';
import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  const ResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DoubleCardWidget(
              title: "First Year",
              icon1: Image.asset('assets/images/dbms.png'),
              icon2: Image.asset('assets/images/webdev.png'),
              semTitle1: 'Semester 1',
              semTitle2: 'Semester 2',
              toDo1: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return SemesterResultPage(
                        title: "Semester 1 Result here.",
                      );
                    },
                  ),
                );
              },
              toDo2: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return SemesterResultPage(
                        title: "Semester 2 Result here.",
                      );
                    },
                  ),
                );
              },
            ),
            DoubleCardWidget(
              title: "Second Year",
              icon1: Image.asset('assets/images/os.png'),
              icon2: Image.asset('assets/images/java.png'),
              semTitle1: 'Semester 3',
              semTitle2: 'Semester 4',
              toDo1: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return SemesterResultPage(
                        title: "Semester 3 Result here.",
                      );
                    },
                  ),
                );
              },
              toDo2: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return SemesterResultPage(
                        title: "Semester 4 Result here.",
                      );
                    },
                  ),
                );
              },
            ),
            DoubleCardWidget(
              title: "Third Year",
              icon1: Icon(Icons.question_mark_rounded),
              icon2: Icon(Icons.question_mark_rounded),
              semTitle1: 'Semester 5',
              semTitle2: 'Semester 6',
              toDo1: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    showCloseIcon: true,
                    duration: Duration(seconds: 2),
                    content: Text('Sem 5 result not declared.'),
                  ),
                );
              },
              toDo2: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    showCloseIcon: true,
                    duration: Duration(seconds: 2),
                    content: Text('Sem 6 result not declared.'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
