import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expense_tracker/widgets/chart.dart';
import 'package:flutter_expense_tracker/widgets/new_transaction.dart';

import 'models/transaction.dart';
import 'widgets/transactions_list.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp, DeviceOrientation.portraitDown,
  // ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses',
      home: MyHomePage(),
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.amber,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
              button: TextStyle(
                color: Colors.white,
              ),
              title: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                title: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> transactions = [
    Transaction(id: '1', title: "Shoes", amount: 90.99, date: DateTime.now()),
    Transaction(id: '2', title: "Rent", amount: 909.99, date: DateTime.now()),
    Transaction(id: '2', title: "Rent", amount: 99.99, date: DateTime.now()),
    Transaction(id: '2', title: "Rent", amount: 909.99, date: DateTime.now()),
    Transaction(id: '2', title: "Rent", amount: 909.99, date: DateTime.now()),
    Transaction(id: '2', title: "Rent", amount: 909.99, date: DateTime.now()),
  ];
  bool _showChart = true;

  List<Transaction> get _recentTransactions => transactions
      .where((element) =>
          element.date.isAfter(DateTime.now().subtract(Duration(days: 7))))
      .toList();

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final PreferredSizeWidget appBar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text(
              'Personal Expenses',
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () => showNewTransactionSheet(context),
                  child: Icon(CupertinoIcons.add),
                ),
              ],
            ),
          )
        : AppBar(
            title: Text(
              'Personal Expenses',
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () => showNewTransactionSheet(context),
              )
            ],
          );
    final showChartSwitch = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Show Chart',
          style: Theme.of(context).textTheme.title,
        ),
        Switch.adaptive(
          activeColor: Theme.of(context).accentColor,
          value: _showChart,
          onChanged: (value) => setState(() => _showChart = value),
        )
      ],
    );
    final availableHeight = MediaQuery.of(context).size.height -
        appBar.preferredSize.height -
        MediaQuery.of(context).padding.top;

    final body = SafeArea(
        child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (isLandscape) showChartSwitch,
          if (!isLandscape || _showChart)
            Container(
              height: (availableHeight) * (isLandscape ? 0.7 : 0.3),
              child: Chart(_recentTransactions),
            ),
          if (!isLandscape || !_showChart)
            Container(
                height: availableHeight * (isLandscape ? 1 : 0.7),
                child: TransactionsList(transactions, _deleteTransaction)),
        ],
      ),
    ));
    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: body,
            navigationBar: appBar,
          )
        : Scaffold(
            appBar: appBar,
            body: body,
            floatingActionButton: (Platform.isIOS)
                ? Container()
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () => showNewTransactionSheet(context),
                  ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
  }

  void showNewTransactionSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (ctx) {
          return NewTransaction(_addNewTransaction);
        });
  }

  void _addNewTransaction(String title, double amount, DateTime dateTime) {
    final newTx = Transaction(
      id: DateTime.now().toString(),
      title: title,
      amount: amount,
      date: dateTime,
    );
    setState(() {
      transactions.add(newTx);
    });
  }

  void _deleteTransaction(String id) {
    setState(() {
      transactions.removeWhere((element) => element.id == id);
    });
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text("Transaction deleted."),
    ));
  }
}
