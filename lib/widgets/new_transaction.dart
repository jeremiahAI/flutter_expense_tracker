import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'adaptive_flat_button.dart';

class NewTransaction extends StatefulWidget {
  final Function(String, double, DateTime) addNewTransaction;

  NewTransaction(this.addNewTransaction);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();

  final _amountController = TextEditingController();

  DateTime selectedDate;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Platform.isIOS
                  ? CupertinoTextField(
                      placeholder: "Title",
                      controller: _titleController,
                      textInputAction: TextInputAction.next,
                      onSubmitted: (_) => _submit(),
                    )
                  : TextField(
                      decoration: InputDecoration(labelText: "Title"),
                      controller: _titleController,
                      textInputAction: TextInputAction.next,
                      onSubmitted: (_) => _submit(),
                    ),
              SizedBox(
                height: 4,
              ),
              Platform.isIOS
                  ? CupertinoTextField(
                      placeholder: "Amount",
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      onSubmitted: (_) => _submit(),
                    )
                  : TextField(
                      decoration: InputDecoration(labelText: "Amount"),
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      onSubmitted: (_) => _submit(),
                    ),
              Container(
                height: 70,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(selectedDate == null
                          ? "No date chosen!"
                          : DateFormat.yMMMd().format(selectedDate)),
                    ),
                    AdaptiveFlatButton(
                      text: "Choose Date",
                      clickHandler: _showDatePicker,
                    ),
                  ],
                ),
              ),
              Platform.isIOS
                  ? CupertinoButton(
                      child: Text("Add Transaction"),
                      onPressed: _submit,
                      color: Theme.of(context).primaryColor,
                      // textColor: Theme.of(context).textTheme.button.color,
                      // color: Theme.of(context).primaryColor,
                    )
                  : RaisedButton(
                      child: Text("Add Transaction"),
                      onPressed: _submit,
                      color: Theme.of(context).primaryColor,
                      textColor: Theme.of(context).textTheme.button.color,
                    )
            ],
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (_titleController.text.isNotEmpty &&
        _amountController.text.isNotEmpty &&
        selectedDate != null) {
      widget.addNewTransaction(_titleController.text,
          double.tryParse(_amountController.text), selectedDate);
      Navigator.of(context).pop();
    }
  }

  void _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    ).then((date) {
      if (date != null) {
        setState(() {
          selectedDate = date;
        });
      }
    });
  }
}
