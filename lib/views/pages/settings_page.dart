import 'dart:developer';

import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  TextEditingController controller = TextEditingController();
  bool? onChecked = false;
  bool isSwitched = false;
  double sliderValue = 0.4;
  String? menuName = 'e1';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              DropdownButton(
                value: menuName,
                items: [
                  DropdownMenuItem(value: 'e1', child: Text('Element 1')),
                  DropdownMenuItem(value: 'e2', child: Text('Element 2')),
                  DropdownMenuItem(value: 'e3', child: Text('Element 3')),
                ],
                onChanged: (value) {
                  setState(() {
                    menuName = value;
                  });
                },
              ),
              TextField(
                decoration: InputDecoration(border: OutlineInputBorder()),
                controller: controller,
                onEditingComplete: () {
                  setState(() {});
                },
              ),
              Text(controller.text),
              Checkbox(
                value: onChecked,
                onChanged: (bool? value) {
                  setState(() {
                    onChecked = value;
                  });
                },
              ),
              Divider(),
              VerticalDivider(),
              CheckboxListTile(
                title: Text("Checkbox here, click to toggle it."),
                value: onChecked,
                onChanged: (bool? value) {
                  setState(() {
                    onChecked = value;
                  });
                },
              ),
              Switch(
                value: isSwitched,
                onChanged: (value) {
                  setState(() {
                    isSwitched = value;
                  });
                },
              ),
              SwitchListTile.adaptive(
                title: Text('Here is a switch.'),
                value: isSwitched,
                onChanged: (value) {
                  setState(() {
                    isSwitched = value;
                  });
                },
              ),
              Slider(
                value: sliderValue,
                onChanged: (value) {
                  setState(() {
                    sliderValue = value;
                  });
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  showModalBottomSheet(
                    scrollControlDisabledMaxHeightRatio: 0.2,
                    showDragHandle: true,
                    context: context,
                    builder: (context) {
                      return StatefulBuilder(
                        builder: (context, setState) {
                          return Slider(
                            value: sliderValue,
                            onChanged: (value) {
                              setState(() {
                                sliderValue = value;
                              });
                            },
                          );
                        },
                      );
                    },
                  );
                },
                child: Text('Bottom Sheet'),
              ),
              ElevatedButton(onPressed: () {}, child: Text('Click me')),
              FilledButton(onPressed: () {}, child: Text('Click me')),
              TextButton(onPressed: () {}, child: Text('Click me')),
              OutlinedButton(onPressed: () {}, child: Text('Click me')),
              CloseButton(),
              BackButton(),
              IconButton(onPressed: () {}, icon: Icon(Icons.abc)),
              DrawerButton(),
              Image.asset('assets/images/pajor.png'),
              InkWell(
                splashColor: Colors.teal,
                onTap: () {
                  log("image tapped");
                },
                child: Container(
                  height: 50,
                  width: double.infinity,
                  color: Colors.white12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
