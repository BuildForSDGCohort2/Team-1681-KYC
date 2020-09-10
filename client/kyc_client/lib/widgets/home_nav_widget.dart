import 'package:flutter/material.dart';
import 'package:kyc_client/db/databaseProvider.dart';
import 'package:kyc_client/models/contacttrace.dart';
import 'package:kyc_client/screen/usercontacts.dart';
import 'package:kyc_client/widgets/top_nav.dart';
import 'package:provider/provider.dart';

class HomeWidget extends StatefulWidget {
  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  @override
  Widget build(BuildContext context) {
    final double devWidth = MediaQuery.of(context).size.width;
    final double targetWidth = devWidth > 550.0 ? 500.0 : devWidth * 0.95;
    return Stack(
      children: [
        TopNav(
          homenav: true,
          title: 'KYC',
        ),
        Positioned(
            top: 135,
            right: 0,
            child: Container(
              height: 120,
              width: targetWidth * 0.85,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.2),
                    blurRadius: 8,
                    spreadRadius: .3,
                    offset: Offset(0, 10),
                  ),
                ],
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  topLeft: Radius.circular(8),
                ),
              ),
              child: Consumer<DatabaseProvider>(
                builder: (context, model, child) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    buildContactSummary(
                      icon: Icons.today,
                      label: 'Today',
                      data: model.contactsToday,
                      iconColor: Color(0xFF00b300),
                    ),
                    buildContactSummary(
                      icon: Icons.people_outline,
                      label: 'All Contacts',
                      data: model.contactList,
                      iconColor: Color(0xFFffa500),
                    ),
                    buildContactSummary(
                      icon: Icons.mood_bad,
                      label: 'Infected',
                      data: model.contactsInfected,
                      iconColor: Color(0xFFb33636),
                    ),
                  ],
                ),
              ),
            ))
      ],
    );
  }

  InkWell buildContactSummary(
      {IconData icon, String label, List<ContactTrace> data, Color iconColor}) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => UserContacts(
                  type: label,
                  allcontacts: data,
                )));
      },
      child: Container(
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
              padding: EdgeInsets.only(left: 3, right: 3),
              decoration: BoxDecoration(
                color: iconColor,
                border: Border.all(color: iconColor),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  data.length.toString(),
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
