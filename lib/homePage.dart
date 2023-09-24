import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:service_manager/circularMenu.dart';
import 'package:service_manager/style.dart';
import 'package:service_manager/ServiceListTitle.dart';

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
      floatingActionButton: CircularMenuWidget(fabKey: widget.fabKey!),
      resizeToAvoidBottomInset: true,
      backgroundColor: Style.backGroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon:const Icon(Icons.refresh),
          onPressed: () {
            Navigator.pushReplacementNamed(context, HomePage.id);
          },
        ),
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
                  child: const Text('   Befehl   '),
                  onPressed: () async {
                
                  },
                ),
                title: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Style.lightButtonBackgroundColor),
                  child: const Padding(
                    padding: EdgeInsets.only(left: 15.0),
                    child: Text('Dienst'),
                  ),
                  onPressed: () {
                    
                  },
                ),
                trailing: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Style.lightButtonBackgroundColor),
                  child: const Text('  Status  '),
                  onPressed: () {
                    
                  },
                ),
              ),
            ),
            const Expanded(child: ServiceListTitle()),
            Container(
              height: 80,
            )
          ],
        ),
      ),
    );
  }
}
