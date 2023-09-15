// ignore_for_file: unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:service_manager/bigButton.dart';
import 'package:service_manager/database.dart';
import 'package:service_manager/homePage.dart';
import 'package:service_manager/payloadCollection.dart';
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
  String sudoPassword = '';
  String serverMapName = 'serverMap';
  Map serverMap = {};
  var focusNodeServerIp = FocusNode();
  var focusNodeSshPort = FocusNode();
  var focusNodeSudoPassword = FocusNode();
  final serverIpController = TextEditingController();
  final sshPortController = TextEditingController();
  final sudoPasswordController = TextEditingController();

  void clearEntry() {
    serverIp = '';
    sshPort = '';
    sudoPassword = '';
    sudoPasswordController.clear();
    serverIpController.clear();
    sshPortController.clear();
  }

  createButtonPressed() async {
    await DataBase().removeKey(serverIp);
    if (sudoPassword.isEmpty) {
      warning('Please enter sudo password', context);
      clearEntry();
    } else if ((serverIp.isNotEmpty && sshPort.isEmpty) ||
        (serverIp.isEmpty && sshPort.isNotEmpty)) {
      // ignore: use_build_context_synchronously
      warning('Please check the server ip and ssh port!', context);
      clearEntry();
    } else if (serverIp.isNotEmpty && sshPort.isNotEmpty) {
      print('remote');
      final serverListExist =
          await DataBase().doesExist(PayloadCollection.serverListName);
      List<String> serverInfoList = [serverIp, sshPort, sudoPassword];

      if (!serverListExist) {
        await DataBase().saveList(PayloadCollection.serverListName, []);
        await DataBase().appendServerInfoToServerList(
            PayloadCollection.serverListName, serverInfoList);
        clearEntry();
      } else if (serverListExist) {
        await DataBase().appendServerInfoToServerList(
            PayloadCollection.serverListName, serverInfoList);
        clearEntry();
      }
      final serverList =
          await DataBase().getTheListOfServer(PayloadCollection.serverListName);
      
      clearEntry();
    } else if (sudoPassword.isNotEmpty || serverIp.isEmpty || sshPort.isEmpty) {
      print('local server');
      await DataBase().addKeyToSF(PayloadCollection.localSudo, sudoPassword);
      clearEntry();
    }
  }

  bool _obscured = true;

  void _toggleObscured() {
    setState(() {
      _obscured = !_obscured;
      if (focusNodeSudoPassword.hasPrimaryFocus)
        return; // If focus is on text field, dont unfocus
      focusNodeSudoPassword.canRequestFocus =
          false; // Prevents focus if tap on eye
    });
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
        title: const Text('server configuration'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 30,
              ),
              const Text('Please enter sudo password'),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      //prefixIcon: Icon(Icons.lock_rounded, size: 24),
                      suffixIcon: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                          child: GestureDetector(
                              onTap: _toggleObscured,
                              child: Icon(
                                  !_obscured
                                      ? Icons.visibility_rounded
                                      : Icons.visibility_off_rounded,
                                  size: 24)))),
                  controller: sudoPasswordController,
                  focusNode: focusNodeSudoPassword,
                  textAlign: TextAlign.center,
                  autofocus: true,
                  obscureText: _obscured,
                  onChanged: (value) {
                    sudoPassword = value;
                  },
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const Text(
                  'Enter the server Ip address ( ONLY FOR REMOTE SERVER  )'),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: serverIpController,
                  focusNode: focusNodeServerIp,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    serverIp = value;
                  },
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const Text(
                  'Enter the ssh Port number ( ONLY FOR REMOTE SERVER )'),
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
                height: 60,
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
              const Text(
                'Please make sure the server is running!',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 78, 47, 40)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
