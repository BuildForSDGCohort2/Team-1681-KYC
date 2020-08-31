import 'package:flutter/material.dart';
import 'package:kyc_client/api/auth_provider.dart';
import 'package:kyc_client/screen/auth_screen.dart';
import 'package:provider/provider.dart';

void main() {
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
