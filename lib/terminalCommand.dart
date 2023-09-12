import 'dart:io';

///get the list of services
Future checkServiceInServicesList(serviceName) async {
  bool exist = false;
  final result =
      await Process.run('systemctl', ['list-units', '--type=service']);

  final output = result.stdout;
  print(output);
  // Define a regular expression pattern to match service names
  final pattern = RegExp(r'(\S+)\.service\s+(\S+)\s+(\S+)\s+(\S+)\s+(.+)');

  // Search for the service name in the lines using the pattern
  final matches = pattern.allMatches(output);

  for (final match in matches) {
    final serviceNameInOutput = match.group(1);

    if (serviceNameInOutput == serviceName) {
      exist = true;
    }
  }
  return exist;
}

Future startService(String serviceName) async {
  final result = await Process.run('sudo', ['systemctl', 'start', serviceName]);
  print(result.stdout);
  print(result.stderr);
}

Future stopService(String serviceName) async {
  final result = await Process.run('sudo', ['systemctl', 'stop', serviceName]);
  print(result.stdout);
  print(result.stderr);
}
