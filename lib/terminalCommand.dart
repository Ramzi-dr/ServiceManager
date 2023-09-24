// ignore: file_names
import 'dart:async';
import 'dart:convert';
import 'package:dartssh2/dartssh2.dart';
import 'package:service_manager/database.dart';
import 'package:flutter/material.dart';

class CheckServicesState {
  Future serversChecker(context) async {
    List<Map<String, dynamic>> dataToStore = [];
    final serverList = await DataBase().getServerList();
    String stop = '   _Stop_    ';
    String start = '   _Start_   ';
    String notFound = 'NotFound';

    if (serverList.isNotEmpty) {
      for (var server in serverList) {
        String serverIp = server['ipAddress'];
        int port = int.parse(server['port']);
        String userName = server['userName'];
        String password = server['password'];
        List<dynamic> serviceList =
            server['services']; // Existing list for services
        String serverState = '';

        try {
          final socket = await SSHSocket.connect(serverIp, port);

          final client = SSHClient(
            socket,
            username: userName,
            onPasswordRequest: () => password,
          );
          serverState = 'online';
          if (serviceList.isNotEmpty) {
            for (var i = 0; i < serviceList.length; i++) {
              var service = serviceList[i];
              final res = await client
                  .run('echo $password | sudo -S systemctl status $service');
              var response = utf8.decode(res);
              var state = '';
              if (response.contains("Active: active (running)")) {
                state = 'active';
              } else if (response.contains("Active: inactive (dead)")) {
                state = 'inactive';
              } else {
                state = 'notFound';
              }

              serviceList[i] = {
                'serviceName': service,
                'serviceState': state,
                'serviceButtonText': state == 'active'
                    ? stop
                    : state == 'inactive'
                        ? start
                        : notFound,
                'serviceButtonColor': 'buttonColor',
                'serviceIconColor': 'iconColor'
              };
            }
          }
          client.close();
        } catch (e) {
          serverState = 'offline';
          if (serviceList.isNotEmpty) {
            for (var i = 0; i < serviceList.length; i++) {
              var service = serviceList[i];
              serviceList[i] = {
                'serviceName': service,
                'serviceState': 'offline',
                'serviceButtonText': 'offline',
                'serviceButtonColor': 'buttonColor',
                'serviceIconColor': 'iconColor'
              };
            }
          }

          serverErrorShowDialog(context, serverIp, port, e);
        }
        Map<String, dynamic> serverData = {
          'serverIp': serverIp,
          'serverState': serverState,
          'serviceList': serviceList,
        };
        dataToStore.add(serverData);
        DataBase().saveOrUpdateServersData(dataToStore);
      }
      return await DataBase().fetchData();
    }
  }

  Future<String> statusStartStopService(
    String serverIp,
    var service,
    String command,
  ) async {
    final serverList = await DataBase().getServerList();

    String userName = '';
    String password = '';
    int port = 0;
    for (var server in serverList) {
      if (server['ipAddress'] == serverIp) {
        userName = server['userName'];
        password = server['password'];
        port = int.parse(server['port']);
      }
    }

    final completer = Completer<String>(); // Create a Completer

    try {
      final socket = await SSHSocket.connect(serverIp, port);

      final client = SSHClient(
        socket,
        username: userName,
        onPasswordRequest: () => password,
      );

      await client.run('echo $password | sudo -S systemctl $command $service');

      Future.delayed(const Duration(seconds: 1), () async {
        final statusRes = await client
            .run('echo $password | sudo -S systemctl status $service');
        var response = utf8.decode(statusRes);

        client.close();

        if (response.contains("Active: active (running)")) {
          completer.complete('active'); // Resolve the Completer with 'active'
        } else if (response.contains("Active: inactive (dead)")) {
          completer
              .complete('inactive'); // Resolve the Completer with 'inactive'
        } else if (response.contains("could not be found")) {
          completer
              .complete('notFound'); // Resolve the Completer with 'notFound'
        } else {
          completer.complete('unknown'); // Handle other cases as needed
        }
      });
    } catch (e) {
      completer.completeError(e); // Resolve the Completer with an error
    }

    return completer.future; // Return the Future from the Completer
  }

  Future<String> serviceState(
    String serverIp,
    var service,
  ) async {
    final serverList = await DataBase().getServerList();

    String userName = '';
    String password = '';
    int port = 0;
    for (var server in serverList) {
      if (server['ipAddress'] == serverIp) {
        userName = server['userName'];
        password = server['password'];
        port = int.parse(server['port']);
      }
    }

    final completer = Completer<String>(); // Create a Completer

    try {
      final socket = await SSHSocket.connect(serverIp, port);

      final client = SSHClient(
        socket,
        username: userName,
        onPasswordRequest: () => password,
      );

      Future.delayed(const Duration(milliseconds: 200), () async {
        final statusRes = await client
            .run('echo $password | sudo -S systemctl status $service');
        var response = utf8.decode(statusRes);

        client.close();

        if (response.contains("Active: active (running)")) {
          completer.complete('active'); // Resolve the Completer with 'active'
        } else if (response.contains("Active: inactive (dead)")) {
          completer
              .complete('inactive'); // Resolve the Completer with 'inactive'
        } else if (response.contains("could not be found")) {
          completer
              .complete('notFound'); // Resolve the Completer with 'notFound'
        } else {
          completer.complete('unknown'); // Handle other cases as needed
        }
      });
    } catch (e) {
      completer.completeError(e); // Resolve the Completer with an error
    }

    return completer.future; // Return the Future from the Completer
  }

  Future<dynamic> serverErrorShowDialog(
      context, String serverIp, int port, Object e) {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
            style:
                const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            "error : $serverIp  : $port"),
        content: SizedBox(
          height: 60,
          child: Center(child: Text(e.toString())),
        ),
        actions: <Widget>[
          const SizedBox(
            height: 80,
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Container(
              padding: const EdgeInsets.all(14),
              child: const Text("return"),
            ),
          ),
        ],
      ),
    );
  }
}
