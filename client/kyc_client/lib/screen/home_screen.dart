import 'package:flutter/material.dart';

import 'package:kyc_client/api/databaseProvider.dart';
import 'package:kyc_client/screen/scanbarcode.dart';
import 'package:kyc_client/widgets/home_nav_widget.dart';
import 'package:kyc_client/widgets/reports_nav_widget.dart';
import 'package:kyc_client/widgets/settings_nav_widget.dart';
import 'package:kyc_client/widgets/stat_nav_widget.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final dbprovider = DatabaseProvider.db;
  int _selectedIndex = 0;

  List<Widget> _navPages = [
    HomeWidget(),
    ReportsWidget(),
    StatisticsWidget(),
    SettingWidget()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _navPages[_selectedIndex]),
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
              onPressed: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ScanBarCode(),
                  ),
                );
              },
              child: Icon(Icons.crop_free),
            )
          : SizedBox.shrink(),
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
