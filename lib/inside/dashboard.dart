import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:ionicons/ionicons.dart';
import 'package:nearco/inside/coach.dart';
import 'package:nearco/inside/detail_news.dart';
import 'package:nearco/inside/detail_shop.dart';
import 'package:nearco/inside/event.dart';
import 'package:nearco/inside/jockey.dart';
import 'package:nearco/inside/news.dart';
import 'package:nearco/inside/stable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<dynamic> products = [];
  List<dynamic> newsItems = [];
  bool isLoadingProducts = false;
  bool isLoadingNews = false;

  String username = '';
  String email = '';
  String id_user = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _fetchData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? '';
      email = prefs.getString('email') ?? '';
      id_user = prefs.getString('id_user') ?? '';
    });
  }

  Future<void> _fetchData() async {
    await _loadUserData();
    await _getProductData();
    await _getNewsData();
  }

  Future<void> _handleRefresh() async {
    setState(() {
      isLoadingProducts = true;
      isLoadingNews = true;
    });
    await _loadUserData();
    await _getProductData();
    await _getNewsData();
    setState(() {
      isLoadingProducts = false;
      isLoadingNews = false;
    });
  }

  Future<void> _getProductData() async {
    try {
      final response = await http.post(
        Uri.parse(
            'https://mitrasite.com/nearco/api/tampil-produk-dashboard.php'),
        // Add any necessary headers or body parameters here
      );

      if (response.statusCode == 200) {
        setState(() {
          products = jsonDecode(response.body);
          isLoadingProducts = false;
        });
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      setState(() {
        isLoadingProducts = false;
      });
      print('Error fetching products: $e');
      // Show a snackbar or dialog to inform the user of the error.
    }
  }

  Future<void> _getNewsData() async {
    try {
      final response = await http.post(
        Uri.parse('https://mitrasite.com/nearco/api/tampil-news-dashboard.php'),
        // Add any necessary headers or body parameters here
      );

      if (response.statusCode == 200) {
        setState(() {
          newsItems = jsonDecode(response.body);
          isLoadingNews = false;
        });
      } else {
        throw Exception('Failed to load news: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isLoadingNews = false;
      });
      print('Error fetching news: $e');
      // Show a snackbar or dialog to inform the user of the error.
    }
  }

  void navigateToDetailNews(String idNews) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailNews(idNews: idNews),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        color: Colors.grey, // Set the color of the refresh indicator
        backgroundColor: Colors.white,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 5),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Hallo, $username',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.15,
                  child: CarouselSlider(
                    options: CarouselOptions(
                      aspectRatio: 16 / 9,
                      viewportFraction: 0.8,
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 3),
                      autoPlayAnimationDuration: Duration(milliseconds: 800),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enableInfiniteScroll: true,
                      enlargeCenterPage: true,
                      scrollDirection: Axis.horizontal,
                    ),
                    items: [
                      Container(
                        margin: EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          image: DecorationImage(
                            image: AssetImage('assets/1.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          image: DecorationImage(
                            image: AssetImage('assets/2.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          image: DecorationImage(
                            image: AssetImage('assets/3.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      // Add more images as needed
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => Event(),
                              ),
                            );
                          },
                          child: Column(
                            children: [
                              Icon(
                                Icons.calendar_today_outlined,
                                size: 25,
                                color: Colors.orange,
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Event',
                                style: TextStyle(
                                    fontSize: 11, color: Colors.orange),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => Coach(),
                              ),
                            );
                          },
                          child: Column(
                            children: [
                              Icon(
                                Ionicons.people_outline,
                                size: 25,
                                color: Colors.orange,
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Coach',
                                style: TextStyle(
                                    fontSize: 11, color: Colors.orange),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => Jockey(),
                              ),
                            );
                          },
                          child: Column(
                            children: [
                              Icon(
                                Icons.person_search_outlined,
                                size: 25,
                                color: Colors.orange,
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Jockey',
                                style: TextStyle(
                                    fontSize: 11, color: Colors.orange),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            // Navigate to the page for 'Stable'
                            // Example: Navigator.push(context, MaterialPageRoute(builder: (context) => StablePage()));
                          },
                          child: Column(
                            children: [
                              Icon(
                                Icons.local_hospital_outlined,
                                size: 25,
                                color: Colors.orange,
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Doctor',
                                style: TextStyle(
                                    fontSize: 11, color: Colors.orange),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => Stable(),
                              ),
                            );
                          },
                          child: Column(
                            children: [
                              Icon(
                                Ionicons.home_outline,
                                size: 25,
                                color: Colors.orange,
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Stable',
                                style: TextStyle(
                                    fontSize: 11, color: Colors.orange),
                              ),
                            ],
                          ),
                        ),
                        // Add more columns for other icons and texts
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Feed Newest',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                // Product grid view
                isLoadingProducts
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : products.isEmpty
                        ? Center(
                            child: Text('No products found.'),
                          )
                        : SizedBox(
                            height: MediaQuery.of(context).size.height * 0.2,
                            child: PageView.builder(
                              itemCount: (products.length / 2).ceil(),
                              itemBuilder:
                                  (BuildContext context, int pageIndex) {
                                int index1 = pageIndex * 2;
                                int index2 = index1 + 1;
                                var product1 = index1 < products.length
                                    ? products[index1]
                                    : null;
                                var product2 = index2 < products.length
                                    ? products[index2]
                                    : null;

                                return Row(
                                  children: [
                                    if (product1 != null)
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    DetailShop(
                                                  productId:
                                                      product1['id_shop'],
                                                ),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 5.0),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                  'https://mitrasite.com/nearco/app/foto_shop/${product1['foto']}',
                                                ),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.stretch,
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.all(8.0),
                                                  color: Color.fromARGB(
                                                      255, 247, 242, 242),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        product1['nama'],
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 11.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      SizedBox(height: 5),
                                                      Text(
                                                        'Rp. ${NumberFormat('#,###').format(int.parse(product1['harga']))}',
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 11.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    if (product2 != null)
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    DetailShop(
                                                  productId:
                                                      product2['id_shop'],
                                                ),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 5.0),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                  'https://mitrasite.com/nearco/app/foto_shop/${product2['foto']}',
                                                ),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.stretch,
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.all(8.0),
                                                  color: Color.fromARGB(
                                                      255, 247, 242, 242),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        product2['nama'],
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 11.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      SizedBox(height: 5),
                                                      Text(
                                                        'Rp. ${NumberFormat('#,###').format(int.parse(product2['harga']))}',
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 11.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                );
                              },
                            ),
                          ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Hot News',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => News(),
                          ),
                        );
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Text(
                          'See All News',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.orange,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 10),
                // News grid view
                isLoadingNews
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : newsItems.isEmpty
                        ? Center(
                            child: Text('No news found.'),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: newsItems.length,
                            itemBuilder: (BuildContext context, int index) {
                              var news = newsItems[index];
                              return GestureDetector(
                                onTap: () {
                                  navigateToDetailNews(news['id_news']);
                                },
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 20),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    color: Colors.grey[200],
                                  ),
                                  padding: EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        height: 150,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          image: DecorationImage(
                                            image: NetworkImage(
                                              'https://mitrasite.com/nearco/app/foto_news/${news['foto']}',
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        news['judul'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15.0,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        news['isi'].length > 200
                                            ? '${news['isi'].substring(0, 200)}...'
                                            : news['isi'],
                                        style: TextStyle(fontSize: 12.0),
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
