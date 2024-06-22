// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_application_12_project_ai/app/modules/cart/controllers/cart_controller.dart';
import 'package:flutter_application_12_project_ai/app/modules/home/views/home_view.dart';
import 'package:flutter_application_12_project_ai/app/modules/welcome/views/welcome_view.dart';
import 'package:flutter_application_12_project_ai/utils/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_application_12_project_ai/app/data/local/my_shared_pref.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart';
import 'package:lottie/lottie.dart';

String username = '';

class SignInUpScreen extends StatelessWidget {
  @override
 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else {
            if (snapshot.hasData) {
              // User is logged in
              return WelcomeView();
            } else {
              // No user logged in
              return SignInUpScreenSub();
            }
          }
        },
      ),
    );
  }
}

class SignInUpScreenSub extends StatefulWidget {
  @override
  _SignInUpScreenSubState createState() => _SignInUpScreenSubState();
}

class _SignInUpScreenSubState extends State<SignInUpScreenSub> {
  bool isSigningIn = false;
  bool isSigningUp = false;

  @override
  Widget build(BuildContext context) {
    final isLightTheme = MySharedPref.getThemeIsLight();

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 232, 235, 232),
      body: Center(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                isLightTheme ? Constants.background : Constants.backgroundDark,
              ),
              fit: BoxFit.fitWidth,
            ),
          ),
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 50),
                    CircleAvatar(
                      radius: 55.r,
                      child: Image.asset(Constants.logo,
                          width: 67.w, height: 55.h),
                    ).animate().fade().slideY(
                        duration: 500.ms, begin: 1, curve: Curves.easeInSine),
                    const SizedBox(height: 200),
                    ElevatedButton.icon(
                      onPressed: isSigningIn
                          ? null
                          : () {
                              // Set the flag to indicate signing in is in progress
                              setState(() {
                                isSigningIn = true;
                              });

                              // Simulate a delay (you can replace this with your actual sign-in logic)
                              Future.delayed(Duration(seconds: 2), () {
                                // Reset the flag
                                setState(() {
                                  isSigningIn = false;
                                });

                                // Navigate to the appropriate screen
                              Get.to(()=>SignInScreen());
                              });
                            },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 80.0, vertical: 20.0),
                        backgroundColor: const Color.fromARGB(255, 40, 150, 26),
                      ),
                      icon: isSigningIn
                          ? CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            )
                          : Icon(Icons.login),
                      label: Text(
                        'Sign In',
                        style: TextStyle(
                          color: Color.fromARGB(255, 245, 245, 245),
                          fontSize: 24,
                          fontFamily: 'Roboto',
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: isSigningUp
                          ? null
                          : () {
                              // Set the flag to indicate signing up is in progress
                              setState(() {
                                isSigningUp = true;
                              });

                              // Simulate a delay (you can replace this with your actual sign-up logic)
                              Future.delayed(Duration(seconds: 2), () {
                                // Reset the flag
                                setState(() {
                                  isSigningUp = false;
                                });

                                // Navigate to the appropriate screen
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SignUpScreen(),
                                  ),
                                );
                              });
                            },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 80.0, vertical: 20.0),
                        backgroundColor: Color.fromARGB(255, 40, 150, 26),
                      ),
                      icon: isSigningUp
                          ? CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            )
                          : Icon(Icons.how_to_reg),
                      label: Text(
                        'Sign Up',
                        style: TextStyle(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          fontSize: 22,
                          fontFamily: 'Roboto',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? errorMessage;

  Future<void> signIn(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        // Implement your authentication logic here
        // Example: Firebase Authentication
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        User? user = FirebaseAuth.instance.currentUser;

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
        
        // Navigate to WelcomeView on successful sign-in
        Get.offAll(WelcomeView());
      } catch (e) {
        print('Error during sign-in: $e');
        // Handle sign-in error
        setState(() {
          errorMessage = 'Email or password is invalid';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Return false to intercept the back operation
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          iconTheme: IconThemeData(color: const Color.fromARGB(255, 255, 255, 255)),
          title: Text('Sign In'),
          backgroundColor: Colors.green,
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset('assets/images/Animation.json'),
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(
                        color: Color.fromARGB(117, 76, 175, 79),
                      ),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                      ),
                      prefixIcon: Icon(
                        Icons.email,
                        color: Colors.green,
                      ),
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter your email';
                      } else if (!RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$")
                          .hasMatch(value!)) {
                        return 'Invalid email format';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 30),
                  TextFormField(
                    controller: passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(
                        color: Color.fromARGB(117, 76, 175, 79),
                      ),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                      ),
                      prefixIcon: Icon(
                        Icons.key,
                        color: Colors.green,
                      ),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter your password';
                      } else if (value!.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.green),
                      shape: MaterialStateProperty.all<OutlinedBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      minimumSize: MaterialStateProperty.all<Size>(
                        Size(200.0, 60.0),
                      ),
                    ),
                    onPressed: () => signIn(context),
                    child: Text(
                      'Sign In',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),

                  // Display error message if authentication fails
                  if (errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        errorMessage!,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),

                  SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpScreen()),
                      );
                    },
                    child: Text(
                      'Don\'t have an account? Sign Up',
                      style: TextStyle(
                        color: Colors.green,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


class SignUpScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

 
// static void getAddress(String uiid) async {
//   try {
//     User? user = FirebaseAuth.instance.currentUser;
//     print('User ID: $uiid');

//     var documentSnapshot =
//         await FirebaseFirestore.instance.collection('users').doc(uiid).get();

//     print('snapo ${documentSnapshot.data()}');

//     if (documentSnapshot.exists) {
//       String address = documentSnapshot.data()?['address'];
//       String result = address != null ? address.toString() : 'No Address';

//       print('here is a function and here is result $result');

//       // Send the address to the HomeView class
//       HomeView.updateAddress(result);
//       CartController.updateAddress1(result);
//     } else {
//       print('Document does not exist');

//       // Send a default message to the HomeView class
//       HomeView.updateAddress('Document does not exist');
//       CartController.updateAddress1('Document does not exist');
//     }
//   } catch (e) {
//     print('Error fetching address: $e');

//     // Handle the error - you can log it, show a user-friendly message, etc.
//     HomeView.updateAddress('Error fetching address');
//     CartController.updateAddress1('Error fetching address');
//   } finally {
//     // This block will be executed whether there is an exception or not
//     // You can use it for cleanup or additional logic
//   }
//}

 

  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // Added global key here

  Future<void> signUp(BuildContext context) async {
    try {
      UserCredential result = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
        
      );
      

      User? user = result.user;
      if (user != null) {
        //add display name for just created user
        user.updateDisplayName(usernameController.text);
        //get updated user
       
        await user.reload();
        user = await FirebaseAuth.instance.currentUser;
        //print final version to console
        print("Registered user--------------------------------------:");
        print(user);
        //getAddress(user?.uid??'');
      }

      // Save user data to Firestore
      await FirebaseFirestore.instance.collection('users').doc(user?.uid).set({
        'email': emailController.text,
        'username': usernameController.text,
        'address':addressController.text,
      });


      // Navigate to WelcomeView on successful sign-up
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignInScreen()),
      );
    } catch (e) {
      print('Error during sign-up: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(
                      color: Color.fromRGBO(76, 175, 79, 0.459),
                    ),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                    ),
                    prefixIcon: Icon(
                      Icons.email,
                      color: Colors.green,
                    )
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter your email';
                    } else if (!RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$")
                        .hasMatch(value!)) {
                      return 'Invalid email format';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 30),
                TextFormField(
                  controller: usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    labelStyle: TextStyle(
                      color: Color.fromARGB(117, 76, 175, 79),
                    ),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                    ),
                    prefixIcon: Icon(
                      Icons.person,
                      color: Colors.green,
                    ),
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter your username';
                    } else if (value!.length < 4) {
                      return 'Username must be at least 4 characters';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 30),
                TextFormField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(
                      color: Color.fromARGB(117, 76, 175, 79),
                    ),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                    ),
                    prefixIcon: Icon(
                      Icons.lock,
                      color: Colors.green,
                    ),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter your password';
                    } else if (value!.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
              controller: addressController,
              decoration: const InputDecoration(
                labelText: 'Address',
                labelStyle: TextStyle(
                  color: Color.fromARGB(117, 76, 175, 79),
                ),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                ),
                prefixIcon: Icon(
                  Icons.location_on,
                  color: Colors.green,
                ),
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter your address';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
              minimumSize: MaterialStateProperty.all<Size>(Size(200, 60)), // Adjust width and height
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0), // Adjust border radius
                ),
              ),
            ),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                signUp(context);
              }
            },
            child: Text('Sign Up',style: TextStyle(color: Colors.white, fontSize: 20),),
          ),
          
                SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                 Get.off(()=>SignInScreen()); // Go back to sign-in screen
                  },
                  child: Text(
                    'Already have an account? Sign In',
                    style: TextStyle(color: Colors.green),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
