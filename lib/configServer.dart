// ignore_for_file: unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:service_manager/bigButton.dart';
import 'package:service_manager/database.dart';
import 'package:service_manager/homePage.dart';
import 'package:service_manager/style.dart';
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
  String password = '';
  String userName = '';
  String serverMapName = 'serverMap';
  Map serverMap = {};
  var focusNodeServerIp = FocusNode();
  var focusNodeSshPort = FocusNode();
  var focusNodePassword = FocusNode();
  var focusNodeUserName = FocusNode();
  final serverIpController = TextEditingController();
  final sshPortController = TextEditingController();
  final passwordController = TextEditingController();
  final userNameController = TextEditingController();

  void clearEntry() {
    serverIp = '';
    sshPort = '';
    userName = '';
    password = '';
    passwordController.clear();
    serverIpController.clear();
    sshPortController.clear();
    userNameController.clear();
  }

  createButtonPressed() async {
    if (userName.isEmpty) {
      warning('Please enter user name', context);
      clearEntry();
    } else if (password.isEmpty) {
      warning('Please enter password', context);
      clearEntry();
    } else if ((serverIp.isNotEmpty && sshPort.isEmpty) ||
        (serverIp.isEmpty && sshPort.isNotEmpty)) {
      // ignore: use_build_context_synchronously
      warning('Please check the server ip and ssh port!', context);
      clearEntry();
    } else if (serverIp.isNotEmpty &&
        sshPort.isNotEmpty &&
        password.isNotEmpty &&
        userName.isNotEmpty) {
      DataBase().updateServerList(serverIp, sshPort, userName, password);
      clearEntry();
    } else if (password.isNotEmpty &&
        userName.isNotEmpty &&
        serverIp.isEmpty &&
        sshPort.isEmpty) {
      warning('Please check the server user name, ip and ssh port!', context);
      clearEntry();
    } else if (password.isNotEmpty &&
        userName.isNotEmpty &&
        serverIp.isEmpty &&
        sshPort.isEmpty) {
      warning('Please check the server ip and ssh port!', context);
      clearEntry();
    }
  }

  bool _obscured = true;

  void _toggleObscured() {
    setState(() {
      _obscured = !_obscured;
      if (focusNodePassword.hasPrimaryFocus) {
        return;
      }
      focusNodePassword.canRequestFocus = false; // Prevents focus if tap on eye
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
        title: const Text('Server configuration'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 30,
              ),
              const Text('Please enter user name'),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: userNameController,
                  focusNode: focusNodeUserName,
                  textAlign: TextAlign.center,
                  autofocus: true,
                  onChanged: (value) {
                    userName = value;
                  },
                ),
              ),
              const Text('Please enter password'),
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
                  controller: passwordController,
                  focusNode: focusNodePassword,
                  textAlign: TextAlign.center,
                  obscureText: _obscured,
                  onChanged: (value) {
                    password = value;
                  },
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const Text('Enter the server Ip address'),
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
              const Text('Enter the ssh Port number'),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  keyboardType: TextInputType.number,
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
              const Center(
                child: Text(
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  'BE SURE SSH SERVER IS RUNNING ON MACHINE INC PORT FORWARDING!',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 78, 47, 40)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
