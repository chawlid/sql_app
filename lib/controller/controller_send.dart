import 'package:get/get.dart';
import 'package:notification_crypto_coins/helper/helpers.dart';
import 'package:notification_crypto_coins/main.dart';

class ControllerSend extends GetxController {
  bool SendNotif = false;
  bool pressStop = false;
  @override
  Future<void> onInit() async {
    super.onInit();

    SendNotif = await chechStartApi(tokenGlobale);
    update();
  }

  changeBar() {
    update();
  }

  sendStart() async {
    SendNotif = await chechStartApi(tokenGlobale);

    if (SendNotif == true) {
      print('sendStart=>$SendNotif');
      update();
    }
  }

  sendStop() async {
    SendNotif = await chechStartApi(tokenGlobale);
    if (SendNotif == false) {
      pressStop = false;
      print('sendStop=>$SendNotif');
      update();
    }
  }

  waitStop() async {
    pressStop = true;
    print('waitStop=>$pressStop');
    update();
  }
}
