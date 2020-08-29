import 'package:flutter/material.dart';

class StatisticsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double devWidth = MediaQuery.of(context).size.width;
    final double targetWidth = devWidth > 550.0 ? 500.0 : devWidth * 0.95;
    return Stack(
      children: [
        Column(
          children: [
            Container(
              height: targetWidth * 0.20,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Color(0xFF00B686),
                  Color(0xFF00838F),
                ]),
              ),
              child: Padding(
                padding: EdgeInsets.only(top: 40, left: 20, right: 20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          Icons.menu,
                          color: Colors.white,
                        ),
                        Text(
                          'Statistics',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        Icon(
                          Icons.notifications,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
        Center(
          child: Text('Saistics Page'),
        )
      ],
    );
  }
}
