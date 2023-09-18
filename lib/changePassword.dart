// import 'package:flutter/material.dart';
// import 'package:service_manager/bigButton.dart';
// import 'package:service_manager/database.dart';
// import 'package:service_manager/homePage.dart';
// import 'package:service_manager/loginPage.dart';
// import 'package:service_manager/style.dart';
// import 'package:service_manager/warningMessage.dart';

// class ChangePassword extends StatefulWidget {
//   static const id = 'ChangePasswordPage';
//   const ChangePassword({super.key});

//   @override
//   State<ChangePassword> createState() => _ChangePasswordState();
// }

// class _ChangePasswordState extends State<ChangePassword> {
//   String oldPassword = '';
//   String newPassword = '';
//   String confirmedPassword = '';
//   var focusNodeOldPasswordField = FocusNode();
//   var focusNodeNewPasswordField = FocusNode();
//   var focusNodeConfirmedPasswordField = FocusNode();
//   final oldPasswordController = TextEditingController();
//   final newPasswordController = TextEditingController();
//   final confirmedPasswordController = TextEditingController();
//   loginButtonPressed() async {
//     if (oldPassword.isEmpty ||
//         newPassword.isEmpty ||
//         confirmedPassword.isEmpty) {
//       warning('bitte überprüfen Sie Ihre Eingaben', context);
//       oldPasswordController.clear();
//       newPasswordController.clear();
//       confirmedPasswordController.clear();
//     } else {
//       var dataOldPass = await DataBase().getValue('password');
//       if (oldPassword == dataOldPass) {
//         if (newPassword == confirmedPassword) {
//           DataBase().addKeyToSF('password', newPassword);
//           oldPasswordController.clear();
//           newPasswordController.clear();
//           confirmedPasswordController.clear();
//           Navigator.pushNamed(context, LoginPage.id);
//         } else {
//           warning('bitte überprüfen Sie Ihre Eingaben', context);
//           newPasswordController.clear();
//           confirmedPasswordController.clear();
//         }
//       } else {
//         warning('bitte überprüfen Sie das bestehende Passwort ', context);
//         oldPasswordController.clear();
//       }
//     }
//   }

//   bool _obscured = false;

//   void _toggleObscured() {
//     setState(() {
//       _obscured = !_obscured;
//       if (focusNodeOldPasswordField.hasPrimaryFocus)
//         return; // If focus is on text field, dont unfocus
//       focusNodeOldPasswordField.canRequestFocus =
//           false; // Prevents focus if tap on eye
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       floatingActionButton: IconButton(
//           onPressed: () {
//             oldPasswordController.clear();
//             newPasswordController.clear();
//             confirmedPasswordController.clear();
//             Navigator.pushNamed(context, HomePage.id);
//           },
//           icon: const Icon(Icons.cancel)),
//       appBar: AppBar(
//         title: const Text('Change Password'),
//         centerTitle: true,
//         automaticallyImplyLeading: false,
//       ),
//       backgroundColor: Style.backGroundColor,
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Center(
//           child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
//             const Text('Old password'),
//             Padding(
//               padding: const EdgeInsets.only(left: 30, right: 30, bottom: 10),
//               child: Card(
//                 child: TextField(
//                   decoration: InputDecoration(
//                       floatingLabelBehavior: FloatingLabelBehavior.never,
//                       //prefixIcon: Icon(Icons.lock_rounded, size: 24),
//                       suffixIcon: Padding(
//                           padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
//                           child: GestureDetector(
//                               onTap: _toggleObscured,
//                               child: Icon(
//                                   _obscured
//                                       ? Icons.visibility_rounded
//                                       : Icons.visibility_off_rounded,
//                                   size: 24)))),
//                   controller: oldPasswordController,
//                   focusNode: focusNodeOldPasswordField,
//                   textAlign: TextAlign.center,
//                   obscureText: _obscured,
//                   autofocus: true,
//                   onChanged: (value) {
//                     oldPassword = value;
//                   },
//                 ),
//               ),
//             ),
//             const Text('New password'),
//             Padding(
//               padding: const EdgeInsets.only(left: 30, right: 30, bottom: 10),
//               child: Card(
//                   child: TextField(
//                 controller: newPasswordController,
//                 focusNode: focusNodeNewPasswordField,
//                 autofocus: false,
//                 textAlign: TextAlign.center,
//                 obscureText: true,
//                 onChanged: (value) {
//                   newPassword = value;
//                 },
//               )),
//             ),
//             const Text('Confirm  new password'),
//             Padding(
//               padding: const EdgeInsets.only(left: 30, right: 30, bottom: 10),
//               child: Card(
//                   child: TextField(
//                 controller: confirmedPasswordController,
//                 focusNode: focusNodeConfirmedPasswordField,
//                 autofocus: false,
//                 textAlign: TextAlign.center,
//                 obscureText: true,
//                 onChanged: (value) {
//                   confirmedPassword = value;
//                 },
//               )),
//             ),
//             Center(
//                 child: BigButton(
//               text: 'Change password',
//               fontSize: 12,
//               onPressed: loginButtonPressed,
//               containerAlignment: Alignment.bottomCenter,
//             ))
//           ]),
//         ),
//       ),
//     );
//   }
// }
