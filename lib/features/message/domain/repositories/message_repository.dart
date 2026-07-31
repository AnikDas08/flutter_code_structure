import '../entities/chat_entity.dart';
import '../entities/message_entity.dart';

abstract class MessageRepository {
  Future<List<ChatEntity>> getChats({required int page});
  Future<List<MessageEntity>> getMessages({
    required String chatId,
    required int page,
    int limit = 15,
  });
  void sendMessage({
    required String chatId,
    required String text,
    required String senderId,
  });
}
