import 'package:flutter/material.dart';
import 'package:kyc_client/screen/scan_surrounding.dart';
import 'package:kyc_client/widgets/top_nav.dart';

class SettingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Stack(
          children: [
            TopNav(
              title: 'Settings',
            ),
          ],
        ),
        Expanded(
          child: ListView(
            children: [
              Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ScanSurrounding(),
                        ),
                      ),
                      child: Card(
                        margin: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.settings),
                            SizedBox(width: 20),
                            Expanded(child: Text('Scan Surrounding')),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      margin: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.outlined_flag),
                          SizedBox(width: 20),
                          Expanded(child: Text('second task')),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
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
