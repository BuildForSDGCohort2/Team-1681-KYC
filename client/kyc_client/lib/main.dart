import 'package:flutter/material.dart';

import 'package:flutter/foundation.dart';
import 'dart:io';

import 'package:provider/provider.dart';

import 'package:kyc_client/api/auth_provider.dart';
import 'package:kyc_client/screen/auth_screen.dart';

void _enablePlatformOverrideForDesktop() {
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux)) {
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  }
}

void main() {
  _enablePlatformOverrideForDesktop();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        platform: TargetPlatform.iOS,
        primaryColor: Color(0xFF00B686),
        accentColor: Color(0xFF00838F),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ChangeNotifierProvider(
        create: (BuildContext context) => AuthProvider(),
        child: AuthScreen(),
      ),
    );
  }
}
