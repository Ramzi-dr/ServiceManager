// ignore_for_file: unrelated_type_equality_checks

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:service_manager/bigButton.dart';
import 'package:service_manager/database.dart';
import 'package:service_manager/homePage.dart';
import 'package:service_manager/localServerBuilder.dart';
import 'package:service_manager/payloadCollection.dart';
import 'package:service_manager/showDialog.dart';
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

  bool _localServerValue = false;
  void _toggleLocalServerCheckBox() {
    setState(() {
      _localServerValue = !_localServerValue;
    });
  }

//////////////////////////////////////////////////////////utility for the remote server////////////////////////////////////////////////////////
  final Color selectedColor = Colors.red;
  List<Color> selectedColorList = [];
  bool startRemoteServerCheckBoxValue = false;
  List<dynamic> myServerListMap = [];
  List<dynamic> checkBoxList = [];
  List checkedServiceList = [];
  List myServerIpPortSudo = [];
  final Map<String, List> serviceInfoMap = {};

  void convertServiceInfoMap(serviceInfoMap) {
    print(serviceInfoMap);
  }

  void _toggleRemoteServerCheckBox(index) {
    setState(() {
      checkBoxList[index] = (checkBoxList[index] == false) ? true : false;
      selectedColorList[index] = (selectedColorList[index] == selectedColor)
          ? Style.buttonColor
          : selectedColor;
      // _serviceColorList[index] = (_serviceColorList[index] == _serviceColor)
      //     ? Style.notActiveServiceButtonColor
      //     : _serviceColor;
    });
  }

  @override
  void initState() {
    super.initState();
    // Retrieve the list from shared_preferences when the widget is initialized.
    _loadMapFromPrefs();
  }

  void performInitialization() {
    _loadMapFromPrefs();
  }

  Future<void> _loadMapFromPrefs() async {
    if (await DataBase().doesExist(PayloadCollection.serverListName)) {
      List serverList =
          await DataBase().getTheListOfServer(PayloadCollection.serverListName);
      setState(() {
        for (var _ in serverList) {
          final Map<String, dynamic> serverIpAndPort = {_[0]: _[1]};
          final Map<String, dynamic> serverPortSudo = {_[1]: _[2]};
          final Map<String, dynamic> serverIpPortSudo = {_[0]: serverPortSudo};
          myServerIpPortSudo.add(serverIpPortSudo);
          myServerListMap.add(serverIpAndPort);
          checkBoxList.add(startRemoteServerCheckBoxValue);
          selectedColorList.add(selectedColor);
        }
        ;
      });
    }
  }
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  var focusNodeServiceName = FocusNode();
  var focusNodeSudoPassword = FocusNode();
  final serviceNameController = TextEditingController();

  createButtonPressed() async {
    if (checkedServiceList.isEmpty) {
      warning('Please you must choose at least one server!', context);
    } else if (serviceName.isEmpty) {
      warning('Service name is missing!', context);
    } else if (checkedServiceList.isNotEmpty || serviceName.isNotEmpty) {
      serviceInfoMap[serviceName] = checkedServiceList;
      await DataBase().saveServiceInfoMap(
          PayloadCollection.ServiceInfoMapName, serviceInfoMap);

      Navigator.pushNamed(context, HomePage.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Style.backGroundColor,
      floatingActionButton: IconButton(
          highlightColor: const Color.fromRGBO(184, 180, 173, 0.6),
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
              Container(
                color: const Color.fromARGB(255, 120, 173, 180),
                child: Padding(
                    padding: const EdgeInsets.only(left: 40, right: 40),
                    child: CheckboxListTile(
                        title: const Text(
                          'Local server',
                        ),
                        value: _localServerValue,
                        onChanged: (bool? value) {
                          _toggleLocalServerCheckBox();
                          if (value!) {
                            checkedServiceList.add('localServer');
                          } else if (!value) {
                            checkedServiceList.remove('localServer');
                          }
                        })),
              )
            ],
          ),
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 40.0, top: 10.0, right: 40, bottom: 10.0),
              child: ListView.builder(
                itemCount: myServerListMap.length, //_myServerList.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onLongPress: () {
                      showMyDialog(
                          context,
                          myServerListMap[index].toString(),
                          'Are you sure to delete  server from list?',
                          '',
                          'delete server',
                          'serviceList',
                          index);
                    },
                    child: CheckboxListTile(
                      // tileColor: const Color.fromARGB(
                      //     255, 139, 162, 168), // selectedColorList[index],
                      title: Text(myServerListMap[index].toString()),
                      value: checkBoxList[index],
                      onChanged: (bool? value) {
                        _toggleRemoteServerCheckBox(index);
                        if (value!) {
                          checkedServiceList.add(myServerIpPortSudo[index]);
                        } else if (!value) {
                          checkedServiceList.remove(myServerIpPortSudo[index]);
                        }
                      },
                    ),
                  );
                },
              ),
            ),
          ),
          Column(
            children: [
              const Divider(
                thickness: 2.0,
                color: Color.fromARGB(255, 120, 173, 180),
              ),
              const SizedBox(
                height: 30,
              ),
              const Text(
                  'Make sure the service has already been built and tested!'),
              const SizedBox(
                height: 20,
              ),
              BigButton(
                text: 'Create',
                fontSize: 15,
                onPressed: createButtonPressed,
                containerAlignment: Alignment.bottomRight,
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
