import 'package:flutter/material.dart';

class ProductDetailsScreen extends StatelessWidget {
  final String title;
  const ProductDetailsScreen(this.title, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
    );
  }
}
