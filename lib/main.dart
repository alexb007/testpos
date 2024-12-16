import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testorders/screens/home/home.dart';

import 'data/database.dart';
import 'screens/home/home_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dbProvider = AppDatabase.instance;

  // Access database
  final db = await dbProvider.database;

  // Query Tables
  final tables = await db.query('Table');
  print('Tables: $tables');

  // Query Products
  final products = await db.query('Product');
  print('Products: $products');

  // Query Orders
  final orders = await db.query('"Order"');
  print('Orders: $orders');

  // Query OrderProducts
  final orderProducts = await db.query('OrderProduct');
  print('Order Products: $orderProducts');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test Ordering App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: BlocProvider<HomeBloc>(
        create: (context) => HomeBloc()..add(const LoadHome()),
        child: HomeScreen(),
      ),
    );
  }
}
