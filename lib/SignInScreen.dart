// // Import your SignUpScreen file here
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_application_12_project_ai/SignInUpScreen.dart';
// import 'package:flutter_application_12_project_ai/app/modules/welcome/views/welcome_view.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:lottie/lottie.dart';

// class SignInScreen extends StatelessWidget {
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//   Future<void> signIn(BuildContext context) async {
//     if (_formKey.currentState?.validate() ?? false) {
//       try {
//         // Implement your authentication logic here
//         // Example: Firebase Authentication
//         await FirebaseAuth.instance.signInWithEmailAndPassword(
//           email: emailController.text,
//           password: passwordController.text,
//         );

//         // Navigate to WelcomeView on successful sign-in
//        Get.offAll(WelcomeView());
//       } catch (e) {
//         print('Error during sign-in: $e');
//         // Handle sign-in error
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//      return WillPopScope(
//       onWillPop: () async {
//         // Return false to intercept the back operation
//         return false;
//       } ,
//     child: Scaffold(
//       appBar: AppBar(
//         title: Text('Sign In'),
//         backgroundColor: Colors.green,
        
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Lottie.asset('assets/images/Animation.json'),
//                 TextFormField(
//                   controller: emailController,
//                   decoration: const InputDecoration(
//                     labelText: 'Email',
//                     labelStyle: TextStyle(
//                         color: Color.fromARGB(117, 76, 175, 79)),
//                     border: OutlineInputBorder(),
//                     focusedBorder: OutlineInputBorder(
//                       borderSide: BorderSide(color: Colors.green),
//                     ),
//                     prefixIcon: Icon(
//                       Icons.email,
//                       color: Colors.green,
//                     ),
//                   ),
//                   validator: (value) {
//                     if (value?.isEmpty ?? true) {
//                       return 'Please enter your email';
//                     } else if (!RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$")
//                         .hasMatch(value!)) {
//                       return 'Invalid email format';
//                     }
//                     return null;
//                   },
//                 ),
//                 SizedBox(height: 30),
//                 TextFormField(
//                   controller: passwordController,
//                   decoration: const InputDecoration(
//                     labelText: 'Password',
//                     labelStyle: TextStyle(
//                         color: Color.fromARGB(117, 76, 175, 79)),
//                     border: OutlineInputBorder(),
//                     focusedBorder: OutlineInputBorder(
//                       borderSide: BorderSide(color: Colors.green),
//                     ),
//                     prefixIcon: Icon(
//                       Icons.key,
//                       color: Colors.green,
//                     ),
//                   ),
//                   obscureText: true,
//                   validator: (value) {
//                     if (value?.isEmpty ?? true) {
//                       return 'Please enter your password';
//                     } else if (value!.length < 6) {
//                       return 'Password must be at least 6 characters';
//                     }
//                     return null;
//                   },
//                 ),
//                 SizedBox(height: 20),
//                 ElevatedButton(
//                   style: ButtonStyle(
//                     backgroundColor:
//                         MaterialStateProperty.all<Color>(Colors.green),
//                     shape: MaterialStateProperty.all<OutlinedBorder>(
//                       RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(30.0),
//                       ),
//                     ),
//                     minimumSize: MaterialStateProperty.all<Size>(
//                       Size(200.0, 60.0),
//                     ),
//                   ),
//                   onPressed: () => signIn(context),
//                   child: Text(
//                     'Sign In',
//                     style: TextStyle(fontSize: 20, color: Colors.white),
//                   ),
//                 ),
//                 SizedBox(height: 10),
//                 TextButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => SignUpScreen()),
//                     );
//                   },
//                   child: Text(
//                     'Don\'t have an account? Sign Up',
//                     style: TextStyle(
//                         color: Colors.green,
//                         decoration: TextDecoration.underline),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     ));
//   }
// }
