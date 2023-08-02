// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last
import 'login.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_page.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return IntroScreenPage();
  }
}

class IntroScreenPage extends State<IntroScreen> {
  void asyncMethod() async {
    final storage = FlutterSecureStorage();
    final value = await storage.read(key: "mobile_no");
    if(value!=null){
      await Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
    }
    else{Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => LoginPage1()));}
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFF161E2F),
        body: Container(
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              SizedBox(
                height: 50,
              ),
              Image(
                image: AssetImage('lib/images/cart.png'),
                fit: BoxFit.contain,
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Text(
                  'Welcome to AASMAAN',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.notoSerif(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(left: 40, right: 40),
                child: MaterialButton(
                  child: Text(
                    "Get Started",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  color: const Color.fromARGB(255, 112, 91, 222),
                  height: 50,
                  minWidth: 50,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  onPressed: () {
                    asyncMethod();
                  },
                ),
              ),
              const Spacer(),
            ],
          ),
        ));
  }
}
