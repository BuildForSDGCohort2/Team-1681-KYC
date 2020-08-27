import 'package:flutter/material.dart';

class InfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Title Here'),
      ),
      body: SafeArea(child: Center(child: Text('Information'),)),
    );
  }
}
