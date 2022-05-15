import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../providers/orders_provider.dart' as oip;

class OrderItem extends StatefulWidget {
  final oip.OrderItem orderData;
  const OrderItem(this.orderData, {Key? key}) : super(key: key);

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(children: [
        ListTile(
          title: Text('Total is \$${widget.orderData.total}'),
          subtitle: Text(
            DateFormat('dd-MM-yyyy hh:mm')
                .format(widget.orderData.orderDateTime),
          ),
          trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              }),
        ),
        if (_expanded)
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              // select min of 2 values. adds base height of 20 + 100. Now select the smallest valeu of 2
              height: min(widget.orderData.orderList.length * 20.0 + 10.0, 100),
              child: ListView(
                children: widget.orderData.orderList
                    .map((prod) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              prod.title,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${prod.quantity}x \$${prod.price}',
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.grey),
                            ),
                          ],
                        ))
                    .toList(),
              ))
      ]),
    );
  }
}
