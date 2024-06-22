import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_12_project_ai/SignInUpScreen.dart';
import 'package:flutter_application_12_project_ai/app/modules/base/views/fetch.dart';
import 'package:flutter_application_12_project_ai/app/modules/cart/controllers/cart_controller.dart';
import 'package:flutter_application_12_project_ai/app/modules/home/views/home_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'app/data/local/my_shared_pref.dart';
import 'app/routes/app_pages.dart';
import 'config/theme/my_theme.dart';
import 'config/translations/localization_service.dart';
import 'firebase_service.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ControlsService.fetchDataAndStore();
  MobileAds.instance.initialize();

  // Initialize Firebase
  await FirebaseService.initializeFirebase();
  

  // Init shared preference
  await MySharedPref.init();

        User? user = FirebaseAuth.instance.currentUser;
        if(user?.uid!=null){
 try {
  var documentSnapshot =
      await FirebaseFirestore.instance.collection('users').doc(user?.uid).get();
  print('snapo ${documentSnapshot.data()}');


    if (documentSnapshot.exists) {
      String address = documentSnapshot.data()?['address'];
      String result = address != null ? address.toString() : 'No Address';
      
      print('here is a fuunction and here is result $result');

      // Send the address to the HomeView class
      HomeView.updateAddress(result);
      CartController.updateAddress1(result);
    } else {
      ('Document does not exist');

      // Send a default message to the HomeView class
      HomeView.updateAddress('Document does not exist');
      CartController.updateAddress1('Document does not exist');
    }

   } 
   catch (e) {
  print('Error fetching document: $e');
} // Initialize Firebase Cloud Messaging
  await initFirebaseMessaging();
        }
  runApp(
    ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      useInheritedMediaQuery: true,
      rebuildFactor: (old, data) => true,
      builder: (context, widget) {
        return GetMaterialApp(
          title: "Grocery App",
          useInheritedMediaQuery: true,
          debugShowCheckedModeBanner: false,
          builder: (context, widget) {
            bool themeIsLight = MySharedPref.getThemeIsLight();
            return Theme(
              data: MyTheme.getThemeData(isLight: themeIsLight),
              child: MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                child: widget!,
              ),
            );
          },
          initialRoute: AppPages.INITIAL,
          getPages: AppPages.routes,
          locale: MySharedPref.getCurrentLocal(),
          translations: LocalizationService.getInstance(),
        );
      },
    ),
  );
}

Future<void> initFirebaseMessaging() async {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // Enable auto-init
  await _firebaseMessaging.setAutoInitEnabled(true);

  _firebaseMessaging.onTokenRefresh.listen((String? fcmToken) async {
    // Handle token refresh here, e.g., send the new token to your server
    print("FCM Token Refreshed: $fcmToken");
  }).onError((err) {
    // Handle error getting token
    print("Error getting FCM Token: $err");
  });

  // Request permission with provisional set to true
  final notificationSettings = await _firebaseMessaging
      .requestPermission(provisional: true);

  // Ensure the APNS token is available before making any FCM plugin API calls
  final apnsToken = await _firebaseMessaging.getAPNSToken();
  if (apnsToken != null) {
    // APNS token is available, make FCM plugin API requests...
    print("APNS Token: $apnsToken");
  }
}
