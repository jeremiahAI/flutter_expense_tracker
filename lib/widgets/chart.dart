import 'package:flutter/material.dart';
import 'package:flutter_expense_tracker/models/transaction.dart';
import 'package:intl/intl.dart';

import 'chart_bar.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  Chart(this.recentTransactions);

  double get totalSpendAmount =>
    recentTransactions.fold(0.0, (previousValue, element) => previousValue+element.amount);



  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7, (index) {
      final weekday = DateTime.now().subtract(Duration(days: index));
      double amount = 0.0;
      recentTransactions.forEach((element) {
        if (element.date.day == weekday.day &&
            element.date.year == weekday.year &&
            element.date.month == weekday.month) {
          amount += element.amount;
        }
      });
      return {
        'day': DateFormat.E().format(weekday).substring(0, 1),
        'amount': amount
      };
    }).reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactionValues
              .map((data) => Flexible(
            fit: FlexFit.tight,
                child: ChartBar(
                      label: data['day'],
                      spendingAmount: data['amount'],
                      spendingPercent:
                      (totalSpendAmount!=0.0)?(data['amount'] as double) / totalSpendAmount:0.0,
                    ),
              ))
              .toList(),
        ),
      ),
    );
  }
}
