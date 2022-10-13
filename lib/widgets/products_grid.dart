import 'package:flutter/material.dart';
import 'package:my_shop/providers/products.dart';
import 'package:my_shop/widgets/product_item.dart';
import 'package:provider/provider.dart';

class ProductsGrid extends StatelessWidget {
  final bool? showFavs;

  const ProductsGrid({this.showFavs, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products =
        showFavs! ? productsData.favoriteItems : productsData.items;
    return productsData.items.isEmpty
        ? SizedBox(
            height: double.maxFinite,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'No products found!!',
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          )
        : GridView.builder(
            padding: const EdgeInsets.all(20),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
              value: products[i],
              child: const ProductItem(),
            ),
            itemCount: products.length,
          );
  }
}
