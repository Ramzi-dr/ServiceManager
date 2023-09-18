import 'package:flutter/material.dart';
import 'package:service_manager/createServiceStopStarter.dart';
import 'package:service_manager/database.dart';
import 'package:service_manager/homePage.dart';
import 'package:service_manager/payloadCollection.dart';

Future<void> showMyDialog(context, title, action, List args) async {
  print(args[0]);
  print(args[1]);
  return showDialog<void>(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Center(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Center(
                child: Text(
                  (args[1] == null ? ' ' : args[1] as String),
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Confirm'),
            onPressed: () async {
              if (action == 'deleteServiceFromServer') {
                await DataBase().deleteServiceFromServer(
                    args[0] as String, args[1] as String);
                Navigator.pushNamed(context, HomePage.id);
              } else if (action == 'delete server') {
                await DataBase().deleteServer(args[0] as String);
                Navigator.pushNamed(context, HomePage.id);
              }
            },
          ),
          TextButton(
            child: const Text('Exist'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}
