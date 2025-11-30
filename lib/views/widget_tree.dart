import 'package:attendance/views/data/constants.dart';
import 'package:attendance/views/data/notifiers.dart';
import 'package:attendance/views/pages/add_attendance_page.dart';
import 'package:attendance/views/pages/home_page.dart';
import 'package:attendance/views/pages/profile_page.dart';
import 'package:attendance/views/pages/result_page.dart';
import 'package:attendance/views/widgets/navbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<Widget> pages = [HomePage(), ResultPage(), ProfilePage()];

class WidgetTree extends StatelessWidget {
  const WidgetTree({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Aura Tracker'),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Theme mode',
            onPressed: () async {
              isDarkModeNotifier.value = !isDarkModeNotifier.value;

              SharedPreferencesAsync prefs = SharedPreferencesAsync();
              await prefs.setBool(
                KConstants.themeKey,
                isDarkModeNotifier.value,
              );
            },
            icon: ValueListenableBuilder(
              valueListenable: isDarkModeNotifier,
              builder: (context, isDarkMode, child) {
                return Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode);
              },
            ),
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: selectedPageNotifier,
        builder: (context, selectedPage, child) {
          return pages.elementAt(selectedPage);
        },
      ),
      floatingActionButton: ValueListenableBuilder(
        valueListenable: selectedPageNotifier,
        builder: (context, value, child) {
          return Visibility(
            visible: selectedPageNotifier.value == 0 ? true : false,
            child: FloatingActionButton(
              tooltip: 'Add entry',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return AddAttendancePage();
                    },
                  ),
                );
                // showDialog(
                //   context: context,
                //   builder: (context) {
                //     return AlertDialog(
                //       title: Text('This is title'),
                //       content: Text('This is an Alert Dialog'),
                //       actions: [
                //         TextButton(
                //           onPressed: () {
                //             Navigator.pop(context);
                //           },
                //           child: Text('Close'),
                //         ),
                //         FilledButton(onPressed: () {}, child: Text('Accept')),
                //       ],
                //     );
                //   },
                // );
              },
              child: Icon(Icons.add),
            ),
          );
        },
      ),
      bottomNavigationBar: NavbarWidget(),
    );
  }
}
