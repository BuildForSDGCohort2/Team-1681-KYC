import 'package:flutter/material.dart';
import 'package:kyc_client/widgets/top_nav.dart';

class StatisticsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        TopNav(
          title: 'Statistics',
        ),
        Center(
          child: Text('Statistics Page'),
        ),
      ],
    );
  }
}
