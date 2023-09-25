// ignore_for_file: file_names

import 'package:flutter/material.dart';

void warning(text, context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: const Duration(seconds: 2),
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

void notifcation(text, context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: const Duration(seconds: 2),
      elevation: 6,
      backgroundColor: const Color.fromARGB(255, 53, 229, 214),
      content: Center(child: Text(text)),
      action: SnackBarAction(
        textColor: Colors.white,
        label: '',
        onPressed: () {},
      ),
    ),
  );
}
