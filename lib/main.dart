import 'dart:io';
import 'package:expense_tracker/widgets/new_transactions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'models/transactions.dart';
import 'package:intl/intl.dart';
import '../widgets/transactions_list.dart';
import '../widgets/chart.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations(
  //     [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      theme: ThemeData(
        primarySwatch: Colors.brown,
        fontFamily: 'Quicksand',
        appBarTheme: AppBarTheme(
            titleTextStyle: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 20,
                fontWeight: FontWeight.bold)),
        textTheme: const TextTheme(
          titleMedium: TextStyle(
              fontFamily: 'OpenSans',
              fontWeight: FontWeight.bold,
              fontSize: 18),
        ),

        // How to add accentcolor?
        // accentColor: Colors.amber,
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Transactions> _userTransactions = [
    Transactions(
      id: 't1',
      title: 'New shoes',
      amount: 65.9,
      date: DateTime.now(),
    ),
    Transactions(
      id: 't2',
      title: 'New Bag',
      amount: 19.9,
      date: DateTime.now(),
    ),
    Transactions(
      id: 't3',
      title: 'New Laptop',
      amount: 40,
      date: DateTime.now(),
    ),
    Transactions(
      id: 't4',
      title: 'Groceries',
      amount: 25.5,
      date: DateTime(2023, 7, 20),
    ),
    Transactions(
      id: 't5',
      title: 'Movie Tickets',
      amount: 12.0,
      date: DateTime(2023, 7, 18),
    ),
    Transactions(
      id: 't6',
      title: 'Coffee',
      amount: 5.75,
      date: DateTime(2023, 7, 16),
    ),
    Transactions(
      id: 't7',
      title: 'Books',
      amount: 30.0,
      date: DateTime(2023, 7, 12),
    ),
    Transactions(
      id: 't8',
      title: 'Fitness Class',
      amount: 15.0,
      date: DateTime(2023, 7, 10),
    ),
    Transactions(
      id: 't9',
      title: 'Dinner',
      amount: 40.0,
      date: DateTime(2023, 7, 8),
    ),
    Transactions(
      id: 't10',
      title: 'Gardening Supplies',
      amount: 22.5,
      date: DateTime(2023, 7, 5),
    ),
  ];

  List<Transactions> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  bool _showChart = false;
  void _addNewTransaction(String title, double amount, DateTime chosenDate) {
    final newTx = Transactions(
      title: title,
      amount: amount,
      date: chosenDate,
      id: DateTime.now().toString(),
    );
    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _removeTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) => tx.id == id);
    });
  }

  void StatrtAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: NewTransaction(_addNewTransaction),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    final appBar = AppBar(
      title: Text("Expense Tracker"),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () => StatrtAddNewTransaction(context),
          icon: Icon(Icons.add),
        )
      ],
    );
    final txListWidget = Container(
      height: mediaQuery.size.height * 0.7 -
          appBar.preferredSize.height -
          mediaQuery.padding.top,
      child: TransactionsList(_userTransactions, _removeTransaction),
    );
    return Scaffold(
        appBar: appBar,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (isLandscape)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Show Chart",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Switch(
                        value: _showChart,
                        onChanged: (val) {
                          setState(() {
                            _showChart = val;
                          });
                        },
                      ),
                    ],
                  ),
                if (!isLandscape)
                  Container(
                    height: (mediaQuery.size.height -
                            appBar.preferredSize.height -
                            mediaQuery.padding.top) *
                        0.3,
                    child: Chart(_recentTransactions),
                  ),
                if (!isLandscape) txListWidget,
                if (isLandscape)
                  _showChart
                      ? Container(
                          height: (mediaQuery.size.height -
                                  appBar.preferredSize.height -
                                  mediaQuery.padding.top) *
                              0.7,
                          child: Chart(_recentTransactions),
                        )
                      : txListWidget,
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Platform.isIOS
            ? Container()
            : FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () => StatrtAddNewTransaction(context),
              ));
  }
}
