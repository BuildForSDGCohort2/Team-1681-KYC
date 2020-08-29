import 'package:flutter/material.dart';

class SettingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double devWidth = MediaQuery.of(context).size.width;
    final double devHeight = MediaQuery.of(context).size.height;
    final double targetWidth = devWidth > 550.0 ? 500.0 : devWidth * 0.95;
    return Stack(
      children: [
        Column(
          children: [
            Container(
              height: devHeight * 0.114,
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
                          'Settings',
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
          child: Text('Settings Page'),
        )
      ],
    );
  }

  Container buildContactSummary(
      {IconData icon, String label, int data, Color iconColor}) {
    return Container(
      margin: EdgeInsets.all(5),
      width: 90,
      height: 90,
      decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: Color(0xFF43353),
            child: Icon(
              icon,
              color: iconColor,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            label,
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            width: 85,
            padding: EdgeInsets.only(left: 5, right: 5),
            decoration: BoxDecoration(
              color: iconColor,
              border: Border.all(color: iconColor),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: Text(
                data.toString(),
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
