import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:make_product_favorite/models/product.dart';

class ProductsHttpServices {
  final _userId = "123qwerty";

  Future<List<Product>> getProducts() async {
    Uri url = Uri.parse(
        "https://onlayn-magazin-1-default-rtdb.firebaseio.com/products.json");
    final response = await http.get(url);
    final data = jsonDecode(response.body);
    List<Product> products = [];
    if (data != null) {
      data.forEach((key, value) {
        products.add(
          Product(
            id: key,
            title: value['title'],
          ),
        );
      });
    }

    return products;
  }

  Future<void> addFavorite(List<Product> products) async {
    Uri url = Uri.parse(
        "https://lesson50-efebe-default-rtdb.asia-southeast1.firebasedatabase.app/favoriteProducts/$_userId.json");

    final response = await http.put(
      url,
      body: jsonEncode(
        {
          "products": products.map((product) => product.toMap()).toList(),
        },
      ),
    );
    final data = jsonDecode(response.body);
  }

  Future<List<Product>> getFavoriteProducts() async {
    Uri url = Uri.parse(
        "https://lesson50-efebe-default-rtdb.asia-southeast1.firebasedatabase.app/favoriteProducts/$_userId/products.json");
    final response = await http.get(url);
    final data = jsonDecode(response.body);
    List<Product> products = [];
    if (data != null) {
      data.forEach((value) {
        products.add(
          Product(
            id: value['id'],
            title: value['title'],
          ),
        );
      });
    }

    return products;
  }
}
