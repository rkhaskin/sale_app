import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String description;
  final String title;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.description,
    required this.title,
    required this.imageUrl,
    required this.price,
    this.isFavorite = false,
  });

  Future<void> toggleFavorite() async {
    bool tmp = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();

    final url = Uri.https(
        'flutter-sales-app-default-rtdb.firebaseio.com', '/products/$id.json');
    try {
      final response =
          await http.patch(url, body: jsonEncode({'isFavorite': isFavorite}));
      if (response.statusCode >= 400) {
        isFavorite = tmp;
        notifyListeners();
      }
    } catch (error) {
      isFavorite = tmp;
      notifyListeners();
    }
  }
}
