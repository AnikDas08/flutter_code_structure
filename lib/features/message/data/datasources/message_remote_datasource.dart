import 'package:flutter_code_structure/config/api/api_end_point.dart';
import 'package:flutter_code_structure/services/api/api_service.dart';
import '../models/chat_list_model.dart';
import '../models/message_model.dart';

abstract class MessageRemoteDataSource {
  Future<List<ChatModel>> getChats({required int page});
  Future<List<MessageModel>> getMessages({
    required String chatId,
    required int page,
    int limit = 15,
  });
}

class MessageRemoteDataSourceImpl implements MessageRemoteDataSource {
  @override
  Future<List<ChatModel>> getChats({required int page}) async {
    final response = await ApiService.get('${ApiEndPoint.chats}?page=$page');

    if (response.statusCode != 200) {
      throw Exception(response.message);
    }

    final List<dynamic> data = response.data['chats'] ?? [];
    return data.map((e) => ChatModel.fromJson(e)).toList();
  }

  @override
  Future<List<MessageModel>> getMessages({
    required String chatId,
    required int page,
    int limit = 15,
  }) async {
    final response = await ApiService.get(
      '${ApiEndPoint.messages}?chatId=$chatId&page=$page&limit=$limit',
    );

    if (response.statusCode != 200) {
      throw Exception(response.message);
    }

    final Map<String, dynamic> data = response.data['data'] ?? {};
    final Map<String, dynamic> attributes = data['attributes'] ?? {};
    final List<dynamic> rawMessages = attributes['messages'] ?? [];

    return rawMessages.map((e) => MessageModel.fromJson(e)).toList();
  }
}
