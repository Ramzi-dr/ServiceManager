import 'package:flutter/material.dart';
import 'package:service_manager/createServiceStopStarter.dart';
import 'package:service_manager/database.dart';
import 'package:service_manager/homePage.dart';
import 'package:service_manager/payloadCollection.dart';

Future<void> showMyDialog(context, title, text_1, text_2, confirmVoid, listName,
    [index, serverInfo]) async {
  
  return showDialog<void>(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Center(
          child: Text(
            (title) == Null ? "" : title,
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
                  (text_1 == Null) ? "" : text_1,
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
              ),
              Text((text_2 == Null) ? "" : text_2),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Confirm'),
            onPressed: () {
              if (confirmVoid == 'delete service') {
                deleteService(listName, title);
                Navigator.pushNamed(context, HomePage.id);
              } else if (confirmVoid == 'delete server') {
                deleteServer(
                    PayloadCollection.serverListName, index, serverInfo);

                Navigator.pushNamed(context, CreateServiceStopStarter.id);
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

deleteService(listName, serviceToDelete) async {
  DataBase().deleteFromList(listName, serviceToDelete);
}

deleteServer(serverListName, serverIndex, [serverInfo]) async {
  String serverIp = '';

  var serviceInfoMap =
      await DataBase().getServiceInfoMap(PayloadCollection.serviceInfoMapName);

  serverInfo.forEach((key, value) {
    serverIp = key;
  });
  print(serverIp);
  await DataBase().deleteServerInfoFromServerList(serverListName, serverIndex);

  serviceInfoMap.forEach((key, value) {
    for (var item in value) {
      if (item is Map) {
        item.forEach((key, value) async {
          print(key);
          if (key == serverIp) {
            await DataBase().deleteServiceInfoForKey(
                PayloadCollection.serviceInfoMapName, key);

            //await DataBase().deleteFromList(serverListName, key);
          }
        });
      }
    }
  });
}
