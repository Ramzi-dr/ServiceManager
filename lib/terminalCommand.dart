import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:dartssh2/dartssh2.dart';
import 'package:service_manager/database.dart';
import 'package:service_manager/showDialog.dart';
import 'package:flutter/material.dart';

class CheckServicesState {
  Future serversChecker(context) async {
    final serverList = await DataBase().getServerList();
    if (serverList.isNotEmpty) {
      for (var server in serverList) {
        String serverIp = server['ipAddress'];
        int port = int.parse(server['port']);
        String userName = server['userName'];
        String password = server['password'];

        try {
          final socket = await SSHSocket.connect(serverIp, port);

          final client = SSHClient(
            socket,
            username: userName,
            onPasswordRequest: () => password,
          );
          await client.authenticated;
          print(client.remoteVersion);

          if (client.isClosed == false) {
            await DataBase()
                .addServerStatusToExistingServers(serverIp, 'online');
          }
          client.close();
        } catch (e) {
          await DataBase()
              .addServerStatusToExistingServers(serverIp, 'offline');
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text(
                  style: const TextStyle(
                      color: Colors.red, fontWeight: FontWeight.bold),
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
    }
    return DataBase().getServerList();
  }
}

// Future toDoCommand(String command, String serviceName) async {
//   final socket = await SSHSocket.connect(serverIp, 8022);

//   final client = SSHClient(
//     socket,
//     username: sshUserName ?? '',
//     onPasswordRequest: () => sshPassword,
//   );

//   final res = await client
//       .run('echo $sshPassword | sudo -S systemctl $command $serviceName');

//   print("\n");
//   print(utf8.decode(res));

//   client.close();
//   await client.done;
// }

Future startService(serviceName) async {
  // Replace with your service name

  final commandToRun = 'systemctl start $serviceName';

  final process = await Process.start(
    'bash',
    ['-c', commandToRun],
  );

  final stdout = await process.stdout.transform(utf8.decoder).join();
  final stderr = await process.stderr.transform(utf8.decoder).join();

  final exitCode = await process.exitCode;

  // Check if the service is active or not in the stdout
  final isServiceOnline = stdout.contains('Active: active (running)');

  // Print the result
  print('$serviceName: ${isServiceOnline ? 'online' : 'offline'}');

  // Print any errors or exit code if needed
  if (stderr.isNotEmpty) {
    print('stderr: $stderr');
  }

  if (exitCode != 0) {
    print('Exit code: $exitCode');
  }
}
