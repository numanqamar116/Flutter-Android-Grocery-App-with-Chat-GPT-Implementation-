import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_12_project_ai/SignInUpScreen.dart';
import 'package:flutter_application_12_project_ai/app/modules/profile/controllers/profile_controller.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileView extends GetView<ProfileController> {
  

 const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile', style: Theme.of(context).textTheme.headline3),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Get.off(() => SignInUpScreen());
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/mart1.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.only(top: _height / 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(2.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green,
                      ),
                      child: CircleAvatar(
                        backgroundImage:
                            AssetImage('assets/images/logomart.jpg'),
                        radius: _height / 10,
                      ),
                    ),
                    SizedBox(
                      height: _height / 30,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: _height / 2.2),
              child: Container(
                color: Colors.white,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: _height / 2.6,
                left: _width / 20,
                right: _width / 20,
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black45,
                          blurRadius: 2.0,
                          offset: Offset(0.0, 2.0),
                        )
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(_width / 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          headerChild('Products', '500k+'),
                          headerChild('Brands', '10k+'),
                          headerChild('Rep Customers', '1M+'),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: _height / 20),
                    child: Column(
                      children: <Widget>[
                        infoChild(
                          _width,
                          Icons.email,
                          'veganmarket@gmail.com',
                        ),
                        infoChild(
                          _width,
                          Icons.call,
                          '+923069761224',
                        ),
                        infoChild(
                          _width,
                          Icons.facebook,
                          'www.facebook.com/vegan_market',
                        ),
                        infoChild(
                          _width,
                          Icons.location_on_outlined,
                          'Vegan Market, 123 High Street.',
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                              height: 45,
                              child: InkWell(
                                onTap: () {
                                  launchWhatsApp();
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 51, 177, 26),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Icon(
                                      FontAwesomeIcons.whatsapp,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget headerChild(String header, String value) => Expanded(
        child: Column(
          children: <Widget>[
            Text(header),
            SizedBox(
              height: 8.0,
            ),
            Text(
              '$value',
              style: TextStyle(
                fontSize: 14.0,
                color: Color.fromARGB(255, 4, 139, 15),
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      );

  Widget infoChild(double width, IconData icon, data) => Padding(
        padding: EdgeInsets.only(bottom: 8.0),
        child: InkWell(
          child: Row(
            children: <Widget>[
              SizedBox(
                width: width / 10,
              ),
              Icon(
                icon,
                color: Color.fromARGB(255, 27, 172, 34),
                size: 36.0,
              ),
              SizedBox(
                width: width / 20,
              ),
              Text(data),
            ],
          ),
          onTap: () {
            print('Info Object selected');
          },
        ),
      );
}



void launchWhatsApp() async {
  String whatsappUrl =
      "https://wa.me/+923401400510?text=${Uri.encodeComponent('hello')}";
  launchUrl(Uri.parse(whatsappUrl));
}

