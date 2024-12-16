import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testorders/screens/orders/orders.dart';
import 'package:testorders/screens/tables/tables.dart';

import '../order/order.dart';
import 'home_bloc.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  _HomeScreenState createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
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
      body: BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
        if (state is HomeLoaded) {
          return state.page;
        }
        return const Center(child: CircularProgressIndicator());
      }),
      appBar: AppBar(),
      drawer: NavigationDrawer(children: [
        const DrawerHeader(child: Text('RestTest')),
        ListTile(
          title: const Text('Столы'),
          onTap: () {
            BlocProvider.of<HomeBloc>(context)
                .add(const ChangePage(TablesScreen()));
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: const Text('Заказы'),
          onTap: () {
            BlocProvider.of<HomeBloc>(context)
                .add(const ChangePage(OrdersScreen()));
            Navigator.pop(context);
          },
        ),
        const ListTile(
          title: Text('Продукты'),
        ),
      ]),
    );
  }
}
