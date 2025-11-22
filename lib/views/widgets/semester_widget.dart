import 'package:flutter/material.dart';

class SemesterWidget extends StatelessWidget {
  const SemesterWidget({super.key, required this.icon, required this.title});

  final Widget icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      width: MediaQuery.of(context).size.width / 2.3,
      child: Card.outlined(
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: SizedBox(
                width: double.infinity,
                child: Card.filled(
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: icon,
                  ),
                ),
              ),
            ),
            Flexible(child: Center(child: Text(title))),
          ],
        ),
      ),
    );
  }
}
