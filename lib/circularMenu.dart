import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:service_manager/configServer.dart';
import 'package:service_manager/changePassword.dart';
import 'package:service_manager/createServiceStopStarter.dart';
import 'package:service_manager/loginPage.dart';
import 'package:service_manager/warningMessage.dart';

import '../style.dart';

class CircularmenuWidget extends StatelessWidget {
  const CircularmenuWidget({
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
                Navigator.pushNamed(context, AddRemoteServer.id);
              },
              icon: const Tooltip(
                  message: 'config server', child: Icon(Icons.computer))),
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
