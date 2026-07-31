class ChatEntity {
  final String id;
  final String participantId;
  final String participantName;
  final String participantImage;
  final String latestMessage;
  final DateTime latestMessageTime;

  const ChatEntity({
    required this.id,
    required this.participantId,
    required this.participantName,
    required this.participantImage,
    required this.latestMessage,
    required this.latestMessageTime,
  });
}
