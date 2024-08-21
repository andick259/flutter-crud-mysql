import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nearco/inside/dashboard.dart';
import 'package:nearco/inside/detail_event.dart';
import 'package:nearco/navigation_menu.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nearco/auth/login.dart';
import 'package:nearco/inside/detail_news.dart';

class Coach extends StatefulWidget {
  const Coach({Key? key}) : super(key: key);

  @override
  State<Coach> createState() => _CoachState();
}

class _CoachState extends State<Coach> {
  String username = ''; // Initialize with the logged-in user's data
  String email = ''; // Initialize with the logged-in user's data
  String password = ''; // Initialize with the logged-in user's data
  List<dynamic> coachList = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getProductData();
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

  Future<void> getProductData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http
          .post(Uri.parse('https://mitrasite.com/nearco/api/tampil-coach.php'));

      if (response.statusCode == 200) {
        setState(() {
          coachList = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load coach');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching coch: $e');
    }
  }

  Future<void> handleRefresh() async {
    await getProductData();
  }

  void navigateToDetailCoach(String idCoach) {
    //Navigator.push(
    // context,
    // MaterialPageRoute(
    // builder: (context) => DetailEvent(idCoach: idCoach),
    // ),
    //  );
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
        await prefs.clear(); // Clear all saved user data
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
        backgroundColor: Color.fromRGBO(48, 56, 65, 1),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => NavigationMenu(),
              ),
            );
          },
        ),
        title: Image.asset(
          'assets/logo_nearco.png',
          height: 70,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            color: Colors.white,
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: handleRefresh,
        color: Colors.grey,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Search input field
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search coach...',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.grey), // Specify border color here
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onChanged: (value) {
                    // Implement search functionality here
                    // You may want to filter your 'products' list based on the search value
                  },
                ),
                SizedBox(height: 20),

                // Loading indicator or no products message
                if (isLoading)
                  Center(
                    child: CircularProgressIndicator(
                      color: Colors.grey,
                    ),
                  )
                else if (coachList.isEmpty)
                  Center(
                    child: Text('No coach found'),
                  )
                else
                  // Product grid view
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.all(5.0),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                      childAspectRatio: 0.85,
                    ),
                    itemCount: coachList.length,
                    itemBuilder: (BuildContext context, int index) {
                      var coach = coachList[index];
                      return GestureDetector(
                        onTap: () {
                          // Navigate to detail screen with product['id_produk']
                          // Navigator.push(
                          //   context,
                          // MaterialPageRoute(
                          //   builder: (context) =>
                          //     DetailShop(productId: product['id_shop'])),
                          // );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            image: DecorationImage(
                              image: NetworkImage(
                                  'https://mitrasite.com/nearco/app/foto_coach/${coach['foto']}'),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Container(
                                padding: EdgeInsets.all(8.0),
                                color: Color.fromARGB(255, 247, 242, 242),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      coach['nama'],
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 11.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      coach['kota'],
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 11.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
