import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../table/table.dart';
import 'tables_bloc.dart';

class TablesScreen extends StatefulWidget {
  const TablesScreen({super.key});

  @override
  _TablesScreenState createState() {
    return _TablesScreenState();
  }
}

class _TablesScreenState extends State<TablesScreen> {
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
    return BlocProvider<TablesBloc>(
      create: (context) => TablesBloc()..add(const LoadTables()),
      child: Scaffold(
        body: BlocBuilder<TablesBloc, TablesState>(builder: (context, state) {
          if (state is TablesLoaded) {
            print(state.tables);
            return GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 1,
              children: state.tables
                  .map(
                    (e) => InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TableScreen(id: e.id),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                        ),
                        child: Center(
                          child: Text(e.title),
                        ),
                      ),
                    ),
                  )
                  .toList(growable: false),
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
