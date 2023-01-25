// ignore_for_file: public_member_api_docs, sort_constructors_first
enum ChatMessageType { user, wiki }

class ChatMessage {
  ChatMessage({required String this.text, required this.type});

  String? text;
  ChatMessageType? type;
}
