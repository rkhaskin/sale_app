import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart' as provider_ci;
import '../providers/orders_provider.dart';
import '../widgets/cart_item.dart' as ci;

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<provider_ci.Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total', style: TextStyle(fontSize: 20)),
                  const Spacer(),
                  Chip(
                    label: Text(
                      'Total \$${cart.calculateTotal.toStringAsFixed(2)}',
                      style: TextStyle(
                          color: Theme.of(context)
                              .primaryTextTheme
                              .titleSmall
                              // by default uses white
                              ?.color),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  OrderButton(cart: cart),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            // list view does not work with column directly. use Expanded as wrapper
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (ctx, i) {
                provider_ci.CartItem providerCi = cart.items.values.toList()[i];
                return ci.CartItem(
                  id: providerCi.id,
                  price: providerCi.price,
                  quantity: providerCi.quantity,
                  title: providerCi.title,
                  productId: cart.items.keys.toList()[i],
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required this.cart,
  }) : super(key: key);

  final provider_ci.Cart cart;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      // if total amount not greater than 0, disable the button: button is disabled if onPressed has no function to point to
      onPressed: (widget.cart.calculateTotal <= 0 || _isLoading)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              await Provider.of<Orders>(context, listen: false).addOrder(
                // convert from Map<String, CartItem> to List<CartItem>
                widget.cart.items.values.toList(),
                widget.cart.calculateTotal,
              );
              setState(() {
                _isLoading = false;
              });
              widget.cart.clear();
            },
      child:
          _isLoading ? CircularProgressIndicator() : const Text('Order Now!'),
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.resolveWith<Color?>(
          (_) {
            return Theme.of(context).colorScheme.primary;
          },
        ),
      ),
    );
  }
}
