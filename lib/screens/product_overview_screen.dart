import 'package:flutter/material.dart';

import '../widgets/products_grid_view.dart';

// ignore: constant_identifier_names
enum FilterOptions { Favorites, All }

class ProductOverviewScreen extends StatefulWidget {
  const ProductOverviewScreen({Key? key}) : super(key: key);

  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _showFavoritesOnly = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop'),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 50),
            child: PopupMenuButton(
              onSelected: (FilterOptions value) {
                setState(() {
                  if (value == FilterOptions.Favorites) {
                    _showFavoritesOnly = true;
                  } else {
                    _showFavoritesOnly = false;
                  }
                });
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
      body: ProductsGridView(_showFavoritesOnly),
    );
  }
}
