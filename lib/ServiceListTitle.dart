// ignore_for_file: no_leading_underscores_for_local_identifiers, unused_element

import 'package:flutter/material.dart';
import 'package:service_manager/database.dart';
import 'package:service_manager/payloadCollection.dart';
import 'package:service_manager/showDialog.dart';
import 'package:service_manager/terminalCommand.dart';
import 'dart:convert';

class ServiceListTitle extends StatefulWidget {
  const ServiceListTitle({super.key});

  @override
  State<ServiceListTitle> createState() => _ServiceListTitleState();
}

class _ServiceListTitleState extends State<ServiceListTitle> {
  Map servicesStateColorList = {};
  List serversWithServices = [];
  Map servicesButtonText = {};
  Map servicesButtonColor = {};

  void _updateServiceStateColor(serverIp, index) {
    servicesStateColorList[serverIp][index] = (servicesStateColorList[serverIp]
                [index] ==
            PayloadCollection.offlineServiceStateColor)
        ? PayloadCollection.offlineServiceStateColor
        : PayloadCollection.onlineServiceStateColor;
    setState(() {});
  }

  void _toggleLeadingText(serverIp, index) {
    // Update the state variable
    servicesButtonText[serverIp][index] =
        (servicesButtonText[serverIp][index] == '_Stop_')
            ? '_Start_'
            : '_Stop_';

    servicesButtonColor[serverIp][index] = (servicesButtonColor[serverIp]
                [index] ==
            PayloadCollection.stoppedButtonColor)
        ? PayloadCollection.startedButtonColor
        : PayloadCollection.stoppedButtonColor;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getServerListWithService();
  }

  void getServerListWithService() async {
    final serverList = await DataBase().getServerList();

    Map _buttonColor = {};
    Map _buttonText = {};
    Map _serviceStateColor = {};
    print(serverList);
    for (var server in serverList) {
      if (server['services']!.isNotEmpty) {
        final List services = server['services'];
        final int serviceCount = services.length;
        final List<String> buttonTextList =
            List.generate(serviceCount, (_) => '_Start_');
        final List<Color> buttonColorList = List.generate(
            serviceCount, (_) => PayloadCollection.startedButtonColor);
        final List<Color> serviceStateColorList = List.generate(
            serviceCount, (_) => PayloadCollection.offlineServiceStateColor);
        // Initialize lists if they don't exist
        _buttonText[server["ipAddress"]] ??= [];
        _buttonColor[server["ipAddress"]] ??= [];
        _serviceStateColor[server["ipAddress"]] ??= [];
        _buttonText[server["ipAddress"]].addAll(buttonTextList);
        _buttonColor[server["ipAddress"]].addAll(buttonColorList);
        _serviceStateColor[server["ipAddress"]].addAll(serviceStateColorList);

        serversWithServices.add(server);
      }
    }
    setState(() {});
    servicesStateColorList = _serviceStateColor;
    servicesButtonText = _buttonText;
    servicesButtonColor = _buttonColor;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: serversWithServices.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              ListTile(
                title: ElevatedButton(
                    child: Text(serversWithServices[index]['ipAddress']),
                    onPressed: () {}),
              ),
              Container(
                  color: const Color.fromARGB(175, 88, 130, 150),
                  height: serversWithServices[index]['services'].length < 3
                      ? 80
                      : 180,
                  child: serviceListView(
                      index, serversWithServices[index]['ipAddress'])),
            ],
          );
        });
  }

  ListView serviceListView(serverIndex, serverIp) {
    return ListView.builder(
      itemCount: serversWithServices[serverIndex]['services'].length,
      itemBuilder: (context, index) {
        return ListTile(
          title: GestureDetector(
            onLongPress: () async {
              // await showMyDialog(
              //   context,
              //   'services[index].toString()',
              //   'Are you sure to delete  service?',
              //   '',
              //   'delete service',
              //   'serviceList',
              // );
            },
            child: Text(
              serversWithServices[serverIndex]['services'][index],
              textAlign: TextAlign.center,
            ),
          ),
          leading: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: servicesButtonColor[serverIp][index]),
            child: Text(servicesButtonText[serverIp][index]),
            onPressed: () {
              _toggleLeadingText(serverIp, index);
            },
          ),
          trailing: Padding(
            padding: const EdgeInsets.only(right: 40.0),
            child: Icon(Icons.radio_button_on_outlined,
                color: servicesStateColorList[serverIp][index]),
          ),
        );
      },
    );
  }
}
