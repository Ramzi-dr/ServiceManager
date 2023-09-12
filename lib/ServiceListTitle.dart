import 'package:flutter/material.dart';
import 'package:service_manager/database.dart';
import 'package:service_manager/serviceCreator.dart';
import 'package:service_manager/showDialog.dart';
import 'package:service_manager/style.dart';
import 'package:service_manager/terminalCommand.dart';

class ServiceListTitle extends StatefulWidget {
  const ServiceListTitle({
    super.key,
    required this.widget,
  });

  final ServiceCreator widget;

  @override
  State<ServiceListTitle> createState() => _ServiceListTitleState();
}

class _ServiceListTitleState extends State<ServiceListTitle> {
  final String _leadingText = '_Stop_';
  final Color _serviceColor = Style.activeServiceButtonColor;
  List<String> _myList = [];
  final List<String> _leadingTextList = [];
  final List<Color> _serviceColorList = [];
  void _toggleLeadingText(index) {
    setState(() {
      _leadingTextList[index] =
          (_leadingTextList[index] == '_Stop_') ? '_Start_' : '_Stop_';
      _serviceColorList[index] = (_serviceColorList[index] == _serviceColor)
          ? Style.notActiveServiceButtonColor
          : _serviceColor;
    });
  }

  @override
  void initState() {
    super.initState();
    // Retrieve the list from shared_preferences when the widget is initialized.
    _loadListFromPrefs();
  }

  Future<void> _loadListFromPrefs() async {
    if (await DataBase().doesListExist('serviceList')) {
      final myList = await DataBase().getList('serviceList');
      setState(() {
        _myList = myList;
        for (var _ in _myList) {
          _leadingTextList.add(_leadingText);
          _serviceColorList.add(_serviceColor);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _myList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: GestureDetector(
            onLongPress: () {
              showMyDialog(
                  context,
                  _myList[index],
                  'Are you sure to delete  service?',
                  '',
                  'delete service',
                  'serviceList');
            },
            child: Text(
              _myList[index],
              textAlign: TextAlign.center,
            ),
          ),
          leading: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: _serviceColorList[index]),
            child: Text(_leadingTextList[index]),
            onPressed: () {
              _toggleLeadingText(index);
            },
          ),
          trailing: Icon(Icons.radio_button_on_outlined, color: Colors.green),
        );
      },
    );
  }
}
