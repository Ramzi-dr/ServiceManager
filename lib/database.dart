import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class DataBase {
  late SharedPreferences prefs;

  // Singelton pattern
  static final DataBase _instance = DataBase._internal();

  factory DataBase() {
    _instance.init();
    return _instance;
  }
  DataBase._internal();

  //Initialize SharedPreferences
  Future init() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future clearDatabase() async {
    prefs.clear();
  }

  Future<List<Map<String, dynamic>>> getServerList() async {
    final prefs = await SharedPreferences.getInstance();
    final serverList = prefs.getStringList('appServersList') ?? [];
    final decodedServerList =
        serverList.map((serverJson) => jsonDecode(serverJson)).toList();
    return decodedServerList.cast<Map<String, dynamic>>();
  }

  Future<void> updateServerList(serverIp, port, userName, password) async {
    final prefs = await SharedPreferences.getInstance();
    final serverList = prefs.getStringList('appServersList') ?? [];

    // Check if a server with the given ipAddress already exists
    final serverIndex = serverList.indexWhere((serverJson) {
      final serverData = jsonDecode(serverJson);
      return serverData['ipAddress'] == serverIp;
    });

    if (serverIndex != -1) {
      // Server already exists, update its port and password
      final existingServer = jsonDecode(serverList[serverIndex]);
      existingServer['port'] = port;
      existingServer['password'] = password;
      existingServer['userName'] = userName;
      serverList[serverIndex] = jsonEncode(existingServer);
    } else {
      // Server does not exist, create a new server entry
      final newServer = {
        'ipAddress': serverIp,
        'port': port,
        'userName': userName,
        'password': password,
        'services': [],
      };
      serverList.add(jsonEncode(newServer));
    }

    // Save the updated serverList back to SharedPreferences
    await prefs.setStringList('appServersList', serverList);
  }

  Future<void> addServerStatusToExistingServers(
      String serverIp, String serverStatus) async {
    final prefs = await SharedPreferences.getInstance();
    final serverList = prefs.getStringList('appServersList') ?? [];

    for (int i = 0; i < serverList.length; i++) {
      final serverData = jsonDecode(serverList[i]);
      if (serverData['ipAddress'] == serverIp) {
        serverData['serverStatus'] = serverStatus;
        serverList[i] = jsonEncode(serverData);
        break; // Exit the loop once the server is updated
      }
    }

    // Save the updated serverList back to SharedPreferences
    await prefs.setStringList('appServersList', serverList);
    print(serverList);
  }

  Future<void> updateServiceList(
      List<String> serverIPs, String serviceName) async {
    final prefs = await SharedPreferences.getInstance();
    final serverList = prefs.getStringList('appServersList') ?? [];

    // Update the services for each server with the specified IPs
    for (var serverIP in serverIPs) {
      final serverIndex = serverList.indexWhere((serverJson) {
        final serverData = jsonDecode(serverJson);
        return serverData['ipAddress'] == serverIP;
      });

      if (serverIndex != -1) {
        final serverData = jsonDecode(serverList[serverIndex]);
        final services = serverData['services'] as List<dynamic>;

        // Check if the service name already exists in the server's services list
        if (!services.contains(serviceName)) {
          services.add(serviceName);
          serverData['services'] = services;
          serverList[serverIndex] = jsonEncode(serverData);
        }
      }
    }

    // Save the updated serverList back to SharedPreferences
    await prefs.setStringList('appServersList', serverList);
  }

  Future<String?> getPasswordByServerIp(String serverIp) async {
    final prefs = await SharedPreferences.getInstance();
    final serverList = prefs.getStringList('appServersList') ?? [];

    // Find the server with the given IP address
    final serverData = serverList.firstWhere(
      (serverJson) {
        final server = jsonDecode(serverJson);
        return server['ipAddress'] == serverIp;
      },
      orElse: () => '',
    );

    if (serverData.isNotEmpty) {
      final server = jsonDecode(serverData);
      return server['password'];
    } else {
      // Server with the given IP not found
      return null;
    }
  }

  Future checkIfServerExist(serverIp) async {
    final prefs = await SharedPreferences.getInstance();
    final serverList = prefs.getStringList('appServersList') ?? [];

    // Check if a server with the given ipAddress already exists
    final serverIndex = serverList.indexWhere((serverJson) {
      final serverData = jsonDecode(serverJson);
      return serverData['ipAddress'] == serverIp;
    });

    if (serverIndex != -1) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> deleteServiceFromServer(
      String serverIP, String serviceName) async {
    final prefs = await SharedPreferences.getInstance();
    final serverList = prefs.getStringList('appServersList') ?? [];

    // Decode the entire list of server data
    final decodedServerList =
        serverList.map((serverJson) => jsonDecode(serverJson)).toList();

    // Find the server data by IP address
    final serverDataIndex = decodedServerList.indexWhere(
      (server) => server['ipAddress'] == serverIP,
    );

    if (serverDataIndex == -1) {
      // Server not found, return early
      return;
    }

    final serverData = decodedServerList[serverDataIndex];
    final services = serverData['services'] as List<dynamic>?;

    if (services != null) {
      // Check if the service name exists in the server's services list
      if (services.contains(serviceName)) {
        services.remove(serviceName); // Remove the service name
        serverData['services'] =
            services; // Update the services list in serverData
      }
    }

    // Update the server data in the list
    decodedServerList[serverDataIndex] = serverData;

    // Encode the updated server data and save it back to SharedPreferences
    final updatedServerList =
        decodedServerList.map((server) => jsonEncode(server)).toList();
    await prefs.setStringList('appServersList', updatedServerList);
  }

  Future<void> deleteServer(String serverIP) async {
    final prefs = await SharedPreferences.getInstance();
    final serverList = prefs.getStringList('appServersList') ?? [];

    // Decode the entire list of server data
    final decodedServerList =
        serverList.map((serverJson) => jsonDecode(serverJson)).toList();

    // Find the index of the server data by IP address
    final serverDataIndex = decodedServerList.indexWhere(
      (server) => server['ipAddress'] == serverIP,
    );

    if (serverDataIndex != -1) {
      // Remove the server data with the specified IP address
      decodedServerList.removeAt(serverDataIndex);

      // Encode the updated server data and save it back to SharedPreferences
      final updatedServerList =
          decodedServerList.map((server) => jsonEncode(server)).toList();
      await prefs.setStringList('appServersList', updatedServerList);
    }
  }
}
