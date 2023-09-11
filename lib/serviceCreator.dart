import 'package:flutter/material.dart';
import 'package:service_manager/ServiceListTitle.dart';
import 'package:service_manager/style.dart';

class ServiceCreator extends StatefulWidget {
  final String serviceName;

  ServiceCreator({super.key, required this.serviceName});

  @override
  State<ServiceCreator> createState() => _ServiceCreatorState();
}

class _ServiceCreatorState extends State<ServiceCreator> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 2.0, right: 8.0, top: 3.0),
      child: ServiceListTitle(widget: widget),
    );
  }
}
