import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:service_manager/changePassword.dart';
import 'package:service_manager/createServiceStopStarter.dart';
import 'package:service_manager/loginPage.dart';

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
        ringColor: Color.fromRGBO(184, 180, 173, 0.6),
        ringDiameter: 275,
        ringWidth: 70,
        animationDuration: const Duration(milliseconds: 800),
        animationCurve: Curves.easeInOutCirc,
        fabElevation: 5,
        fabColor: Style.backGroundColor,
        fabSize: 64.0,
        fabCloseColor: Style.buttonColor,
        fabOpenColor: Color.fromRGBO(184, 180, 173, 0.6),
        fabIconBorder: CircleBorder(
            side: BorderSide(color: Style.backGroundColor, width: 2)),
        children: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, ChangePassword.id);
            },
            icon: Icon(Icons.person),
          ),
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, CreateServiceStopStarter.id);
              },
              icon: Icon(Icons.settings)),
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, LoginPage.id);
              },
              icon: Icon(Icons.logout)),
        ]);
  }
}
