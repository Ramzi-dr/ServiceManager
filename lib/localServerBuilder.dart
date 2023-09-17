import 'package:flutter/material.dart';

class LocalServerCheckbox extends StatefulWidget {
  const LocalServerCheckbox({
    super.key,
  });

  @override
  State<LocalServerCheckbox> createState() => _LocalServerCheckboxState();
}

class _LocalServerCheckboxState extends State<LocalServerCheckbox> {
  bool _value = false;
  void _toggleCheckBox() {
    setState(() {
      _value = !_value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
        title: const Text(
          'Local server',
        ),
        value: _value,
        onChanged: (bool? value) {
          _toggleCheckBox();
        });
  }
}
