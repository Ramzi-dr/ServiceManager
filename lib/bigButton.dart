import 'package:flutter/material.dart';
import 'package:service_manager/style.dart';

class BigButton extends StatelessWidget {
  const BigButton({
    super.key,
    required this.text,
    required this.fontSize,
    required this.onPressed,
    required this.containerAlignment
  });
  final String text;
  final double fontSize;
  // ignore: prefer_typing_uninitialized_variables
  final  containerAlignment;
  // ignore: prefer_typing_uninitialized_variables
  final onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      alignment: containerAlignment,
      child: SizedBox(width: 100,
        child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusDirectional.circular(10)),
              elevation: 4,
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 3),
              backgroundColor: Style.backGroundColorAppBar,
            ),
            onPressed: onPressed,
            child: FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(text,
                  maxLines: 1,
                  style: TextStyle(
                      fontSize: fontSize, color: Style.textColorWhite)),
            )),
      ),
    );
  }
}
