import 'package:flutter/material.dart';

import 'package:flutter/foundation.dart';
import 'package:kyc_client/db/databaseProvider.dart';
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
  Provider.debugCheckInvalidValueType = null;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (context) => AuthProvider(),
        ),
        ChangeNotifierProvider<DatabaseProvider>(
            create: (context) => DatabaseProvider.db),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'KYC',
        theme: ThemeData(
          platform: TargetPlatform.iOS,
          primaryColor: Colors.orange,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: AuthScreen(),
      ),
    );
  }
}
