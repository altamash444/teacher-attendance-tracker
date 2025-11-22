import 'package:attendance/views/widget_tree.dart';
import 'package:attendance/views/widgets/hero_widget.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.title});

  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController controllerEmail = TextEditingController(
    text: 'altamash@gmail.com',
  );
  TextEditingController controllerPW = TextEditingController(
    text: 'my_password',
  );

  @override
  void dispose() {
    controllerEmail.dispose();
    controllerPW.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: FractionallySizedBox(
              widthFactor: MediaQuery.of(context).size.width > 500 ? 0.4 : 1.0,
              child: Column(
                children: [
                  HeroWidget(title: widget.title),
                  SizedBox(height: 20.0),
                  TextField(
                    controller: controllerEmail,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      hintText: 'Email',
                    ),
                    onEditingComplete: () {
                      setState(() {});
                    },
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    controller: controllerPW,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      hintText: 'Password',
                    ),
                    onEditingComplete: () {
                      setState(() {});
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      loginConfirmation();
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 40),
                    ),
                    child: Text(widget.title),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void loginConfirmation() {
    if (controllerEmail.text != '' && controllerPW.text != '') {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) {
            return WidgetTree();
          },
        ),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter details.'),
          showCloseIcon: true,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 1),
        ),
      );
    }
  }
}
