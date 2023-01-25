import 'dart:async';

import 'package:chat_gpt/presentation/screens/home.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('assets/gifs/bot.gif'),
      ),
    );
  }
  void _navigateTo() async {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage()));
    
  }
  startTimer() async => Timer(const Duration(seconds: 3), () => _navigateTo());

}