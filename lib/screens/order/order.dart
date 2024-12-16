import 'package:flutter/material.dart';
import 'package:testorders/data/models/table.dart';

class OrderScreen extends StatefulWidget {
  final TableModel table;
  OrderScreen({super.key, required this.table});

  @override
  _OrderScreenState createState() {
    return _OrderScreenState();
  }
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("Order"),
    );
  }
}
