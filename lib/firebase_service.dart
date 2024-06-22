import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_12_project_ai/app/data/models/product_model.dart';
import 'package:flutter_application_12_project_ai/app/modules/home/views/home_view.dart';

class FirebaseService {
  static late FirebaseFirestore _firestore;
    var user = FirebaseAuth.instance.currentUser;

  static Future<void> initializeFirebase() async {
    try {
      await Firebase.initializeApp(options: const FirebaseOptions(
        apiKey: "AIzaSyBvLlcRwO8Tnp_IJTMSBLzvK7D1bns8iA4",
      appId: "1:935559121285:android:cd98bc1e29d4ee67f5dcec",
      messagingSenderId: "935559121285",
      projectId: "grocer-d1cfd",
      storageBucket: "grocer-d1cfd.appspot.com",
      ));  
      _firestore = FirebaseFirestore.instance;
      print('Firebase initialized successfully');
    } catch (e) {
      print('Error initializing Firebase: $e');
    }
  }
static Future<void> storeCartData(List<ProductModel> products) async {
  try {
    if (_firestore == null) {
      throw Exception('Firebase is not initialized. Call initializeFirebase first.');
    }
 var user = FirebaseAuth.instance.currentUser;
    CollectionReference cartCollection = _firestore.collection('cart');

    // Create a list to store details of all products
    List<Map<String, dynamic>> productsData = [];

    double total = 0.0; // Variable to store the total price

    for (ProductModel product in products) {
      // Add product details to the list
      productsData.add({
        'name': product.name,
        'price': product.price,
        'quantity': product.quantity,
        'totalPrice': product.quantity * product.price,
      });

      // Update the total price
      total += product.quantity * product.price;
    }

    String customDocumentName = user?.uid??'guest'; // Set your custom document name here

    // Set the document with the list of products and total price
    await cartCollection.doc(customDocumentName).set({
      'Name':user?.displayName ??'guest',
      'products': productsData,
      'totalPrice': total,
      'timestamp': FieldValue.serverTimestamp(),

    });

    print('Cart data stored in Firestore!');
  } catch (e) {
    print('Error storing cart data in Firestore: $e');
  }
}


}
