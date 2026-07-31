import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_code_structure/features/message/data/models/chat_message_model.dart';
import 'package:flutter_code_structure/features/message/data/repositories/message_repository_impl.dart';
import 'package:flutter_code_structure/features/message/domain/repositories/message_repository.dart';
import 'package:flutter_code_structure/services/socket/socket_service.dart';
import 'package:flutter_code_structure/services/storage/storage_services.dart';
import 'package:flutter_code_structure/utils/app_snackbar.dart';
import 'package:flutter_code_structure/utils/enum/enum.dart';
import 'package:flutter_code_structure/utils/log/error_log.dart';
import 'package:get/get.dart';

class MessageController extends GetxController {
  final MessageRepository _messageRepository;

  MessageController({MessageRepository? messageRepository})
      : _messageRepository = messageRepository ?? MessageRepositoryImpl();

  static MessageController get instance => Get.find<MessageController>();

  Status status = Status.completed;
  bool isLoading = false;
  bool isMoreLoading = false;
  String chatId = '';
  String name = '';
  int page = 1;
  bool isInputField = false;
  int currentIndex = 0;
  final List<ChatMessageModel> messages = [];

  final ScrollController scrollController = ScrollController();
  final TextEditingController messageController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent) {
      loadMoreMessages();
    }
  }

  Future<void> getMessages() async {
    try {
      if (page == 1) {
        messages.clear();
        status = Status.loading;
        update();
      }

      final messageEntities = await _messageRepository.getMessages(
        chatId: chatId,
        page: page,
        limit: 15,
      );

      final newMessages = messageEntities
          .map(
            (e) => ChatMessageModel(
              time: e.createdAt.toLocal(),
              text: e.text,
              image: e.senderImage,
              isNotice: e.isNotice,
              isMe: LocalStorage.user!.id == e.senderId,
            ),
          )
          .toList();

      messages.addAll(newMessages);

      page++;
      status = Status.completed;
    } catch (e) {
      status = Status.error;
      AppSnackbar.error(title: 'Error', message: e.toString());
    } finally {
      update();
    }
  }

  Future<void> loadMoreMessages() async {
    if (isMoreLoading || status == Status.loading) return;
    try {
      isMoreLoading = true;
      update();
      await getMessages();
    } catch (e) {
      errorLog(e.toString());
    } finally {
      isMoreLoading = false;
      update();
    }
  }

  Future<void> sendMessage() async {
    final text = messageController.text.trim();
    if (text.isEmpty) return;

    messages.insert(
      0,
      ChatMessageModel(
        time: DateTime.now(),
        text: text,
        image: LocalStorage.user!.image,
        isMe: true,
      ),
    );

    update();

    _messageRepository.sendMessage(
      chatId: chatId,
      text: text,
      senderId: LocalStorage.user!.id,
    );

    messageController.clear();
  }

  void listenMessage(String chatId) {
    SocketService.on('new-message::$chatId', (data) {
      final text = data['message'] ?? '';
      final senderImage = data['sender']?['image'] ?? '';
      final isNotice = data['type'] == 'notice';

      messages.insert(
        0,
        ChatMessageModel(
          time: DateTime.now(),
          text: text,
          image: senderImage,
          isNotice: isNotice,
          isMe: false,
        ),
      );

      update();
    });
  }

  void toggleInput(int index) {
    currentIndex = index;
    isInputField = !isInputField;
    update();
  }

  @override
  Future<void> refresh() async {
    page = 1;
    await getMessages();
  }

  @override
  void onClose() {
    scrollController.dispose();
    messageController.dispose();
    super.onClose();
  }
}
