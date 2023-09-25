import 'package:flutter/material.dart';
import 'package:service_manager/payloadCollection.dart';
import 'package:service_manager/showDialog.dart';
import 'package:service_manager/terminalCommand.dart';
import 'package:service_manager/warningMessage.dart';

class ServiceListTitle extends StatefulWidget {
  const ServiceListTitle({Key? key});

  @override
  State<ServiceListTitle> createState() => _ServiceListTitleState();
}

class _ServiceListTitleState extends State<ServiceListTitle>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  String stop = '   _Stop_    ';
  String start = '   _Start_   ';
  String notFound = 'NotFound';
  List fullServersData = [];
  List<AnimationController> _iconControllers = [];

  void _toggleServiceTile(serverIp, serverIndex, _services, index) async {
    var inactive = 'inactive';
    var serviceCurrentState =
        fullServersData[serverIndex]['serviceList'][index]['serviceState'];

    var service = _services[index]['serviceName'];
    if (serviceCurrentState == notFound) {
      warning(
          'Service with name: $service is not found in $serverIp control it first ',
          context);
    } else {
      String command = serviceCurrentState == inactive ? 'start' : 'stop';

      var action = await CheckServicesState()
          .statusStartStopService(serverIp, service, command);

      setState(() {
        if (action == 'active') {
          fullServersData[serverIndex]['serviceList'][index]['serviceState'] =
              'active';
          fullServersData[serverIndex]['serviceList'][index]
              ['serviceButtonText'] = stop;
          fullServersData[serverIndex]['serviceList'][index]
                  ['serviceButtonColor'] =
              PayloadCollection.runningServiceStateColor;
          fullServersData[serverIndex]['serviceList'][index]
              ['serviceIconColor'] = PayloadCollection.onlineServiceStateColor;
        } else if (action == 'inactive') {
          fullServersData[serverIndex]['serviceList'][index]['serviceState'] =
              'inactive';
          fullServersData[serverIndex]['serviceList'][index]
              ['serviceButtonText'] = start;
          fullServersData[serverIndex]['serviceList'][index]
                  ['serviceButtonColor'] =
              PayloadCollection.onlineServiceStateColor;
          fullServersData[serverIndex]['serviceList'][index]
              ['serviceIconColor'] = PayloadCollection.runningServiceStateColor;
        }
      });
      // Start the rotation animation for the pressed button's icon
      if (action == 'active' || action == 'inactive') {
        _iconControllers[index].forward(from: 0.0);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getServerListWithService();
  }

  void getServerListWithService() async {
    CheckServicesState checker = CheckServicesState();

    var serversData = await checker.serversChecker(context);
    _iconControllers.clear(); // Clear the list before populating it
    fullServersData.clear(); // Clear the existing data
    for (var server in serversData) {
      if (server['serviceList'].isNotEmpty) {
        fullServersData.add(server);
        for (var service in server['serviceList']) {
          if (service['serviceState'] == 'active') {
            service['serviceButtonColor'] =
                PayloadCollection.runningServiceStateColor;
            service['serviceIconColor'] =
                PayloadCollection.onlineServiceStateColor;
          } else if (service['serviceState'] == 'inactive') {
            service['serviceButtonColor'] =
                PayloadCollection.onlineServiceStateColor;
            service['serviceIconColor'] =
                PayloadCollection.runningServiceStateColor;
          } else if (service['serviceState'] == 'notFound') {
            service['serviceButtonColor'] =
                PayloadCollection.offlineServiceStateColor;
            service['serviceIconColor'] =
                PayloadCollection.offlineServiceStateColor;
          } else if (service['serviceState'] == 'offline') {
            service['serviceButtonColor'] =
                PayloadCollection.notFoundServiceStateColor;
            service['serviceIconColor'] =
                PayloadCollection.notFoundServiceStateColor;
          }
          if (!fullServersData.contains(server)) {
            fullServersData.add(server);
          }
        }
      }
    }

    // Initialize the controllers for each icon
    for (int i = 0; i < fullServersData.length; i++) {
      for (int j = 0; j < fullServersData[i]['serviceList'].length; j++) {
        _iconControllers.add(AnimationController(
          vsync: this,
          duration: const Duration(seconds: 2), // Adjust the duration as needed
        ));
      }
    }

    setState(() {});
  }

  @override
  void dispose() {
    for (var controller in _iconControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      trackVisibility: true,
      thumbVisibility: true,
      thickness: 10,
      controller: _scrollController,
      child: ListView.builder(
          controller: _scrollController,
          itemCount: fullServersData.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                ListTile(
                  title: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              fullServersData[index]['serverState'] == 'offline'
                                  ? PayloadCollection.offlineServiceStateColor
                                  : PayloadCollection.onlineServiceStateColor),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Text(fullServersData[index]['serverIp']),
                      ),
                      onLongPress: () async {
                        await showMyDialog(context,
                            'This will delete the Server: ', 'delete server', [
                          fullServersData[index]['serverIp'],
                          fullServersData[index]['serverIp']
                        ]);
                      },
                      onPressed: () {}),
                ),
                Container(
                    color: const Color.fromARGB(175, 88, 130, 150),
                    height: fullServersData[index]['serviceList'].length == 2
                        ? 100
                        : fullServersData[index]['serviceList'].length >= 2 &&
                                fullServersData[index]['serviceList'].length <=
                                    4
                            ? 120
                            : fullServersData[index]['serviceList'].length == 1
                                ? 50
                                : 260,
                    child: serviceListView(
                        index, fullServersData[index]['serverIp'])),
              ],
            );
          }),
    );
  }

  ListView serviceListView(serverIndex, serverIp) {
    List _services = fullServersData[serverIndex]['serviceList'];
    return ListView.builder(
      itemCount: _services.length,
      itemBuilder: (context, index) {
        return Stack(children: [
          ListTile(
              title: GestureDetector(
                onLongPress: () async {
                  await showMyDialog(
                      context,
                      'This will delete:  ',
                      'deleteServiceFromServer',
                      [serverIp, _services[index]['serviceName']]);
                },
                child: Text(
                  _services[index]['serviceName'],
                  textAlign: TextAlign.center,
                ),
              ),
              leading: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: _services[index]['serviceButtonColor']),
                child: Text(_services[index]['serviceButtonText']),
                onPressed: () async {
                  _toggleServiceTile(serverIp, serverIndex, _services, index);
                },
              ),
              trailing: Padding(
                padding: const EdgeInsets.only(right: 40.0),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(175, 88, 130, 150)),
                    onPressed: () {
                      if (!_iconControllers[index].isAnimating) {
                        _iconControllers[index].forward(from: 0.0);
                        checkServiceState(serverIndex, serverIp,
                            _services[index]['serviceName'], index);
                      }
                    },
                    child: RotationTransition(
                      turns: _iconControllers[index],
                      child: Icon(Icons.refresh_outlined,
                          color: _services[index]['serviceIconColor']),
                    )),
              )),
          if (_services[index]['serviceState'] == 'offline')
            Container(
              color: Colors.grey.withOpacity(0.5),
              height: 50,
            )
        ]);
      },
    );
  }

  checkServiceState(serverIndex, serverIp, service, index) async {
    var action = await CheckServicesState().serviceState(serverIp, service);
    setState(() {
      if (action == 'active') {
        fullServersData[serverIndex]['serviceList'][index]['serviceState'] =
            'active';
        fullServersData[serverIndex]['serviceList'][index]
            ['serviceButtonText'] = stop;
        fullServersData[serverIndex]['serviceList'][index]
            ['serviceButtonColor'] = PayloadCollection.runningServiceStateColor;
        fullServersData[serverIndex]['serviceList'][index]['serviceIconColor'] =
            PayloadCollection.onlineServiceStateColor;
      } else if (action == 'inactive') {
        fullServersData[serverIndex]['serviceList'][index]['serviceState'] =
            'inactive';
        fullServersData[serverIndex]['serviceList'][index]
            ['serviceButtonText'] = start;
        fullServersData[serverIndex]['serviceList'][index]
            ['serviceButtonColor'] = PayloadCollection.onlineServiceStateColor;
        fullServersData[serverIndex]['serviceList'][index]['serviceIconColor'] =
            PayloadCollection.runningServiceStateColor;
      } else if (action == 'notFound') {
        fullServersData[serverIndex]['serviceList'][index]['serviceState'] =
            'notFound';
        fullServersData[serverIndex]['serviceList'][index]
            ['serviceButtonText'] = notFound;
        fullServersData[serverIndex]['serviceList'][index]
            ['serviceButtonColor'] = PayloadCollection.offlineServiceStateColor;
        fullServersData[serverIndex]['serviceList'][index]['serviceIconColor'] =
            PayloadCollection.offlineServiceStateColor;
      }
    });
  }
}
