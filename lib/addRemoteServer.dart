// ignore_for_file: unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:service_manager/bigButton.dart';
import 'package:service_manager/database.dart';
import 'package:service_manager/homePage.dart';
import 'package:service_manager/style.dart';
import 'package:service_manager/terminalCommand.dart';
import 'package:service_manager/warningMessage.dart';

class AddRemoteServer extends StatefulWidget {
  static const id = 'add remote server';
  const AddRemoteServer({super.key});

  @override
  State<AddRemoteServer> createState() => _AddRemoteServerState();
}

class _AddRemoteServerState extends State<AddRemoteServer> {
  String serverIp = '';
  String sshPort = '';
  Map serverMap = {};
  var focusNodeServerIp = FocusNode();
  var focusNodeSshPort = FocusNode();
  final serverIpController = TextEditingController();

  final sshPortController = TextEditingController();
  createButtonPressed() async {
    ''' if (sudoPassword.isNotEmpty) {
      DataBase().addKeyToSF('sudo', sudoPassword);
    }
    bool dejaList = await DataBase().doesListExist(serviceListName);
    if (!dejaList && await checkServiceInServicesList(serviceName) == true) {
      await DataBase().saveList(serviceListName, [serviceName]);
    } else {
      serviceList = await DataBase().getList(serviceListName);
      if (serviceList.contains(serviceName)) {
        // ignore: use_build_context_synchronously
        warning('service exist', context);
      } else if (serviceName.isNotEmpty &&
          await checkServiceInServicesList(serviceName) == true) {
        await DataBase().appendToList(serviceListName, serviceName);
        serviceNameController.clear();
        Navigator.pushNamed(context, HomePage.id);
      } else {
        warning('service is not created', context);
      }
    }''';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Style.backGroundColor,
      floatingActionButton: IconButton(
          onPressed: () {
            serverIpController.clear();
            sshPortController.clear();
            Navigator.pushNamed(context, HomePage.id);
          },
          icon: const Icon(Icons.cancel)),
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text('Add remote server'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Please enter the remote server Ip address'),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: serverIpController,
                focusNode: focusNodeServerIp,
                textAlign: TextAlign.center,
                autofocus: true,
                onChanged: (value) {
                  serverIp = value;
                },
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            const Text('Please enter the ssh Port number'),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: sshPortController,
                focusNode: focusNodeSshPort,
                textAlign: TextAlign.center,
                autofocus: false,
                onChanged: (value) {
                  sshPort = value;
                },
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            BigButton(
              text: 'Add server',
              fontSize: 15,
              onPressed: createButtonPressed,
              containerAlignment: Alignment.bottomRight,
            ),
            const SizedBox(
              height: 20,
            ),
            const Text('Make sure the server is running')
          ],
        ),
      ),
    );
  }
}
