import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../utils/dummy_helper.dart';
import '../../../components/custom_snackbar.dart';
import '../../../data/models/product_model.dart';
import '../../base/controllers/base_controller.dart';
import '../../../../firebase_service.dart';

class CartController extends GetxController {
  List<ProductModel> products = [];
    static String? Address1;
 static void updateAddress1(String address) {
    // Update the UI or perform any necessary action with the address in the HomeView class
  Address1=address;
  print('address is ' +address);
  
  }

  @override
  void onInit() {
    getCartProducts();
    super.onInit();
  }

  Future<void> storeData(List<ProductModel> products) async {
    await FirebaseService.storeCartData(products);
  }

  onPurchaseNowPressed() async {
    sendWhatsAppMessage("+923401400510", generateMessageContent());
    await storeData(products);

    clearCart();
    Get.back();
    CustomSnackBar.showCustomSnackBar(
      title: 'Purchased',
      message: 'Order placed with success',
    );
  }

  getCartProducts() {
    products = DummyHelper.products.where((p) => p.quantity > 0).toList();
    update();
  }

  clearCart() {
    DummyHelper.products.map((p) => p.quantity = 0).toList();
    Get.find<BaseController>().getCartItemsCount();
  }

  void sendWhatsAppMessage(String phoneNumber, String message) async {
    String whatsappUrl = "https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}";
    launchUrl(Uri.parse(whatsappUrl));
  }
String generateMessageContent() {
  double total = 0.0;
  String message = "Cart Details:\n";

  // Add address to the message
  if (Address1 != null && Address1!.isNotEmpty) {
    message += "Address: $Address1\n";
  }

  for (ProductModel product in products) {
    double productTotal = product.quantity * product.price;
    total += productTotal;

    message +=
        "${product.name} - Quantity: ${product.quantity}, Price: \$${product.price.toStringAsFixed(2)}, Total: \$${productTotal.toStringAsFixed(2)}\n";
  }

  message += '\nTotal Price: \$${total.toStringAsFixed(2)}';

  return message;
}

}
