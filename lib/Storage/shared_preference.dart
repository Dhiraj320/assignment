import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SharedPreferencesHelper {
  static Future<void> addProduct(Map<String, dynamic> product) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> products = prefs.getStringList('products') ?? [];
    products.add(jsonEncode(product));
    await prefs.setStringList('products', products);
  }

  static Future<List<Map<String, dynamic>>> getProducts() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> products = prefs.getStringList('products') ?? [];
    return products.map((product) => Map<String, dynamic>.from(jsonDecode(product))).toList();
  }

  static Future<void> deleteProduct(int index) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> products = prefs.getStringList('products') ?? [];
    products.removeAt(index);
    await prefs.setStringList('products', products);
  }
}
