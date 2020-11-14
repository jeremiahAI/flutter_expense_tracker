import 'package:flutter/material.dart';
import 'package:flutter_expense_tracker/models/transaction.dart';
import 'package:intl/intl.dart';

import 'transaction_item.dart';

class TransactionsList extends StatelessWidget {
  List<Transaction> transactions;

  final Function(String) deleteTransaction;

  TransactionsList(this.transactions, this.deleteTransaction);

  @override
  Widget build(BuildContext context) {
    return (transactions.isEmpty)
        ? LayoutBuilder(
            builder: (context, constraints) => Column(
              children: [
                Text(
                  "No transactions added yet!",
                  style: Theme.of(context).textTheme.title,
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                    height: constraints.maxHeight * 0.6,
                    child: Image.asset(
                      'assets/images/waiting.png',
                      fit: BoxFit.cover,
                    ))
              ],
            ),
          )
        : ListView.builder(
            itemBuilder: (context, index) {
              Transaction tx = transactions[index];

              return TransactionItem(
                tx: tx,
                deleteTransaction: deleteTransaction,
              );
            },
            itemCount: transactions.length,
          );
  }
}
