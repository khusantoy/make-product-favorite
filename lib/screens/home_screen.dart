import 'package:flutter/material.dart';
import 'package:make_product_favorite/services/products_http_services.dart';

import '../models/product.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final productsHttpServices = ProductsHttpServices();
  List<Product> favorites = [];

  @override
  void initState() {
    super.initState();

    getFavorites();
  }

  void getFavorites() async {
    favorites = await productsHttpServices.getFavoriteProducts();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mahsulotlar"),
      ),
      body: FutureBuilder(
        future: productsHttpServices.getProducts(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final products = snapshot.data;
          return products == null || products.isEmpty
              ? const Center(
                  child: Text("Mavjud emas"),
                )
              : ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (c, index) {
                    final product = products[index];
                    int favoriteProductIndex =
                        favorites.indexWhere((favoriteProduct) {
                      return favoriteProduct.id == product.id;
                    });
                    return ListTile(
                      title: Text(product.title),
                      trailing: IconButton(
                        onPressed: () async {
                          if (favoriteProductIndex == -1) {
                            favorites.add(product);
                          } else {
                            favorites.removeAt(favoriteProductIndex);
                          }
                          setState(() {});
                          await productsHttpServices.addFavorite(favorites);
                        },
                        icon: Icon(
                          favoriteProductIndex == -1
                              ? Icons.favorite_outline
                              : Icons.favorite,
                        ),
                      ),
                    );
                  },
                );
        },
      ),
    );
  }
}
