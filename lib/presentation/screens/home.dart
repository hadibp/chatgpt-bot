import 'package:avatar_glow/avatar_glow.dart';
import 'package:chat_gpt/data/apiServices/openai.dart';
import 'package:chat_gpt/data/constants/colorconstants.dart';
import 'package:chat_gpt/data/model/chatmodel.dart';
import 'package:chat_gpt/data/model/tts.dart';
import 'package:chat_gpt/presentation/componants/app_chatbubbule.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:speech_to_text/speech_to_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  OpenApiService openai = OpenApiService();

  final List<ChatMessage> messages = [];

  String voicetext = '';
  TextEditingController controller = TextEditingController();
  ScrollController scrolcontroller = ScrollController();
  SpeechToText speechToText = SpeechToText();
  bool isListening = false;

  scrollmethod() {
    scrolcontroller.animateTo(scrolcontroller.position.maxScrollExtent,
        duration: const Duration(microseconds: 300), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //  backgroundColor: ColorConstants.seconderycolor,
      appBar: AppBar(
        backgroundColor: ColorConstants.maincolor,
        title: Text(
          'My Bot',
          style: GoogleFonts.lobster(
              textStyle: const TextStyle(color: Colors.white, fontSize: 28)),
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
                itemCount: messages.length,
                physics: const BouncingScrollPhysics(),
                controller: scrolcontroller,
                shrinkWrap: true,
                reverse: true,
                itemBuilder: (BuildContext context, int index) {
                  final ChatMessage chat = messages[messages.length -1-index];
                  return OpenApiService.isLoading
                      ? const CircularProgressIndicator()
                      : chatBubble(
                          context: context,
                          chattext: chat.text,
                          type: chat.type);
                }),
          )),
          isListening
              ? Container(
                  child: chatBubble(
                      context: context,
                      chattext: voicetext,
                      type: ChatMessageType.user),
                )
              : Container(),
          SingleChildScrollView(
            child: Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height / 10 + 25,
                color: ColorConstants.seconderycolor,
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                      margin: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: ColorConstants.thirddarkcolor),
                          borderRadius: BorderRadius.circular(19.0)),
                      child: TextField(
                        controller: controller,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Ask Me Anything...',
                          contentPadding: EdgeInsets.only(
                              left: 15, bottom: 11, top: 11, right: 15),
                        ),
                        scrollPadding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom +
                                MediaQuery.of(context).size.height * 4),
                      ),
                    )),
                    Container(
                        width: 50.0,
                        height: 50.0,
                        margin: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () async {
                            messages.add(ChatMessage(
                                text: controller.value.text,
                                type: ChatMessageType.user));
                            var response = await OpenApiService.sendMessage(
                                controller.value.text);
                            response = response.trim();

                            print('reponse = $response');
                            TextToSpeech.speak(response);
                            setState(() {
                              messages.add(ChatMessage(
                                  text: response, type: ChatMessageType.wiki));
                            });
                            controller.clear();
                          },
                          style: ButtonStyle(
                              backgroundColor: MaterialStateColor.resolveWith(
                                  (states) => ColorConstants.thirddarkcolor)),
                          child: const Icon(
                            Icons.send,
                            color: ColorConstants.seconderycolor,
                          ),
                        )),
                    Container(
                      width: 60.0,
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: AvatarGlow(
                        endRadius: 100.0,
                        animate: isListening,
                        duration: const Duration(microseconds: 2000),
                        repeatPauseDuration: const Duration(microseconds: 00),
                        glowColor: ColorConstants.thirddarkcolor,
                        showTwoGlows: true,
                        repeat: true,
                        child: GestureDetector(
                          onTapDown: (result) async {
                            if (!isListening) {
                              bool isrecording =
                                  await speechToText.initialize();
                              if (isrecording) {
                                print('recording');
                                setState(() {
                                  isListening = true;
                                  speechToText.listen(
                                    onResult: (result) {
                                      setState(() {
                                        voicetext = result.recognizedWords;
                                        print(voicetext);
                                        controller.text = voicetext;
                                      });
                                    },
                                  );
                                });
                              }
                            }
                          },
                          onTapUp: (result) async {
                            print('done');
                            setState(() {
                              isListening = false;
                            });
                            await speechToText.stop();
                            if (voicetext.isNotEmpty) {
                              messages.add(ChatMessage(
                                  text: voicetext, type: ChatMessageType.user));
                              var voiceresponse =
                                  await OpenApiService.sendMessage(voicetext);
                              voiceresponse = voiceresponse.trim();

                              setState(() {
                                messages.add(ChatMessage(
                                    text: voiceresponse,
                                    type: ChatMessageType.wiki));
                              });
                              Future.delayed(const Duration(microseconds: 500),
                                  () {
                                TextToSpeech.speak(voiceresponse);
                              });
                            } else {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'say somthing or unable to process')));
                              }
                            }
                          },
                          child: const CircleAvatar(
                            // radius: 25.0,
                            backgroundColor: ColorConstants.thirddarkcolor,
                            child: Icon(
                              Icons.mic,
                              color: ColorConstants.seconderycolor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }
}
