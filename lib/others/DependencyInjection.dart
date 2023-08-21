import 'package:get/get.dart';
import 'package:nmlsalesaccess/others/NetworkController.dart';

class DependencyInjection {

  static void init() {
    Get.put<NetworkController>(NetworkController(),permanent:true);
  }
}