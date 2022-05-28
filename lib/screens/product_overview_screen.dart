import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../screens/cart_screen.dart';
import '../widgets/products_grid_view.dart';
import '../widgets/badge.dart';
import '../widgets/app_drawer.dart';
import '../providers/products_provider.dart';

// ignore: constant_identifier_names
enum FilterOptions { Favorites, All }

class ProductOverviewScreen extends StatefulWidget {
  const ProductOverviewScreen({Key? key}) : super(key: key);

  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _showFavoritesOnly = false;
  var _isInit = true;
  var _isLoading = true;

  // @override
  // void initState() {
  //   // this will not work. Initialization of the class and linkage to Provider is not yet completed.
  //   /* Provider.of<ProductsProvider>(context).fetchProducts(); */
  //   Future.delayed(Duration.zero, () {
  //     // this will work, as we use future callback, which gets executed after all sync methods are run
  //     Provider.of<ProductsProvider>(context, listen: false).fetchProducts();
  //   });

  //   super.initState();
  // }

  @override
  void didChangeDependencies() {
    // the other way to run fetch
    if (_isInit) {
      // setState(() {
      //   print('setting isLoading');
      //   _isLoading = true;
      // });
      Provider.of<ProductsProvider>(context, listen: false)
          .fetchProducts()
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    print('setting is init');
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop'),
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
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
                value: FilterOptions.Favorites,
              ),
              PopupMenuItem(
                child: Text('All items'),
                value: FilterOptions.All,
              )
            ],
          ),
          Container(
            margin: const EdgeInsets.only(right: 50),
            child: Consumer<Cart>(
              builder: (context, cart, ch) => Badge(
                child: ch!,
                value: cart.itemCount.toString(),
              ),
              // this will be passed as a "ch" argument to the Consumer, and then to the builder.
              // Builder will pass the child param to the widget
              // the code below is outside the builder, so it will not be rebuilt.
              child: IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    CartScreen.routeName,
                  );
                },
              ),
            ),
          )
        ],
      ),
      drawer: const AppDrawer(),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGridView(_showFavoritesOnly),
    );
  }
}
