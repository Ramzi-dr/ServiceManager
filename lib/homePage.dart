import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:service_manager/circularMenu.dart';
import 'package:service_manager/database.dart';
import 'package:service_manager/payloadCollection.dart';
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
  Map serverWithServices = {};
  List serversDetails = [];

  @override
  void initState() {
    super.initState();
    getServiceMap();
  }

  void getServiceMap() async {
    Map originalMap = await DataBase()
        .getServiceInfoMap(PayloadCollection.ServiceInfoMapName);
    Map<String, List<String>> result = {};

    originalMap.forEach((service, servers) {
      if (servers is List) {
        for (var server in servers) {
          if (server is String) {
            // Add the local server to the result
            result.putIfAbsent(server, () => []).add(service);
          } else if (server is Map) {
            server.forEach((serverIp, _) {
              result.putIfAbsent(serverIp, () => []).add(service);
            });
          }
        }
      }
    });
    List serverDetailsList = [];

    originalMap.forEach((service, servers) {
      if (servers is List) {
        for (var server in servers) {
          if (server is Map && !server.containsKey('localServer')) {
            serverDetailsList.add(server);
          }
        }
      }
    });
    setState(() {
      serverWithServices = result;
      serversDetails = serverDetailsList;
    });
    print('mapy $originalMap');
    print(result);
    print(serverDetailsList);
  }

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
                    getServiceMap();
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
