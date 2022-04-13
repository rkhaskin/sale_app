import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products_provider.dart';

import '../widgets/products_grid_view.dart';

// ignore: constant_identifier_names
enum FilterOptions { Favorites, All }

class ProductOverviewScreen extends StatelessWidget {
  const ProductOverviewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsProvider =
        Provider.of<ProductsProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop'),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 50),
            child: PopupMenuButton(
              onSelected: (FilterOptions value) {
                if (value == FilterOptions.Favorites) {
                  productsProvider.showFavoritesOnly();
                } else {
                  productsProvider.showAll();
                }
              },
              itemBuilder: (_) => const [
                PopupMenuItem(
                    child: Text('Only Favorites'),
                    value: FilterOptions.Favorites),
                PopupMenuItem(
                    child: Text('All items'), value: FilterOptions.All)
              ],
              icon: Icon(Icons.more_vert),
            ),
          ),
        ],
      ),
      body: const ProductsGridView(),
    );
  }
}
