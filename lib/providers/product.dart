import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  void _setFavorite(bool newStatus) {
    isFavorite = newStatus;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus() async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url = Uri.https(
        'myshop-93017-default-rtdb.firebaseio.com', 'products/$id.json');
    try {
      final res = await http.patch(url,
          body: jsonEncode({
            'isFavorite': isFavorite,
          }));
      if (res.statusCode >= 400) {
        _setFavorite(oldStatus);
      }
    } catch (err) {
      _setFavorite(oldStatus);
    }
  }
}
