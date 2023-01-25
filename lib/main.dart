import 'package:chat_gpt/data/model/tts.dart';
import 'package:chat_gpt/presentation/screens/home.dart';
import 'package:chat_gpt/presentation/screens/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

void main() {
    WidgetsFlutterBinding.ensureInitialized();
  TextToSpeech.initTTS();
  runApp(
     MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: SplashScreen(),
    );
  }
}