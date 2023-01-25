
import 'package:chat_gpt/data/constants/colorconstants.dart';
import 'package:chat_gpt/data/model/chatmodel.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget chatBubble(
    {required BuildContext context,
    required chattext,
    required ChatMessageType? type}) {
  return Row(
    textDirection:
        type == ChatMessageType.wiki ? TextDirection.ltr : TextDirection.rtl,
    children: [
       CircleAvatar(
        backgroundColor: Colors.white,
        backgroundImage: type == ChatMessageType.wiki? AssetImage('assets/images/bot.png') :AssetImage('assets/images/manbot.png'),
        child: Icon(
          Icons.person,
          color: Colors.white,
        ),
      ),
      Container(
        width: MediaQuery.of(context).size.width - 90,
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
            color: type == ChatMessageType.user
                ? ColorConstants.seconderycolor
                : ColorConstants.maincolor,
            borderRadius: BorderRadius.only(
              topLeft: type == ChatMessageType.wiki
                    ? const Radius.circular(0)
                    : const Radius.circular(12),
                topRight: type == ChatMessageType.wiki
                    ? const Radius.circular(12)
                    : const Radius.circular(0),
                bottomLeft: const Radius.circular(12),
                bottomRight: const Radius.circular(12))),
        child: Text(
          chattext,
          softWrap: true,
          style: GoogleFonts.roboto(textStyle:TextStyle(
              color:type  == ChatMessageType.wiki? Colors.white:Colors.black, fontSize: 15.0, fontWeight: FontWeight.w400),
        )),
      ),
    ],
  );
}
