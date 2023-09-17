// ignore_for_file: no_leading_underscores_for_local_identifiers, unused_element

import 'package:flutter/material.dart';
import 'package:service_manager/database.dart';
import 'package:service_manager/payloadCollection.dart';
import 'package:service_manager/showDialog.dart';
import 'package:service_manager/style.dart';
import 'package:service_manager/terminalCommand.dart';
import 'dart:convert';
import 'package:collection/collection.dart';

class ServiceListTitle extends StatefulWidget {
  const ServiceListTitle({super.key});

  @override
  State<ServiceListTitle> createState() => _ServiceListTitleState();
}

class _ServiceListTitleState extends State<ServiceListTitle> {
  List servicesColorList = [];
  Map serverWithServices = {};
  List serversDetails = [];
  List serversIpPort = [];
  List servers = [];
  List services = [];
  List servicesButtonText = [];
  List servicesButtonColor = [];

  void _updateServiceStateColor(serverIndex, index) {
    servicesColorList[serverIndex][index] = (servicesColorList[serverIndex]
                [index] ==
            PayloadCollection.offlineServiceStateColor)
        ? PayloadCollection.offlineServiceStateColor
        : PayloadCollection.onlineServiceStateColor;
    setState(() {});
  }

  void _toggleLeadingText(serverIndex, index) {
    // Update the state variable
    servicesButtonText[serverIndex][index] =
        (servicesButtonText[serverIndex][index] == '_Stop_')
            ? '_Start_'
            : '_Stop_';

    servicesButtonColor[serverIndex][index] = (servicesButtonColor[serverIndex]
                [index] ==
            PayloadCollection.stoppedButtonColor)
        ? PayloadCollection.startedButtonColor
        : PayloadCollection.stoppedButtonColor;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getServiceMap();
  }

  void getServiceMap() async {
    Map originalMap = await DataBase()
        .getServiceInfoMap(PayloadCollection.serviceInfoMapName);
    Map<String, List<String>> result = {};

    originalMap.forEach((service, servers) {
      if (servers is List) {
        for (var server in servers) {
          if (server is String) {
            // Add the local server to the result
            result.putIfAbsent(server, () => []).add(service);
          } else if (server is Map) {
            server.forEach((serverIp, _) {
              result.putIfAbsent(serverIp, () => []).add(service);
            });
          }
        }
      }
    });
    List myServerIp = [];
    result.forEach((key, value) {
      myServerIp.add(key);
    });
    List serverDetailsList = [];
    var transformedServerDetailsList = [];

    originalMap.forEach((service, servers) {
      if (servers is List) {
        for (var server in servers) {
          if (server is Map) {
            var serverToJson = jsonEncode(server);
            if (!transformedServerDetailsList.contains(serverToJson)) {
              transformedServerDetailsList.add(serverToJson);
            }
          }
        }
      }
    });
    for (var _ in transformedServerDetailsList) {
      Map server = jsonDecode(_);

      serverDetailsList.add(server);
    }
    List myServer = [];
    Map serverIpPort = {};

    for (Map serverItem in serverDetailsList) {
      serverItem.forEach((ip, portSudo) {
        portSudo.forEach((port, sudo) {
          serverIpPort = {ip: port};
          myServer.add(serverIpPort);
        });
      });
    }
    List _servicesButtonColor = [];
    List _servicesButtonText = [];
    List _servicesButton = [];
    List _stateColor = [];
    result.forEach((key, value) {
      _servicesButton.add(value);
    });

    for (var innerList in _servicesButton) {
      List<String> updatedInnerList =
          List<String>.generate(innerList.length, (index) => '_Stop_');
      _servicesButtonText.add(updatedInnerList);

      List<Color> updateColor = List<Color>.generate(innerList.length,
          (index) => PayloadCollection.offlineServiceStateColor);
      _stateColor.add(updateColor);

      List<Color> updateButtonColor = List<Color>.generate(
          innerList.length, (index) => PayloadCollection.startedButtonColor);
      _servicesButtonColor.add(updateButtonColor);
    }

    setState(() {
      servicesButtonText = _servicesButtonText;
      servicesButtonColor = _servicesButtonColor;
      servicesColorList = _stateColor;
      serverWithServices = result;
      serversDetails = serverDetailsList;
      serversIpPort = myServer;
      servers = myServerIp;
    });
  }

  List extractServicesList(String server) {
    List listOfServices = [];

    serverWithServices.forEach((key, value) {
      if (key == server) {
        listOfServices = value;
      }
    });
    return listOfServices;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: servers.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              ListTile(
                title: ElevatedButton(
                    child: Text(servers[index]),
                    onPressed: () {
                      ;
                    }),
              ),
              Container(
                color: const Color.fromARGB(175, 88, 130, 150),
                height: extractServicesList(servers[index]).length < 3
                    ? 100
                    : 200,
                child: serviceListView(index),
              )
            ],
          );
        });
  }

  ListView serviceListView(serverIndex) {
    return ListView.builder(
      itemCount: extractServicesList(servers[serverIndex]).length,
      itemBuilder: (context, index) {
        return ListTile(
          title: GestureDetector(
            onLongPress: () {
              showMyDialog(
                  context,
                  services[index].toString(),
                  'Are you sure to delete  service?',
                  '',
                  'delete service',
                  'serviceList',
                  null);
            },
            child: Text(
              extractServicesList(servers[serverIndex])[index],
              textAlign: TextAlign.center,
            ),
          ),
          leading: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: servicesButtonColor[serverIndex][index]),
            child: Text(servicesButtonText[serverIndex][index]),
            onPressed: () {
              _toggleLeadingText(serverIndex, index);
            },
          ),
          trailing: Padding(
            padding: const EdgeInsets.only(right: 40.0),
            child: Icon(Icons.radio_button_on_outlined,
                color: servicesColorList[serverIndex][index]),
          ),
        );
      },
    );
  }
}
