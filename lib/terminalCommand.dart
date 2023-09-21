import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:ssh2/ssh2.dart';

class CheckServicesState {
  CheckServicesState(
      {required this.serverIp,
      required this.serviceName,
      this.sshPort,
      this.sshPassword,
      this.sshUserName}) {
    isRemote = isRemoteCondition();
  }

  final List serviceName;
  final String serverIp;
  final int? sshPort;
  final String? sshPassword;
  final String? sshUserName;
  late bool isRemote;

  bool isRemoteCondition() {
    return serverIp != 'localServer';
  }

  Future serviceState() async {
    if (isRemote) {
      final client = SSHClient(
          host: serverIp,
          port: sshPort ?? 22,
          passwordOrKey: sshPassword,
          username: sshUserName ?? '');

      try {
        // Connect to the server
        await client.connect();

        // Execute a command to check if the service is running
        final result = await client.execute('systemctl is-active $serviceName');

        // Check the result
        if (result!.contains('active')) {
          print('The service is running.');
        } else {
          print('The service is not running.');
        }

        // Disconnect from the server
        await client.disconnect();
      } catch (e) {
        print('Error: $e');
      } finally {
        client.disconnect();
      }
    } else if (!isRemote) {
      final commandToRun = 'systemctl status $serviceName';

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
  }
}

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
