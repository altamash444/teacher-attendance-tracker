import 'package:flutter/material.dart';

Future<String?> carouselPickerWidget({
  required BuildContext context,
  required String title,
  required List<String> items,
  int initialIndex = 0,
}) async {
  int selectedIndex = initialIndex;
  final controller = FixedExtentScrollController(initialItem: initialIndex);

  return showDialog<String>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: SizedBox(
          height: 150,
          child: ListWheelScrollView(
            controller: controller,
            itemExtent: 30,
            useMagnifier: true,
            magnification: 1.3,
            diameterRatio: 1.5,
            physics: FixedExtentScrollPhysics(),
            onSelectedItemChanged: (i) => selectedIndex = i,
            children: items.map((item) => Text(item)).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, items[selectedIndex]),
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}
