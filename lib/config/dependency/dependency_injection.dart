import 'package:get/get.dart';

import 'package:flutter_code_structure/features/auth/presentation/change_password/controller/change_password_controller.dart';
import 'package:flutter_code_structure/features/auth/presentation/forgot_password/controller/forget_password_controller.dart';
import 'package:flutter_code_structure/features/auth/presentation/sign_in/controller/sign_in_controller.dart';
import 'package:flutter_code_structure/features/auth/presentation/sign_up/controller/sign_up_controller.dart';
import 'package:flutter_code_structure/features/message/presentation/chat_list/controller/chat_controller.dart';
import 'package:flutter_code_structure/features/message/presentation/message_details/controller/message_controller.dart';
import '../../features/notifications/presentation/controller/notifications_controller.dart';
import '../../features/profile/presentation/controller/profile_controller.dart';
class DependencyInjection extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SignUpController(), fenix: true);
    Get.lazyPut(() => SignInController(), fenix: true);
    Get.lazyPut(() => ForgetPasswordController(), fenix: true);
    Get.lazyPut(() => ChangePasswordController(), fenix: true);
    Get.lazyPut(() => NotificationsController(), fenix: true);
    Get.lazyPut(() => ChatController(), fenix: true);
    Get.lazyPut(() => MessageController(), fenix: true);
    Get.lazyPut(() => ProfileController(), fenix: true);
  }
}
