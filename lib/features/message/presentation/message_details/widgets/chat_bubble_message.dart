import 'package:flutter/material.dart';
import 'package:flutter_code_structure/component/image/common_image.dart';
import 'package:flutter_code_structure/component/text/common_text.dart';
import 'package:flutter_code_structure/utils/constants/app_colors.dart';
import 'package:flutter_code_structure/utils/extensions/extension.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ChatBubbleMessage extends StatelessWidget {
  final DateTime time;
  final String text;
  final String image;
  final bool isMe;
  final VoidCallback onTap;

  const ChatBubbleMessage({
    super.key,
    required this.time,
    required this.text,
    required this.image,
    required this.isMe,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bubbleColor = isMe ? AppColors.primaryColor : AppColors.white;
    final textColor = isMe ? AppColors.white : AppColors.black;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 12.w),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe)
            Padding(
              padding: EdgeInsets.only(right: 8.w),
              child: CommonImage(imageSrc: image, size: 36),
            ),
          Flexible(
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                constraints: BoxConstraints(maxWidth: Get.width * .7),
                decoration: BoxDecoration(
                  color: bubbleColor,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonText(text: text, color: textColor),
                    4.height,
                    Align(
                      alignment: Alignment.bottomRight,
                      child: CommonText(
                        text:
                            '${time.hour}:${time.minute.toString().padLeft(2, '0')}',
                        fontSize: 10,
                        color: textColor.withValues(alpha: .7),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
