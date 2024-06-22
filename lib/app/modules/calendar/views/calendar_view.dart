import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../../../components/no_data.dart';

class CalendarView extends StatefulWidget {
  const CalendarView({Key? key}) : super(key: key);

  @override
  _CalendarViewState createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History', style: context.theme.textTheme.headline3),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              // Trigger a refresh when the refresh button is pressed
              setState(() {});
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchCartData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const NoData(text: 'No cart data available');
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> productData = snapshot.data![index];
                return ListTile(
                  title: Text(productData['name']),
                  subtitle: Text('Quantity: ${productData['quantity']}'),
                  trailing: Text('Total: \$${productData['quantity'] * productData['price']}'),
                );
              },
            );
          }
        },
      ),
    );
  }

Future<List<Map<String, dynamic>>> fetchCartData() async {
  try {
    var user = FirebaseAuth.instance.currentUser;
    CollectionReference cartCollection = FirebaseFirestore.instance.collection('cart');

    if (user != null) {
      String customDocumentName = user.uid;

      DocumentSnapshot userCartSnapshot = await cartCollection.doc(customDocumentName).get();

      if (userCartSnapshot.exists) {
        Map<String, dynamic> userData = userCartSnapshot.data() as Map<String, dynamic>;
        List<Map<String, dynamic>> allProductsData = List<Map<String, dynamic>>.from(userData['products']);
        return allProductsData;
      } else {
        return [];
      }
    } else {
      return []; // Handle the case when the user is not authenticated
    }
  } catch (e) {
    print('Error fetching cart data: $e');
    return [];
  }
}

}
