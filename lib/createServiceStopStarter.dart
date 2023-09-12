// ignore_for_file: unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:service_manager/bigButton.dart';
import 'package:service_manager/database.dart';
import 'package:service_manager/homePage.dart';
import 'package:service_manager/style.dart';
import 'package:service_manager/terminalCommand.dart';
import 'package:service_manager/warningMessage.dart';

class CreateServiceStopStarter extends StatefulWidget {
  static const id = 'CreateServiceStopStarter';
  const CreateServiceStopStarter({super.key});

  @override
  State<CreateServiceStopStarter> createState() =>
      _CreateServiceStopStarterState();
}

class _CreateServiceStopStarterState extends State<CreateServiceStopStarter> {
  String serviceName = '';
  String sudoPassword = '';
  String serviceListName = 'serviceList';
  List serviceList = [];
  var focusNodeServiceName = FocusNode();
  var focusNodeSudoPassword = FocusNode();
  final sudoPasswordController = TextEditingController();

  final serviceNameController = TextEditingController();
  createButtonPressed() async {
    if (sudoPassword.isNotEmpty) {
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
    }
  }

  bool _obscured = false;

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
            serviceNameController.clear();
            Navigator.pushNamed(context, HomePage.id);
          },
          icon: const Icon(Icons.cancel)),
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text('Create stop-start service'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30,
              ),
              const Text('Please enter service name'),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: serviceNameController,
                  focusNode: focusNodeServiceName,
                  textAlign: TextAlign.center,
                  autofocus: true,
                  onChanged: (value) {
                    serviceName = value;
                  },
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const Text('Please enter sudo password'),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: sudoPasswordController,
                  focusNode: focusNodeSudoPassword,
                  textAlign: TextAlign.center,
                  autofocus: false,
                  obscureText: _obscured,
                  onChanged: (value) {
                    sudoPassword = value;
                  },
                ),
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
          Column(
            children: [
              BigButton(
                text: 'Create',
                fontSize: 15,
                onPressed: createButtonPressed,
                containerAlignment: Alignment.bottomRight,
              ),
              const SizedBox(
                height: 30,
              ),
              const Text(
                  'Make sure the service has already been built and tested!'),
              const SizedBox(
                height: 70,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
