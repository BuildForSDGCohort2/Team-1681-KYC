import 'package:flutter/material.dart';
import 'package:kyc_client/models/contacttrace.dart';

class BuildGrid extends StatefulWidget {
  final List<Map> linkedData;
  final List<ContactTrace> contacts;
  final List<IconData> summaryIcons;
  BuildGrid(this.linkedData, this.summaryIcons, this.contacts);

  @override
  _BuildGridState createState() => _BuildGridState();
}

class _BuildGridState extends State<BuildGrid> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GridView.builder(
      itemCount: 3,
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: size.width / 3),
      itemBuilder: (context, index) {
        final data = widget.linkedData[index];
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => data['action'],
                fullscreenDialog: true,
              ),
            );
          },
          child: Card(
            color: Colors.lightBlue.shade300,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 5, bottom: 5),
                  child: Container(
                    padding: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: data['color'],
                      border: Border.all(color: data['color']),
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    child: Icon(
                      widget.summaryIcons[index],
                      size: 25,
                      color: Colors.white,
                    ),
                  ),
                ),
                Text(
                  data['name'],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  width: 70,
                  padding: EdgeInsets.only(left: 5, right: 5),
                  decoration: BoxDecoration(
                      color: data['color'],
                      border: Border.all(color: data['color']),
                      borderRadius: BorderRadius.circular(15)),
                  child: Center(
                    child: Text(
                      data['count'].toString(),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
