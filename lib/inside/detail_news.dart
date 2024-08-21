import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:nearco/auth/login.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailNews extends StatefulWidget {
  final String idNews;
  DetailNews({required this.idNews});

  @override
  State<DetailNews> createState() => _DetailNewsState();
}

class _DetailNewsState extends State<DetailNews> {
  String username = '';
  String email = '';
  String password = '';
  // State variables
  bool isLoading = true;
  Map<String, dynamic>? newsData;
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
    fetchDataForProduct(widget.idNews);
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

  Future<void> fetchDataForProduct(String idNews) async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://mitrasite.com/nearco/api/tampil-news-detail.php?id_news=$idNews',
        ),
      );

      if (response.statusCode == 200) {
        dynamic jsonData = jsonDecode(response.body);
        if (jsonData is List) {
          if (jsonData.isNotEmpty) {
            setState(() {
              newsData = jsonData[0];
              isLoading = false;
            });
          } else {
            throw Exception('Empty response');
          }
        } else if (jsonData is Map<String, dynamic>) {
          setState(() {
            newsData = jsonData;
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
                  : newsData == null
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
                                    'https://mitrasite.com/nearco/app/foto_news/${newsData!['foto']}',
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
                                    '${newsData!['judul']}',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Text(
                                    '${newsData!['isi']}',
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
    );
  }
}
