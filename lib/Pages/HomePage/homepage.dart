import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:shopify/Storage/shared_preference.dart';
import 'package:shopify/Pages/LoginPage/login.dart';
import 'package:shopify/Widgets/photoview.dart';
import 'add_product_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> products = [];

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  void loadProducts() async {
    products = await SharedPreferencesHelper.getProducts();
    setState(() {});
    for (var product in products) {
      if (kDebugMode) {
        print('Product: ${product['name']}, Image: ${product['image']}');
      }
    }
  }

  void deleteProduct(int index) {
    SharedPreferencesHelper.deleteProduct(index);
    loadProducts();
  }

  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  void showFullScreenImage(String imagePath) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenImagePage(imagePath: imagePath),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
           IconButton(
            icon: const Icon(Icons.logout),
            onPressed: logout,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: const InputDecoration(labelText: 'Search'),
              onChanged: (query) {
                setState(() {
                  products = products.where((product) {
                    return product['name']
                        .toLowerCase()
                        .contains(query.toLowerCase());
                  }).toList();
                });
              },
            ),
          ),
          Expanded(
            child: products.isEmpty
                ? const Center(child: Text('No Product Found'))
                : GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Number of columns
                      childAspectRatio: 0.75, // Aspect ratio for square shape
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.all(8.0),

                        child: GridTile(
                          header: Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () => deleteProduct(index),
                            ),
                          ),
                          footer: ListTile(
                            title: Text(
                              products[index]['name'],
                              style: const TextStyle(color: Colors.black),
                            ),
                            subtitle: Text(
                              '₹${products[index]['price']}',
                              style: const TextStyle(color: Colors.black),
                            ),
                          ),
                          child: GestureDetector(
                            onLongPress: () {
                              if (products[index]['image'] != null) {
                                showFullScreenImage(products[index]['image']);
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                image: products[index]['image'] != null
                                    ? DecorationImage(
                                        image: FileImage(
                                            File(products[index]['image'])),
                                        fit: BoxFit.fill,
                                      )
                                    : null,
                                color: products[index]['image'] == null
                                    ? Colors.grey[300]
                                    : null,
                              ),
                              child: products[index]['image'] == null
                                  ? const Center(
                                      child: Icon(Icons.image, size: 50))
                                  : null,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddProductPage()),
          ).then((_) => loadProducts());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
