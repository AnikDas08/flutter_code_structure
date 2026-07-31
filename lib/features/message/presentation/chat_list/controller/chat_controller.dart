import 'package:flutter/material.dart';
import 'package:flutter_code_structure/features/message/data/models/chat_list_model.dart';
import 'package:flutter_code_structure/features/message/data/repositories/message_repository_impl.dart';
import 'package:flutter_code_structure/features/message/domain/repositories/message_repository.dart';
import 'package:flutter_code_structure/services/socket/socket_service.dart';
import 'package:flutter_code_structure/services/storage/storage_services.dart';
import 'package:flutter_code_structure/utils/app_snackbar.dart';
import 'package:flutter_code_structure/utils/enum/enum.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  final MessageRepository _messageRepository;

  ChatController({MessageRepository? messageRepository})
      : _messageRepository = messageRepository ?? MessageRepositoryImpl();

  Status status = Status.completed;
  bool isMoreLoading = false;
  int page = 1;
  final List<ChatModel> chats = [];

  final ScrollController scrollController = ScrollController();

  static ChatController get instance => Get.find<ChatController>();

  @override
  void onInit() {
    super.onInit();
    getChats();
    listenChat();
    scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent) {
      moreChats();
    }
  }

  Future<void> moreChats() async {
    if (isMoreLoading || status == Status.loading) return;

    try {
      isMoreLoading = true;
      update();
      await getChats();
    } finally {
      isMoreLoading = false;
      update();
    }
  }

  Future<void> getChats() async {
    return;
    try {
      if (page == 1) {
        status = Status.loading;
        update();
      }

      final chatEntities = await _messageRepository.getChats(page: page);
      final newChats = chatEntities
          .map(
            (e) => ChatModel(
              id: e.id,
              participant: Participant(
                id: e.participantId,
                fullName: e.participantName,
                image: e.participantImage,
              ),
              latestMessage: LatestMessage(
                id: '',
                message: e.latestMessage,
                createdAt: e.latestMessageTime,
              ),
            ),
          )
          .toList();

      chats.addAll(newChats);
      page++;
      status = Status.completed;
    } catch (e) {
      status = Status.error;
      AppSnackbar.error(title: 'Error', message: e.toString());
    } finally {
      update();
    }
  }

  void listenChat() {
    final userId = LocalStorage.user!.id;
    SocketService.on('update-chatlist::$userId', (data) {
      page = 1;
      chats.clear();
      final List<dynamic> list = data ?? [];
      chats.addAll(list.map((e) => ChatModel.fromJson(e)).toList());
      status = Status.completed;
      update();
    });
  }

  Future<void> refreshChats() async {
    page = 1;
    chats.clear();
    await getChats();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
