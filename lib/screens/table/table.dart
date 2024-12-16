import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testorders/data/models/order.dart';
import 'package:testorders/data/models/order_product.dart';
import 'package:testorders/data/repositories/order_product_repository.dart';
import 'package:testorders/data/repositories/order_repository.dart';
import 'package:testorders/screens/order/order.dart';
import 'package:testorders/screens/order/order_bloc.dart';
import 'package:testorders/screens/table/table_bloc.dart';

import 'products_bloc.dart';

class TableScreen extends StatefulWidget {
  final int id;
  const TableScreen({super.key, required this.id});

  @override
  _TableScreenState createState() {
    return _TableScreenState();
  }
}

class _TableScreenState extends State<TableScreen> {
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
    return BlocProvider<TableBloc>(
      create: (context) => TableBloc()..add(LoadTable(widget.id)),
      child: Scaffold(
        appBar: AppBar(
          title: BlocBuilder<TableBloc, TableState>(builder: (context, state) {
            if (state is TableLoaded) {
              return Text("Стол ${state.table.title}");
            }
            return const SizedBox();
          }),
          actions: [],
        ),
        body: BlocBuilder<TableBloc, TableState>(builder: (context, state) {
          if (state is TableLoaded) {
            return Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.activeOrder?.orderedProducts.length ?? 0,
                      itemBuilder: (BuildContext context, int index) {
                        final product =
                            state.activeOrder!.orderedProducts[index];
                        return ListTile(
                          title: Text(
                            product.product?.title ?? '',
                          ),
                          trailing: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  if (product.amount > 0) {
                                    if (product.amount == 1) {
                                      await OrderProductRepository()
                                          .deleteOrderProduct(product.id!);
                                    } else {
                                      await OrderProductRepository()
                                          .updateOrderProduct(product.copyWith(
                                              amount: product.amount - 1));
                                    }
                                    BlocProvider.of<TableBloc>(context)
                                        .add(LoadTable(widget.id));
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.zero),
                                child: const Icon(Icons.exposure_minus_1),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                product.amount.toInt().toString(),
                                style: const TextStyle(fontSize: 18),
                              ),
                              const SizedBox(width: 4),
                              ElevatedButton(
                                onPressed: () async {
                                  await OrderProductRepository()
                                      .updateOrderProduct(product.copyWith(
                                          amount: product.amount + 1));
                                  BlocProvider.of<TableBloc>(context)
                                      .add(LoadTable(widget.id));
                                },
                                style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.zero),
                                child: const Icon(Icons.exposure_plus_1),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: BlocProvider<ProductsBloc>(
                        create: (context) =>
                            ProductsBloc()..add(const LoadProducts(null)),
                        child: BlocBuilder<ProductsBloc, ProductsState>(
                            builder: (context, pState) {
                          if (pState is ProductsLoaded) {
                            print(pState.products);
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  height: 100,
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: pState.groups
                                        .map(
                                          (e) => InkWell(
                                            onTap: () {
                                              BlocProvider.of<ProductsBloc>(
                                                      context)
                                                  .add(LoadProducts(e));
                                            },
                                            child: Container(
                                              decoration: const BoxDecoration(
                                                color: Colors.orange,
                                              ),
                                              padding: const EdgeInsets.all(8),
                                              margin: const EdgeInsets.fromLTRB(
                                                  8, 8, 0, 8),
                                              child: Center(
                                                child: Text(e.title),
                                              ),
                                            ),
                                          ),
                                        )
                                        .toList(growable: false),
                                  ),
                                ),
                                Expanded(
                                  child: GridView.count(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8),
                                    childAspectRatio: 240 / 100,
                                    mainAxisSpacing: 8,
                                    crossAxisSpacing: 8,
                                    crossAxisCount: 2,
                                    children: pState.products
                                        .map(
                                          (e) => InkWell(
                                            onTap: () async {
                                              if (state.activeOrder != null) {
                                                final op = state.activeOrder!
                                                    .orderedProducts
                                                    .where((op) =>
                                                        op.productId == e.id);
                                                if (op.isNotEmpty) {
                                                  await OrderProductRepository()
                                                      .updateOrderProduct(
                                                          op.first.copyWith(
                                                              amount: op.first
                                                                      .amount +
                                                                  1));
                                                } else {
                                                  await OrderProductRepository()
                                                      .addOrderProduct(
                                                    OrderProduct(
                                                      null,
                                                      state.activeOrder!.id!,
                                                      e.id,
                                                      1,
                                                      DateTime.now(),
                                                      null,
                                                    ),
                                                  );
                                                }
                                              } else {
                                                final orderId =
                                                    await OrderRepository()
                                                        .addOrder(Order(
                                                            null,
                                                            widget.id,
                                                            DateTime.now(),
                                                            null));
                                                await OrderProductRepository()
                                                    .addOrderProduct(
                                                  OrderProduct(
                                                    null,
                                                    orderId,
                                                    e.id,
                                                    1,
                                                    DateTime.now(),
                                                    null,
                                                  ),
                                                );
                                              }
                                              BlocProvider.of<TableBloc>(
                                                      context)
                                                  .add(LoadTable(widget.id));
                                            },
                                            child: Container(
                                              color: Colors.grey,
                                              child: Center(
                                                child: Row(
                                                  children: [
                                                    SizedBox(width: 8),
                                                    Text(e.title),
                                                    Spacer(),
                                                    Text(e.price.toString()),
                                                    SizedBox(width: 8),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                        .toList(growable: false),
                                  ),
                                ),
                              ],
                            );
                          }
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }),
                      ),
                    ),
                  ),
                  Container(
                    height: 100,
                    child: Row(
                      children: [
                        const SizedBox(width: 8),
                        const Text('Поиск'),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextFormField(
                            decoration: const InputDecoration(
                              suffixIcon: Icon(Icons.search),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        }),
      ),
    );
  }
}
