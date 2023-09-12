import 'dart:io';

import 'package:flutter/material.dart';
import 'package:service_manager/addRemoteServer.dart';
import 'package:service_manager/changePassword.dart';
import 'package:service_manager/createServiceStopStarter.dart';
import 'package:service_manager/homePage.dart';
import 'package:service_manager/loginPage.dart';
import 'package:window_manager/window_manager.dart';

Future<void> main() async {
  // ignore: invalid_use_of_visible_for_testing_
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    WindowManager.instance.setMinimumSize(const Size(400, 600));
    WindowManager.instance.setMaximumSize(const Size(400, 900));
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Service Manager',
      theme: ThemeData(),
      initialRoute: 'HomePage',
      routes: {
        LoginPage.id: (_) => LoginPage(),
        HomePage.id: (_) => HomePage(),
        ChangePassword.id: (_) => const ChangePassword(),
        CreateServiceStopStarter.id: (_) => const CreateServiceStopStarter(),
        AddRemoteServer.id: (_) => const AddRemoteServer(),
      },
    );
  }
}
