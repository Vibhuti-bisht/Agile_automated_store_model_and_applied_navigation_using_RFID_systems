// ignore_for_file: non_constant_identifier_names, prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable, use_build_context_synchronously, unused_import

import 'dart:convert';
import 'package:groceryapp/pages/home_page.dart';
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:groceryapp/users/model.dart';
import '../api_connect/api_connect.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginPage1 extends StatefulWidget {
  const LoginPage1({super.key});

  @override
  State<StatefulWidget> createState() {
    return LoginPage1State();
  }
}

class LoginPage1State extends State<LoginPage1> {
  TextEditingController username = TextEditingController();
  TextEditingController mobile_no = TextEditingController();
  bool isPasswordVisible = true;
  Future login(BuildContext cont) async {
    if (username.text.isNotEmpty && mobile_no.text.isNotEmpty) {
      User usermodel = User(
        username.text.trim(),
        mobile_no.text.trim(),
      );
      try {
        Response response = await post(
          Uri.parse(API.login),
          body: usermodel.toJson(),
        );
        final data = jsonDecode(response.body);
        Fluttertoast.showToast(msg: data['message'].toString());
        if (data['message'] == 'success') {
          final storage = FlutterSecureStorage();
          await storage.write(key: "mobile_no", value: mobile_no.text.trim());
          final value = await storage.read(key: "mobile_no");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Login Successful",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              backgroundColor: Color.fromARGB(255, 117, 198, 25),
            ),
          );
          Navigator.push(
              cont, MaterialPageRoute(builder: (context) => HomePage()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              "Invalid Credentials",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.red,
          ));
        }
      } catch (e) {
        Fluttertoast.showToast(msg: e.toString());
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Blank field not allowed",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF161E2F),
      body: Center(
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 80, horizontal: 30),
          shrinkWrap: true,
          children: <Widget>[
            Form(
              autovalidateMode: AutovalidateMode.always,
              child: TextFormField(
                validator: MultiValidator([
                  RequiredValidator(errorText: "*Required"),
                ]),
                controller: username,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  prefixIcon: Icon(Icons.person_2_rounded),
                  suffixIcon: username.text.isEmpty
                      ? Container(width: 0)
                      : IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () => username.clear(),
                        ),
                  contentPadding: EdgeInsets.all(20),
                  hintText: 'UserName',
                  hintStyle: const TextStyle(color: Color(0xFF60656F)),
                ),
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.done,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Form(
              autovalidateMode: AutovalidateMode.always,
              child: TextFormField(
                validator: MultiValidator([
                  RequiredValidator(errorText: "*Required"),
                  MinLengthValidator(7,
                      errorText: "Enter your 7 digit mobile number")
                ]),
                controller: mobile_no,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  suffixIcon: IconButton(
                    icon: isPasswordVisible
                        ? Icon(Icons.visibility_off)
                        : Icon(Icons.visibility),
                    onPressed: () =>
                        setState(() => isPasswordVisible = !isPasswordVisible),
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  hintText: 'Mobile Number',
                  hintStyle: const TextStyle(
                    color: Color(0xFF60656F),
                  ),
                ),
                obscureText: isPasswordVisible,
                textInputAction: TextInputAction.done,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ConstrainedBox(
              constraints: BoxConstraints.tightFor(height: 60, width: 190),
              child: ElevatedButton(
                // ignore: sort_child_properties_last
                child: Text(
                  "LOGIN",
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  backgroundColor: Colors.lightGreen,
                ),
                onPressed: () {
                  login(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
