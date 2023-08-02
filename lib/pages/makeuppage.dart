// ignore_for_file: unused_local_variable, prefer_const_constructors, sized_box_for_whitespace, prefer_const_literals_to_create_immutables, non_constant_identifier_names, use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:groceryapp/users/catmodel.dart';
import 'package:http/http.dart';
import '../api_connect/api_connect.dart';
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MakeupPage extends StatefulWidget {
  @override
  _MakeupPage createState() => _MakeupPage();
}

class _MakeupPage extends State<MakeupPage> {
  // final CategoriesScroller categoriesScroller = CategoriesScroller();
  ScrollController controller = ScrollController();
  // bool closeTopContainer = false;
  double topContainer = 0;
  String text = " ";
  @override
  void initState() {
    super.initState();
    asyncMethod();
    getPostsData();
    controller.addListener(() {
      double value = controller.offset / 119;

      setState(() {
        topContainer = value;
        // closeTopContainer = controller.offset > 50;
      });
    });
  }

  void asyncMethod() async {
    String category = "makeup";
    CatUser user = CatUser(
      category,
    );
    try {
      Response response = await post(
        Uri.parse(API.cat),
        body: user.toJson(),
      ); // Error: toString of Response is assigned to jsonDataString.
      final data = jsonDecode(response.body);
      if (data['message'] == "success") {
        text = "Makeup & Skincare is available in Aisle: " +
            data['aisle'] +
            " and Rack: " +
            data['rack'];
            setState(() {
        text = text;
        // closeTopContainer = controller.offset > 50;
      });
      } else {}
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  List<Widget> itemsData = [];
  final Makeup = [
    {
      "name": "Lipstick",
      "brand": "Lakme",
      "price": 2.99,
      "image": "lipstick.jpg"
    },
    {
      "name": "Sunscreen",
      "brand": "Organic Harvest",
      "price": 4.99,
      "image": "sun.png"
    },
    {"name": "Deodrant", "brand": "Engage", "price": 1.49, "image": "deo.png"},
    {"name": "Brush", "brand": "PAC", "price": 4.49, "image": "brush.jpg"},
    {"name": "Scissor", "brand": "PAC", "price": 2.99, "image": "tools.jpg"},
    {
      "name": "Mascara",
      "brand": "Colorbar",
      "price": 9.49,
      "image": "eyeliner.png"
    },
    {"name": "Blush", "brand": "Sugar", "price": 6.99, "image": "color.png"}
  ];

  void getPostsData() {
    List<dynamic> responseList = Makeup;
    List<Widget> listItems = [];
    for (var post in responseList) {
      listItems.add(SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
            width: 330,
            height: 150,
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withAlpha(100), blurRadius: 10.0),
                ]),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        post["name"],
                        style: const TextStyle(
                            fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        post["brand"],
                        style:
                            const TextStyle(fontSize: 17, color: Colors.grey),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "\$ ${post["price"]}",
                        style: const TextStyle(
                            fontSize: 25,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  Image.asset(
                    "lib/images/${post["image"]}",
                    height: double.infinity,
                  ),
                ],
              ),
            )),
      ));
    }
    setState(() {
      itemsData = listItems;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double categoryHeight = size.height * 0.30;
    return SafeArea(
        child: Scaffold(
      backgroundColor: const Color(0xFF161E2F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF161E2F),
        centerTitle: true,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: IconButton(
            icon: Icon(Icons.arrow_back_sharp, size: 40),
            color: Colors.lightGreen,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        title: Text(
          'AASMAAN',
          style: TextStyle(
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: IconButton(
              icon: Icon(Icons.person, size: 40),
              color: Colors.lightGreen,
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: Container(
        height: size.height,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                text,
                style: GoogleFonts.notoSerif(fontSize: 20, color: Colors.white),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
                child: ListView.builder(
                    controller: controller,
                    itemCount: itemsData.length,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      double scale = 1.0;
                      if (topContainer > 0.5) {
                        scale = index + 0.5 - topContainer;
                        if (scale < 0) {
                          scale = 0;
                        } else if (scale > 1) {
                          scale = 1;
                        }
                      }
                      return Opacity(
                        opacity: scale,
                        child: Transform(
                          transform: Matrix4.identity()..scale(scale, scale),
                          alignment: Alignment.bottomCenter,
                          child: Align(
                              heightFactor: 0.7,
                              alignment: Alignment.topCenter,
                              child: itemsData[index]),
                        ),
                      );
                    }))
          ],
        ),
      ),
    ));
  }
}
