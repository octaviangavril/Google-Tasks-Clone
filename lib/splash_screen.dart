import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String textToShow ='';
  String cloneWord = '';

  @override
  void initState() {
    super.initState();
  delayedActions();
  }

  void delayedActions() async {
    await Future.delayed(const Duration(seconds: 1), () {
      typeWritingAnimation();
    });
    Future.delayed(const Duration(seconds: 6), () {
      Navigator.pushReplacementNamed(context, '/home');
    });
  }

  void typeWritingAnimation(){
    String text = 'Welcome to Google Tasks ';
    for(int i = 0; i < text.length; i++){
      Future.delayed(Duration(milliseconds: 100 * i), (){
        setState(() {
          textToShow += text[i];
        });
      });
    }

    String cloneText = 'CLONE';
    for(int i = 0; i < cloneText.length; i++){
      Future.delayed(Duration(milliseconds: 100 * (i + text.length) + 800), (){
        setState(() {
          cloneWord += cloneText[i];
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/google-tasks-logo.png'),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(textToShow,
                    style: const TextStyle(fontSize: 20,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold)
                ),
                Text(cloneWord,
                    style: const TextStyle(
                        fontSize: 20,
                        fontFamily: 'Roboto',
                        color: Colors.blue,
                        fontWeight: FontWeight.bold)
                ),
              ],
            ),
          ],
        )
      ),
    );
  }
}