import 'package:flutter/material.dart';
import 'package:flutter_code_structure/component/bottom_nav_bar/common_bottom_bar.dart';
import 'package:flutter_code_structure/component/other_widgets/common_loader.dart';
import 'package:flutter_code_structure/component/screen/error_screen.dart';
import 'package:flutter_code_structure/component/text/common_text.dart';
import 'package:flutter_code_structure/component/text_field/common_text_field.dart';
import 'package:flutter_code_structure/config/route/app_routes.dart';
import 'package:flutter_code_structure/features/message/data/models/chat_list_model.dart';
import 'package:flutter_code_structure/utils/constants/app_string.dart';
import 'package:flutter_code_structure/utils/enum/enum.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controller/chat_controller.dart';
import '../widgets/chat_list_item.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const CommonText(
          text: AppString.inbox,
          fontWeight: FontWeight.w600,
          fontSize: 24,
        ),
      ),
      body: GetBuilder<ChatController>(
        init: ChatController(),
        builder: (controller) => switch (controller.status) {
          Status.loading => const CommonLoader(),
          Status.error => ErrorScreen(onTap: controller.getChats),
          Status.completed => Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            child: Column(
              children: [
                CommonTextField(
                  prefixIcon: const Icon(Icons.search),
                  hintText: AppString.searchDoctor,
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: controller.refreshChats,
                    child: ListView.builder(
                      padding: EdgeInsets.only(top: 16.h),
                      controller: controller.scrollController,
                      itemCount: controller.chats.length,
                      itemBuilder: (_, index) {
                        final ChatModel item = controller.chats[index];

                        return GestureDetector(
                          onTap: () => Get.toNamed(
                            AppRoutes.message,
                            parameters: {
                              'chatId': item.id,
                              'name': item.participant.fullName,
                              'image': item.participant.image,
                            },
                          ),
                          child: ChatListItem(item: item),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        },
      ),
      bottomNavigationBar: const CommonBottomNavBar(currentIndex: 2),
    );
  }
}
