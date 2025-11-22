import 'package:attendance/views/data/notifiers.dart';
import 'package:attendance/views/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: FractionallySizedBox(
              widthFactor: MediaQuery.of(context).size.width > 500 ? 0.4 : 1.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset('assets/lotties/loading.json', height: 300),
                  FittedBox(
                    child: Text(
                      'Altamash Khan',
                      style: TextStyle(
                        fontSize: 50,
                        letterSpacing: 50,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  FilledButton(
                    onPressed: () {
                      selectedPageNotifier.value = 0;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return LoginPage(title: 'Register');
                          },
                        ),
                      );
                    },
                    style: FilledButton.styleFrom(
                      minimumSize: Size(double.infinity, 40),
                    ),
                    child: Text('Get Started'),
                  ),
                  TextButton(
                    onPressed: () {
                      selectedPageNotifier.value = 0;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return LoginPage(title: 'Login');
                          },
                        ),
                      );
                    },
                    style: FilledButton.styleFrom(
                      minimumSize: Size(double.infinity, 40),
                    ),
                    child: Text('Login'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
