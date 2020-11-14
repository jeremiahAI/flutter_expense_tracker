import 'package:flutter/material.dart';
import 'package:flutter_expense_tracker/models/transaction.dart';
import 'package:intl/intl.dart';

class TransactionItem extends StatelessWidget {
  const TransactionItem({
    Key key,
    @required this.tx,
    @required this.deleteTransaction,
  }) : super(key: key);

  final Transaction tx;
  final Function(String id) deleteTransaction;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
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
              child:
                  FittedBox(child: Text("\$${tx.amount.toStringAsFixed(2)}")),
            ),
          ),
          title: Text(
            tx.title,
            style: Theme.of(context).textTheme.title,
          ),
          subtitle: Text(DateFormat.yMMMd().format(tx.date)),
          trailing: (MediaQuery.of(context).size.width < 460)
              ? IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => deleteTransaction(tx.id),
                  color: Theme.of(context).errorColor,
                )
              : FlatButton.icon(
                  textColor: Theme.of(context).errorColor,
                  icon: const Icon(Icons.delete),
                  label: const Text("Delete"),
                  onPressed: () => deleteTransaction(tx.id),
                ),
        ),
      ),
    );
  }
}
