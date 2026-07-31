import 'package:flutter/material.dart';
import 'package:flutter_code_structure/component/image/common_image.dart';
import 'package:flutter_code_structure/component/text/common_text.dart';
import 'package:flutter_code_structure/component/text_field/common_text_field.dart';
import 'package:flutter_code_structure/features/message/data/models/chat_message_model.dart';
import 'package:flutter_code_structure/utils/constants/app_string.dart';
import 'package:flutter_code_structure/utils/extensions/extension.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controller/message_controller.dart';
import '../widgets/chat_bubble_message.dart';

class MessageScreen extends StatelessWidget {
  const MessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MessageController>(
      init: MessageController(),
      initState: (_) {
        final controller = MessageController.instance;
        final params = Get.parameters;
        controller.chatId = params['chatId'] ?? '';
        controller.name = params['name'] ?? '';
        controller.listenMessage(controller.chatId);
        controller.getMessages();
      },
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            titleSpacing: 0,
            title: Row(
              children: [
                CircleAvatar(
                  radius: 24.sp,
                  backgroundColor: Colors.transparent,
                  child: ClipOval(
                    child: CommonImage(
                      imageSrc: Get.parameters['image'] ?? '',
                      size: 48,
                    ),
                  ),
                ),
                12.width,
                CommonText(
                  text: controller.name,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ],
            ),
          ),
          body: controller.isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  reverse: true,
                  controller: controller.scrollController,
                  itemCount: controller.isMoreLoading
                      ? controller.messages.length + 1
                      : controller.messages.length,
                  itemBuilder: (_, index) {
                    if (index >= controller.messages.length) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final ChatMessageModel message = controller.messages[index];

                    return ChatBubbleMessage(
                      image: message.image,
                      time: message.time,
                      text: message.text,
                      isMe: message.isMe,
                      onTap: () {},
                    );
                  },
                ),
          bottomNavigationBar: AnimatedPadding(
            padding: MediaQuery.of(context).viewInsets,
            duration: const Duration(milliseconds: 150),
            child: Padding(
              padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 24.h),
              child: CommonTextField(
                controller: controller.messageController,
                hintText: AppString.messageHere,
                borderColor: Colors.white,
                borderRadius: 8,
                suffixIcon: GestureDetector(
                  onTap: controller.sendMessage,
                  child: Padding(
                    padding: EdgeInsets.all(16.sp),
                    child: const Icon(Icons.send),
                  ),
                ),
                onSubmitted: (_) => controller.sendMessage(),
              ),
            ),
          ),
        );
      },
    );
  }
}
