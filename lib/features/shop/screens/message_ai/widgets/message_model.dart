class MessageModel {
  final String content;
  final bool isBot;
  final DateTime timestamp;
  final String id;
  MessageModel({
    required this.content,
     this.isBot = false,
    required this.timestamp,
    required this.id,
});


}