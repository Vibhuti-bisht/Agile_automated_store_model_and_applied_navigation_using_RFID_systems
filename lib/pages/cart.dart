import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:groceryapp/pages/payment.dart';
import 'package:http/http.dart';
import '../api_connect/api_connect.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CartDetailsScreen extends StatefulWidget {
  @override
  _CartDetailsScreenState createState() => _CartDetailsScreenState();
}

class _CartDetailsScreenState extends State<CartDetailsScreen> {
  List<dynamic> _cartDetails = [];
  late Timer _timer;
  int tot = 0;
  @override
  void initState() {
    super.initState();
    _getCartDetails();
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      _getCartDetails();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> _getCartDetails() async {
    final storage = FlutterSecureStorage();
    final value = await storage.read(key: "mobile_no");
    Response response =
        await post(Uri.parse(API.cart), body: {"mobile_no": value.toString()});

    if (response.statusCode == 200) {
      setState(() {
        tot = 0;
        _cartDetails = jsonDecode(response.body);
        for (int i = 0; i < _cartDetails.length; i++) {
          tot = tot + int.parse(_cartDetails[i]['price']);
        }
        // debugPrint(_cartDetails.toString());
        // Fluttertoast.showToast(msg: _cartDetails.toString());
      });
    }
  }

  Future<void> remove(String abc) async {
    final storage = FlutterSecureStorage();
    final value = await storage.read(key: "mobile_no");
    // try {
    Response response = await post(Uri.parse(API.remove),
        body: {"mobile_no": value.toString(), "remove": abc});
    // Fluttertoast.showToast(msg: abc);
// var data= await json.decode(json.encode(response.body));  
//     Fluttertoast.showToast(msg: data);
    // } catch (e) {
    //   Fluttertoast.showToast(msg: e.toString());
    // }
  }

  Future pay(BuildContext cont) async {
    Navigator.push(
        cont, MaterialPageRoute(builder: (context) => const Payment()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.grey[800],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Let's order fresh items for you
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              "My Cart",
              style: GoogleFonts.notoSerif(
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // list view of cart
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: ListView.builder(
              itemCount: _cartDetails.length,
              itemBuilder: (context, index) {
                var item = _cartDetails[index];

                return Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Card(
                    child: ListTile(
                      title: Text(item['pname'],
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 8.0),
                          Text('Expiry: ${item['expiry_date']}'),
                          SizedBox(height: 8.0),
                          Text('Price: \$${item['price']}'),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.cancel),
                        onPressed: () {
                          remove(item['pid']);
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          )),
          Padding(
            padding: const EdgeInsets.all(36.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.green,
              ),
              padding: const EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Price',
                        style: TextStyle(color: Colors.green[200]),
                      ),

                      const SizedBox(height: 8),
                      // total price
                      Text(
                        tot.toString(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),

                  // pay now
                  InkWell(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.green.shade200),
                        borderRadius: BorderRadius.circular(28),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: const [
                          Text(
                            'Pay Now',
                            style: TextStyle(color: Colors.white),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Payment(),
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
