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
  var _isLoading = false;
  @override
  // void initState() {
  //   setState(() {
  //     _isLoading = true;
  //   });
  //   Future.delayed(Duration.zero).then((_) async {
  //     // if inside initState I use provider call with listen: false, I do not need to ue Future.delayed.
  //     await Provider.of<Orders>(context, listen: false).fetchOrders();
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   });
  //   super.initState();
  // }

  void initState() {
    _isLoading = true;
    // if inside initState I use provider call with listen: false, I do not need to ue Future.delayed.
    Provider.of<Orders>(context, listen: false).fetchOrders().then((_) {
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Your Orders')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: orderProvider.orders.length,
              itemBuilder: (ctx, i) => OrderItem(orderProvider.orders[i]),
            ),
      drawer: const AppDrawer(),
    );
  }
}
