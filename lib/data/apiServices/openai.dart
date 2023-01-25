import 'dart:convert';

import 'package:http/http.dart' as http;

class OpenApiService {
  static const String mykey =
      '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';
  static const String hadiskey =
      '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';
  static String baseURL = 'https://api.openai.com/v1/completions';
  static bool isLoading = false;
  static Map<String, String> header = {
    "Content-Type": "application/json; charset=UTF-8",
    "Authorization": "Bearer $hadiskey"
  };

  static sendMessage(String? message) async {
    isLoading = true;

    http.Response res = await http.post(Uri.parse(baseURL),
        headers: header,
        body: jsonEncode({
          "model": "text-davinci-003",
          "prompt": "$message",
          "max_tokens": 100,
          "temperature": 0,
          "top_p": 1,
          "frequency_penalty": 0.0,
          "presence_penalty": 0.0,
          "stop": ["Human:", "AI:"]
        }));


    print('status code ${res.statusCode}');
    if (res.statusCode == 200) {
      var data = jsonDecode(res.body.toString());
      var message = data['choices'][0]['text'];
    isLoading = false;

      return message;
    }
    if (res.statusCode == 429) {
      String errormessage =
          'too many requsts.. so the bot is bussy. please try after some time';
      return errormessage;
    } else {
      print('faild to fetch');
    }
  }
}
