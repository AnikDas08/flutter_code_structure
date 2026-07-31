import 'package:flutter_code_structure/services/socket/socket_service.dart';

import '../../domain/entities/chat_entity.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/repositories/message_repository.dart';
import '../datasources/message_remote_datasource.dart';

class MessageRepositoryImpl implements MessageRepository {
  final MessageRemoteDataSource remoteDataSource;

  MessageRepositoryImpl({MessageRemoteDataSource? remoteDataSource})
      : remoteDataSource = remoteDataSource ?? MessageRemoteDataSourceImpl();

  @override
  Future<List<ChatEntity>> getChats({required int page}) async {
    final chatModels = await remoteDataSource.getChats(page: page);
    return chatModels
        .map(
          (model) => ChatEntity(
            id: model.id,
            participantId: model.participant.id,
            participantName: model.participant.fullName,
            participantImage: model.participant.image,
            latestMessage: model.latestMessage.message,
            latestMessageTime: model.latestMessage.createdAt,
          ),
        )
        .toList();
  }

  @override
  Future<List<MessageEntity>> getMessages({
    required String chatId,
    required int page,
    int limit = 15,
  }) async {
    final messageModels = await remoteDataSource.getMessages(
      chatId: chatId,
      page: page,
      limit: limit,
    );

    return messageModels
        .map(
          (model) => MessageEntity(
            id: model.id,
            chatId: model.chat,
            text: model.message,
            type: model.type,
            senderId: model.sender.id,
            senderName: model.sender.fullName,
            senderImage: model.sender.image,
            createdAt: model.createdAt,
            isMe: false,
            isNotice: model.type == 'notice',
          ),
        )
        .toList();
  }

  @override
  void sendMessage({
    required String chatId,
    required String text,
    required String senderId,
  }) {
    final body = {
      'chat': chatId,
      'message': text,
      'sender': senderId,
    };
    SocketService.emitWithAck('add-new-message', body, (data) {});
  }
}
