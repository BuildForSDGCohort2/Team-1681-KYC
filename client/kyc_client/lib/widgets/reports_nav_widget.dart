import 'package:flutter/material.dart';
import 'package:kyc_client/widgets/top_nav.dart';

class ReportsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        TopNav(
          title: 'Reports',
        ),
        Center(
          child: Text('Reports Page'),
        )
      ],
    );
  }
}
