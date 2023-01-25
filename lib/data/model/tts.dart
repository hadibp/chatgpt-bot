import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeech {
  static FlutterTts tts = FlutterTts();

  static initTTS() {
    tts.setLanguage("en_US");
    tts.setPitch(1.0);
    // tts.setSpeechRate(0.5);
  }

  static speak(String text) async {
    await tts.awaitSpeakCompletion(true);
    tts.speak(text);
  }
}
