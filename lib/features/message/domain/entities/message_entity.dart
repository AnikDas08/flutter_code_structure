class MessageEntity {
  final String id;
  final String chatId;
  final String text;
  final String type;
  final String senderId;
  final String senderName;
  final String senderImage;
  final DateTime createdAt;
  final bool isMe;
  final bool isNotice;

  const MessageEntity({
    required this.id,
    required this.chatId,
    required this.text,
    required this.type,
    required this.senderId,
    required this.senderName,
    required this.senderImage,
    required this.createdAt,
    required this.isMe,
    this.isNotice = false,
  });
}
