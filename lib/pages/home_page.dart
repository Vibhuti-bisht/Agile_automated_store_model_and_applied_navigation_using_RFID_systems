// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_field, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:groceryapp/pages/fruitspage.dart';
import 'package:groceryapp/pages/login.dart';
import 'makeuppage.dart';
import 'cart.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  // final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<Map<String, dynamic>> _allCategories = [
    {
      "image": "lib/images/fruits.png",
      "category_id": 1,
      "category_name": "Fruits & Vegetables",
      "aisle_no": 1,
      "rack_no": 2,
      "page": FruitsPage()
    },
    {
      "image": "lib/images/makeup.png",
      "category_id": 2,
      "category_name": "Makeup & Skincare",
      "aisle_no": 1,
      "rack_no": 4,
      "page": MakeupPage()
    },
    {
      "image": "lib/images/chicken.png",
      "category_id": 3,
      "category_name": "Chicken & Eggs",
      "aisle_no": 2,
      "rack_no": 1,
      "page": MakeupPage()
    },
    {
      "image": "lib/images/water.png",
      "category_id": 4,
      "category_name": "Beverages",
      "aisle_no": 2,
      "rack_no": 5,
      "page": MakeupPage()
    },
  ];
  List<Map<String, dynamic>> _initial = [
    {
      "image": " ",
      "category_id": " ",
      "category_name": "Search category",
      "aisle_no": " ",
      "rack_no": " ",
      "page": HomePage()
    }
  ];
  List<Map<String, dynamic>> _foundCategories = [];
  @override
  initState() {
    // at the beginning, all categories are shown
    _foundCategories = _initial;
    super.initState();
  }

  void _runFilter(String enteredKeyword) {
    List<Map<String, dynamic>> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = _initial;
    } else {
      results = _allCategories
          .where((category) => category["category_name"]
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    // Refresh the UI
    setState(() {
      _foundCategories = results;
    });
  }

  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: const Color(0xFF161E2F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF161E2F),
        centerTitle: true,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: IconButton(
            icon: Icon(Icons.menu, size: 40),
            color: Colors.lightGreen,
            onPressed: () {
              scaffoldKey.currentState!.openDrawer();
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
      drawer: Drawer(
        child: ListView(padding: EdgeInsets.zero, children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.lightGreen,
            ),
            child: Text(''),
          ),
          Card(
            child: ListTile(
              title: Text('Logout'),
              onTap: () {
                final storage = FlutterSecureStorage();
                storage.delete(key: "mobile_no");
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginPage1()));
              },
            ),
          )
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightGreen,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return CartDetailsScreen();
            },
          ),
        ),
        child: const Icon(
          Icons.shopping_bag,
          size: 30,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: TextField(
              onChanged: (value) => _runFilter(value),
              textInputAction: TextInputAction.done,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                hintText: "Search by category",
                hintStyle: TextStyle(color: Color(0xFF60656F)),
                suffixIcon: Icon(
                  Icons.search,
                  color: Colors.lightGreen,
                  size: 20,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: _foundCategories.isNotEmpty
                ? ListView.builder(
                    itemCount: _foundCategories.length,
                    itemBuilder: (context, index) => Card(
                      elevation: 1,
                      margin: const EdgeInsets.symmetric(vertical: 2),
                      child: ListTile(
                          leading: CircleAvatar(
                            radius: 30.0,
                            backgroundImage:
                                AssetImage(_foundCategories[index]['image']),
                            backgroundColor: Colors.transparent,
                          ),
                          title: Text(_foundCategories[index]['category_name']),
                          subtitle:
                              Text('${_foundCategories[index]['aisle_no']}'),
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      _foundCategories[index]['page']))),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: const Text(
                      'No results found',
                      style: TextStyle(fontSize: 24, color: Colors.white),
                    ),
                  ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              "Shop By Category",
              style: GoogleFonts.notoSerif(fontSize: 20, color: Colors.white),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: GridView(
              padding: const EdgeInsets.all(10),
              physics: const AlwaysScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: 10),
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => FruitsPage()));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.red,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(
                          image: AssetImage("lib/images/fruits.png"),
                          height: 90,
                        ),
                        Text(
                          "Fruits & Vegetables",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        )
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MakeupPage()));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.pink,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(
                          image: AssetImage("lib/images/makeup.png"),
                          height: 90,
                        ),
                        Text(
                          "Makeup & Skincare",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        )
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomePage()));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.green,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(
                          image: AssetImage("lib/images/chicken.png"),
                          height: 80,
                        ),
                        Text(
                          "Chicken & Eggs",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        )
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomePage()));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(
                          image: AssetImage("lib/images/water.png"),
                          height: 90,
                        ),
                        Text(
                          "Beverages",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
