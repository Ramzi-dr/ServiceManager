import 'package:flutter/material.dart';

void warning(text,context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: Duration(seconds: 1),
      elevation: 6,
      backgroundColor: Colors.red.shade600,
      content: Text(text),
      action: SnackBarAction(
        textColor: Colors.white,
        label: '',
        onPressed: () {},
      ),
    ),
  );
}
