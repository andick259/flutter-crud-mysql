import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:nearco/auth/login.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailShop extends StatefulWidget {
  final String productId;
  DetailShop({required this.productId});

  @override
  State<DetailShop> createState() => _DetailShopState();
}

class _DetailShopState extends State<DetailShop> {
  String username = '';
  String email = '';
  String password = '';
  // State variables
  bool isLoading = true;
  Map<String, dynamic>? productData;
  String error = '';

  // Function to simulate 'Buy' action
  void buyAction() {
    // Implement buy action here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Buy action triggered')),
    );
  }

  // Function to simulate 'Favorite' action
  void favoriteAction() {
    // Implement favorite action here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Favorite action triggered')),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchDataForProduct(widget.productId);
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? '';
      email = prefs.getString('email') ?? '';
      password = prefs.getString('password') ?? '';
    });
  }

  Future<void> fetchDataForProduct(String productId) async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://mitrasite.com/nearco/api/tampil-produk-detail.php?id_shop=$productId',
        ),
      );

      if (response.statusCode == 200) {
        dynamic jsonData = jsonDecode(response.body);
        if (jsonData is List) {
          if (jsonData.isNotEmpty) {
            setState(() {
              productData = jsonData[0];
              isLoading = false;
            });
          } else {
            throw Exception('Empty response');
          }
        } else if (jsonData is Map<String, dynamic>) {
          setState(() {
            productData = jsonData;
            isLoading = false;
          });
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        throw Exception('Failed to load product data');
      }
    } catch (e) {
      setState(() {
        error = 'Error fetching product data: $e';
        isLoading = false;
      });
    }
  }

  Future<void> _logout(BuildContext context) async {
    final String apiUrl = 'https://mitrasite.com/nearco/api/logout.php';

    try {
      final response = await http.post(Uri.parse(apiUrl), body: {
        'username': username,
        'email': email,
        'password': password,
      });
      final result = json.decode(response.body);
      if (result['status'] == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.clear(); // Clear all saved user data
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => Login(),
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${result['message']}')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed : ${result['message']}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to connect to the server')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/logo_nearco.png', // Replace with your image path
          height: 70, // Adjust as needed
        ),
        backgroundColor: Color.fromRGBO(48, 56, 65, 1),
        automaticallyImplyLeading: false, // Remove the back button
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            color: Colors.white,
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: isLoading
              ? CircularProgressIndicator(
                  color: Colors.grey,
                )
              : error.isNotEmpty
                  ? Text(error)
                  : productData == null
                      ? Text('No data available')
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Full-width image section
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 20.0), // Adjust top padding as needed
                              child: Stack(
                                children: [
                                  Image.network(
                                    'https://mitrasite.com/nearco/app/foto_shop/${productData!['foto']}',
                                    width: double.infinity,
                                    height: 300,
                                    fit: BoxFit.cover,
                                  ),
                                ],
                              ),
                            ),
                            // Product details section
                            Container(
                              padding: EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${productData!['nama']}',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'Rp. ${NumberFormat('#,###').format(int.parse(productData!['harga']))}',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Text(
                                    '${productData!['deskripsi']}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(top: 8), // Adjust top padding as needed
        child: Stack(
          children: [
            // Background color for the entire bottom bar
            Container(
              color: Colors.grey[200],
              height:
                  kBottomNavigationBarHeight, // Height of the bottom app bar
            ),
            // Buy section
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              width: MediaQuery.of(context).size.width /
                  //2, // Half width of the screen
                  1,
              child: GestureDetector(
                onTap: () => _launchWhatsApp(productData!),
                child: Container(
                  color: Colors.orange, // Background color for Buy section
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Ionicons
                            .logo_whatsapp, // Replace with your desired icon
                        color: Colors.white,
                      ),
                      SizedBox(
                          width: 8), // Adjust spacing between icon and text
                      Text(
                        'Buy Now',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Favorite section
            //Positioned(
            //right: 0,
            //top: 0,
            //bottom: 0,
            //width: MediaQuery.of(context).size.width /
            //  2, // Half width of the screen
            //child: GestureDetector(
            //  onTap: favoriteAction,
            // child: Container(
            // color: Colors.orange, // Background color for Favorite section
            // child: Center(
            // child: Text(
            // 'Favorite',
            // style: TextStyle(color: Colors.white, fontSize: 16),
            // ),
            //),
            // ),
            //),
            //),
          ],
        ),
      ),
    );
  }
}

_launchWhatsApp(Map<String, dynamic> productData) async {
  // Use the WhatsApp phone number with country code and without '+' or '-'
  String phoneNumber = "+6282125009339"; // Replace with your phone number
  String productName = productData['nama'];
  String message =
      "Hello, I want to buy your product $productName."; // Your message here

  // Encode the message and phone number to be used in the URL
  String url = "https://wa.me/$phoneNumber/?text=${Uri.encodeFull(message)}";
  // Launch the WhatsApp URL
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
