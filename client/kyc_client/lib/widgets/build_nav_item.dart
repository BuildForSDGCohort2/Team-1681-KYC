import 'package:flutter/material.dart';

class BuildNavItem extends StatefulWidget {
  BuildNavItem({
    @required this.icon,
    @required this.title,
    @required this.index,
  });

  final IconData icon;
  final String title;
  final int index;

  @override
  _BuildNavItemState createState() => _BuildNavItemState();
}

class _BuildNavItemState extends State<BuildNavItem> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = widget.index;
        });
      },
      child: Container(
        width: MediaQuery.of(context).size.width / 4,
        height: 60,
        decoration: widget.index == _selectedIndex
            ? BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 4, color: Colors.green),
                ),
              )
            : BoxDecoration(),
        child: Column(
          children: [
            Icon(
              widget.icon,
              color: Colors.grey,
            ),
            Text(
              widget.title,
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
