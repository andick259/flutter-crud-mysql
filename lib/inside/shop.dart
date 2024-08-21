import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nearco/inside/detail_shop.dart';
import 'package:intl/intl.dart';

class Shop extends StatefulWidget {
  @override
  State<Shop> createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  List<dynamic> products = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getProductData();
  }

  Future<void> getProductData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
          Uri.parse('https://mitrasite.com/nearco/api/tampil-produk.php'));

      if (response.statusCode == 200) {
        setState(() {
          products = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching products: $e');
    }
  }

  Future<void> handleRefresh() async {
    await getProductData();
  }

  void navigateToEditScreen(String idProduk) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailShop(productId: idProduk),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    hintText: 'Search products...',
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
                else if (products.isEmpty)
                  Center(
                    child: Text('No products found'),
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
                    itemCount: products.length,
                    itemBuilder: (BuildContext context, int index) {
                      var product = products[index];
                      return GestureDetector(
                        onTap: () {
                          // Navigate to detail screen with product['id_produk']
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    DetailShop(productId: product['id_shop'])),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            image: DecorationImage(
                              image: NetworkImage(
                                  'https://mitrasite.com/nearco/app/foto_shop/${product['foto']}'),
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
                                      product['nama'],
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 11.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      'Rp. ${NumberFormat('#,###').format(int.parse(product['harga']))}',
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
