import 'package:flutter/material.dart';

class BuildContactSummary extends StatelessWidget {
  final int contacts;
  final String description;
  BuildContactSummary(this.contacts, this.description);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print(contacts);
      },
      child: Container(
        width: 100,
        margin: EdgeInsets.only(bottom: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.blue),
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Text(
                contacts.toString(),
                style: TextStyle(color: Colors.white),
              ),
              alignment: Alignment.center,
              padding: EdgeInsets.all(15),
              margin: EdgeInsets.all(10),
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: Colors.green),
            ),
            Text(description)
          ],
        ),
      ),
    );
  }
}
