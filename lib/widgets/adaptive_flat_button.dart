import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptiveFlatButton extends StatelessWidget {
  final Function clickHandler;

  final String text;

  AdaptiveFlatButton({this.clickHandler, this.text});

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoButton(
            onPressed: clickHandler,
            child: Text(
              text,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            // color: Theme.of(context).primaryColor,
          )
        : FlatButton(
            onPressed: clickHandler,
            child: Text(
              text,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            textColor: Theme.of(context).primaryColor,
          );
  }
}
