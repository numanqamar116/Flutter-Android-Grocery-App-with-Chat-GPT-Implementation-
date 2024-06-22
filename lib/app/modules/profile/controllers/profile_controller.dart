import 'package:flutter_application_12_project_ai/SignInUpScreen.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileController extends GetxController {
  FirebaseAuth _auth = FirebaseAuth.instance;

 Future<void> logout() async {
    await _auth.signOut();
    Get.off(SignInUpScreen()); 
  }
}
