import 'package:flutter/material.dart';

import '../widgets/products_grid.dart';

enum FilterOptions {
  FAVORITE,
  ALL,
}

class ProductsOverviewScreen extends StatefulWidget {
  const ProductsOverviewScreen({Key? key}) : super(key: key);

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavorites = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MyShop"),
        actions: [
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.FAVORITE) {
                  _showOnlyFavorites = true;
                } else {
                  _showOnlyFavorites = false;
                }
              });
            },
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: FilterOptions.FAVORITE,
                child: Text("Only Favorite"),
              ),
              const PopupMenuItem(
                value: FilterOptions.ALL,
                child: Text("Show All"),
              ),
            ],
            icon: const Icon(
              Icons.more_vert,
            ),
          )
        ],
      ),
      body: ProductsGrid(
        showFavs: _showOnlyFavorites,
      ),
    );
  }
}
