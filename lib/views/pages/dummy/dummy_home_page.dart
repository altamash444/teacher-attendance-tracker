import 'package:flutter/material.dart';

class DummyHomePage extends StatelessWidget {
  const DummyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        spacing: 8,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: ColoredBox(
              color: Colors.grey.shade800,
              child: SizedBox(width: double.infinity, height: 120),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0, bottom: 10),
            child: ColoredBox(
              color: Colors.grey.shade800,
              child: SizedBox(width: double.infinity, height: 40),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 25),
            child: ColoredBox(
              color: Colors.grey.shade800,
              child: SizedBox(width: double.infinity, height: 80),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 25),
            child: ColoredBox(
              color: Colors.grey.shade800,
              child: SizedBox(width: double.infinity, height: 80),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 25),
            child: ColoredBox(
              color: Colors.grey.shade800,
              child: SizedBox(width: double.infinity, height: 80),
            ),
          ),
        ],
      ),
    );
  }
}
