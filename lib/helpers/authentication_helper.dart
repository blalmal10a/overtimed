import 'package:get/get.dart';
import '/controllers/user_authentication.dart';

RxBool is_authenticated = false.obs;

Future attemptAuh() async {
  try {
    authenticateUser();
  } catch (e) {
    //
  }
}
