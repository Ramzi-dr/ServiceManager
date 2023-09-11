import 'package:flutter/material.dart';
import 'package:service_manager/bigButton.dart';
import 'package:service_manager/databse.dart';
import 'package:service_manager/homePage.dart';
import 'package:service_manager/showDialog.dart';
import 'package:service_manager/style.dart';
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
    bool _dejaList = await DataBase().doesListExist(serviceListName);
    if (!_dejaList) {
      await DataBase().saveList(serviceListName, [serviceName]);
    } else {
      serviceList = await DataBase().getList(serviceListName);
      if (serviceList.contains(serviceName)) {
        warning('service exist', context);
      } else {
        await DataBase().appendToList(serviceListName, serviceName);
        serviceNameController.clear();
      }
    }
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Please enter service name'),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: serviceNameController,
                focusNode: focusNodeServiceName,
                textAlign: TextAlign.center,
                autofocus: false,
                onChanged: (value) {
                  serviceName = value;
                },
              ),
            ),
            const Text('Please enter sudo password'),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: sudoPasswordController,
                focusNode: focusNodeSudoPassword,
                textAlign: TextAlign.center,
                autofocus: false,
                onChanged: (value) {
                  serviceName = value;
                },
              ),
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
            const Text(
                'Make sure the service has already been built and tested!')
          ],
        ),
      ),
    );
  }
}
