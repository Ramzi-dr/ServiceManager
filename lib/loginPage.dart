// import 'package:flutter/material.dart';
// import 'package:service_manager/bigButton.dart';
// import 'package:service_manager/database.dart';
// import 'package:service_manager/homePage.dart';
// import 'package:service_manager/style.dart';
// import 'package:service_manager/warningMessage.dart';

// class LoginPage extends StatefulWidget {
//   static const id = '/';

//   LoginPage({
//     super.key,
//   });

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   String username = '';
//   String password = '';
//   var focusNodeUsernameField = FocusNode();
//   var focusNodePasswordField = FocusNode();
//   final usernameController = TextEditingController();
//   final passwordController = TextEditingController();
//   loginButtonPressed() async {
//     if (username.isEmpty || password.isEmpty) {
//       warning('bitte überprüfen Sie Ihre Eingaben', context);
//       passwordController.clear();
//       password = '';
//     } else {
//       DataBase().addKeyToSF('username', username);

//       Future.delayed(const Duration(seconds: 1), () {
//         DataBase().addKeyToSF('password', password);
//       });
//       var dataUsername = await DataBase().getValue('username');
//       var dataPassword = await DataBase().getValue('password');
//       if (username == dataUsername && password == dataPassword) {
//         usernameController.clear();
//         passwordController.clear();
//         username = '';
//         password = '';
//         Navigator.pushNamed(context, HomePage.id);
//       } else {
//         warning('Bitte gültiges Nutzername und Passwort eingeben!', context);
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: Style.backGroundColor,
//         appBar: AppBar(
//           centerTitle: true,
//           automaticallyImplyLeading: false,
//           backgroundColor: Style.backGroundColorAppBar,
//           title: const Center(child: Text('please Login ')),
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Center(
//             child:
//                 Column(mainAxisAlignment: MainAxisAlignment.center, children: [
//               const Text('Username'),
//               Padding(
//                 padding: const EdgeInsets.only(left: 10, right: 30, bottom: 10),
//                 child: Card(
//                   child: TextField(
//                     controller: usernameController,
//                     focusNode: focusNodeUsernameField,
//                     textAlign: TextAlign.center,
//                     autofocus: true,
//                     onChanged: (value) {
//                       username = value;
//                     },
//                   ),
//                 ),
//               ),
//               const Text('Password'),
//               Padding(
//                 padding: const EdgeInsets.only(left: 30, right: 10, bottom: 10),
//                 child: Card(
//                     child: TextField(
//                   controller: passwordController,
//                   focusNode: focusNodePasswordField,
//                   autofocus: false,
//                   textAlign: TextAlign.center,
//                   obscureText: true,
//                   onChanged: (value) {
//                     password = value;
//                   },
//                 )),
//               ),
//               BigButton(
//                 text: 'Log in',
//                 fontSize: 15,
//                 onPressed: loginButtonPressed,
//                 containerAlignment: Alignment.bottomRight,
//               )
//             ]),
//           ),
//         ),
//       ),
//     );
//   }
// }
