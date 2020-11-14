import 'package:flutter/material.dart';
import 'package:flutter_expense_tracker/models/transaction.dart';
import 'package:intl/intl.dart';

class TransactionsList extends StatelessWidget {
  List<Transaction> transactions;

  final Function(String) deleteTransaction;

  TransactionsList(this.transactions, this.deleteTransaction);

  @override
  Widget build(BuildContext context) {
    return (transactions.isEmpty)
        ? LayoutBuilder(
          builder: (context,constraints)=>Column(
              children: [
                Text(
                  "No transactions added yet!",
                  style: Theme.of(context).textTheme.title,
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                    height: constraints.maxHeight*0.6,
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
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                elevation: 5,
                child: Dismissible(
                  key: Key(tx.id),
                  background: Container(
                    color: Colors.red,
                  ),
                  direction: DismissDirection.startToEnd,
                  onDismissed: (_) => deleteTransaction(tx.id),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FittedBox(
                            child: Text("\$${tx.amount.toStringAsFixed(2)}")),
                      ),
                    ),
                    title: Text(
                      tx.title,
                      style: Theme.of(context).textTheme.title,
                    ),
                    subtitle: Text(DateFormat.yMMMd().format(tx.date)),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => deleteTransaction(tx.id),
                      color: Theme.of(context).errorColor,
                    ),
                  ),
                ),
              );
            },
            itemCount: transactions.length,
          );
  }
}
