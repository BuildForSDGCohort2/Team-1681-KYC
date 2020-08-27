import 'package:flutter/material.dart';

import 'package:kyc_client/api/databaseProvider.dart';
import 'package:kyc_client/widgets/build_user_banner.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final dbprovider = DatabaseProvider.db;
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final double devWidth = MediaQuery.of(context).size.width;
    final double targetWidth = devWidth > 550.0 ? 500.0 : devWidth * 0.95;
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: targetWidth * 0.55,
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
                            'KYC',
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
                      SizedBox(
                        height: 20,
                      ),
                      UserBanner(
                          profile: 'https://blurha.sh/assets/images/img1.jpg')
                    ],
                  ),
                ),
              )
            ],
          ),
          Positioned(
              top: 150,
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    buildContactSummary(
                      icon: Icons.today,
                      label: 'Today',
                      data: 1200,
                      iconColor: Color(0xFF00b300),
                    ),
                    buildContactSummary(
                      icon: Icons.people_outline,
                      label: 'All Contacts',
                      data: 20,
                      iconColor: Color(0xFFffa500),
                    ),
                    buildContactSummary(
                      icon: Icons.mood_bad,
                      label: 'Infected',
                      data: 0,
                      iconColor: Color(0xFFb33636),
                    ),
                  ],
                ),
              ))
        ],
      ),
      bottomNavigationBar: Row(
        children: [
          _buildNavItem(
            icon: Icons.home,
            title: 'Home',
            index: 0,
          ),
          _buildNavItem(
            icon: Icons.flag,
            title: 'Reports',
            index: 1,
          ),
          _buildNavItem(
            icon: Icons.assessment,
            title: 'Stats',
            index: 2,
          ),
          _buildNavItem(
            icon: Icons.settings,
            title: 'Settings',
            index: 3,
          )
        ],
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              backgroundColor: Color(0xFF00B686),
              onPressed: () {},
              child: Icon(Icons.crop_free),
            )
          : SizedBox.shrink(),
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

  GestureDetector _buildNavItem({IconData icon, String title, int index}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        padding: EdgeInsets.only(top: 8),
        width: MediaQuery.of(context).size.width / 4,
        height: 60,
        decoration: index == _selectedIndex
            ? BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: 4,
                    color: Color(0xFF00B686),
                  ),
                ),
                gradient: LinearGradient(
                  colors: [
                    Colors.green.withOpacity(0.4),
                    Colors.green.withOpacity(0.155)
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              )
            : BoxDecoration(),
        child: Column(
          children: [
            Icon(
              icon,
              color: index == _selectedIndex ? Color(0xFF00B868) : Colors.grey,
            ),
            Text(
              title,
              style: TextStyle(
                color:
                    index == _selectedIndex ? Color(0xFF00B686) : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
