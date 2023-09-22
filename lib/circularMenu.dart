import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:service_manager/configServer.dart';
import 'package:service_manager/createServiceStopStarter.dart';
import 'package:service_manager/database.dart';
import 'package:service_manager/homePage.dart';
import 'package:service_manager/warningMessage.dart';

import '../style.dart';

final inputController = TextEditingController();
var inputFocusNode = FocusNode();
String confirmDeleteText = 'DELETEdata';
String userInputText = '';

void checkAndDeleteData(context) {
  if (confirmDeleteText == userInputText) {
    inputController.clear();
    DataBase().clearDatabase();

    Navigator.pushNamed(context, HomePage.id);
  } else {
    inputController.clear();
    warning('control ur input please ', context);
  }
}

class CircularMenuWidget extends StatelessWidget {
  const CircularMenuWidget({
    Key? key,
    required this.fabKey,
  }) : super(key: key);

  final GlobalKey<FabCircularMenuState> fabKey;

  @override
  Widget build(BuildContext context) {
    return FabCircularMenu(
        key: fabKey,
        ringColor: const Color.fromRGBO(184, 180, 173, 0.6),
        ringDiameter: 165,
        ringWidth: 35,
        animationDuration: const Duration(milliseconds: 800),
        animationCurve: Curves.easeInOutCirc,
        fabElevation: 5,
        fabColor: Style.backGroundColor,
        fabSize: 54.0,
        fabCloseColor: Style.buttonColor,
        fabOpenColor: const Color.fromRGBO(184, 180, 173, 0.6),
        fabIconBorder: CircleBorder(
            side: BorderSide(color: Style.backGroundColor, width: 2)),
        children: <Widget>[
          //IconButton(
          // onPressed: () {
          //   warning(
          //      'This option is deactivated,\n     For more info => Ramzi!',
          //      context);
          //Navigator.pushNamed(context, ChangePassword.id);
          //  },
          //  icon: Tooltip(message: 'Not Used', child: const Icon(Icons.person)),
          // ),
          IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text(
                        style: TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold),
                        "!!this will remove the entire database application!!"),
                    content: const SizedBox(
                      height: 30,
                      child: Center(child: Text('Type DELETEdata to confirm')),
                    ),
                    actions: <Widget>[
                      SizedBox(
                        height: 80,
                        child: Center(
                          child: Column(
                            children: [
                              SizedBox(
                                width: 300,
                                child: Container(
                                  color: const Color.fromARGB(80, 182, 72, 72),
                                  child: TextField(
                                    enableSuggestions: false,
                                    controller: inputController,
                                    focusNode: inputFocusNode,
                                    onChanged: (value) {
                                      userInputText = value;
                                    },
                                  ),
                                ),
                              ),
                              Text(
                                  'Please enter the text exactly as displayed to confirm',
                                  style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                            onPressed: () {
                              checkAndDeleteData(context);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(14),
                              child: const Text("delete"),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(ctx).pop();
                            },
                            child: Container(
                              padding: const EdgeInsets.all(14),
                              child: const Text("cancel"),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
              icon: const Tooltip(
                  message: 'delete Data', child: Icon(Icons.delete_forever))),
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, AddRemoteServer.id);
              },
              icon: const Tooltip(
                  message: 'config remote server',
                  child: Icon(Icons.computer))),

          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, CreateServiceStopStarter.id);
              },
              icon: const Tooltip(
                  message: 'Add services', child: Icon(Icons.settings))),

          // IconButton(
          //   onPressed: () {
          //    warning(
          //      'This option is deactivated,\n     For more info => Ramzi!',
          //    context);
          // Navigator.pushNamed(context, LoginPage.id);
          // },
          //  icon: const Icon(Icons.logout)),
        ]);
  }
}
