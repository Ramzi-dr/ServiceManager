import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:service_manager/circularMenu.dart';
import 'package:service_manager/serviceCreator.dart';
import 'package:service_manager/style.dart';

class HomePage extends StatefulWidget {
  static const id = 'HomePage';
  final GlobalKey<FabCircularMenuState>? fabKey = GlobalKey();
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: CircularmenuWidget(fabKey: widget.fabKey!),
      resizeToAvoidBottomInset: true,
      backgroundColor: Style.backGroundColor,
      appBar: AppBar(
        bottomOpacity: 0.9,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'Services Manager',
        ),
      ),
      body: GestureDetector(
        onTap: () {
          widget.fabKey!.currentState?.close();
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 2.0, right: 8.0, top: 3.0),
              child: ListTile(
                leading: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Style.lightButtonBackgroundColor),
                  child: const Text('Befehl'),
                  onPressed: () {
                    ;
                  },
                ),
                title: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Style.lightButtonBackgroundColor),
                  child: const Text('Dienst'),
                  onPressed: () {
                    ;
                  },
                ),
                trailing: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Style.lightButtonBackgroundColor),
                  child: const Text('Status'),
                  onPressed: () {
                    ;
                  },
                ),
              ),
            ),
            Expanded(child: ServiceCreator(serviceName: 'serviceName')),
            Container(
              height: 80,
            )
          ],
        ),
      ),
    );
  }
}
