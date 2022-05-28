import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/orders_provider.dart' show Orders;
import '../widgets/order_item.dart';
import '../widgets/app_drawer.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);
  static const routeName = '/orders';

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  Future? _orders;

  Future _obtainOrders() {
    return Provider.of<Orders>(context, listen: false).fetchOrders();
  }

  @override
  void initState() {
    _orders = _obtainOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final orderProvider = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Your Orders')),
      // manages loading state for us. No need to copnvert widget to stateful just for loading state
      body: FutureBuilder(
        // no new future is created just because my widget rebuilds
        future: _orders,
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (dataSnapshot.hasError) {
            // do error handling
            return const Center(child: Text("Error occured"));
          } else {
            return Consumer<Orders>(
              builder: (ctx, orderProvider, _) {
                return ListView.builder(
                  itemCount: orderProvider.orders.length,
                  itemBuilder: (ctx, i) => OrderItem(orderProvider.orders[i]),
                );
              },
            );
          }
        },
      ),
      drawer: const AppDrawer(),
    );
  }
}
