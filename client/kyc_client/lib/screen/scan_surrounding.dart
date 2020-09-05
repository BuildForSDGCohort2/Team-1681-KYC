import 'package:flutter/material.dart';

class ScanSurrounding extends StatefulWidget {
  @override
  _ScanSurroundingState createState() => _ScanSurroundingState();
}

class _ScanSurroundingState extends State<ScanSurrounding> {
  @override
  initState() {
    super.initState();
  }

  Widget _buildSurroundingScan(BuildContext context) {
    final double devWidth = MediaQuery.of(context).size.width;
    final double devHeight = MediaQuery.of(context).size.height;
    final double targetWidth = devWidth > 550.0 ? 500.0 : devWidth * 0.95;
    return Column(
      children: [
        Column(
          children: [
            Container(
              height: 65,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).accentColor,
                ]),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: Icon(
                              Icons.chevron_left,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Scan Surrounding',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          Icon(
                            Icons.more_vert,
                            color: Colors.white,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).accentColor,
              ]),
            ),
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                    // color: Colors.white,
                    borderRadius: BorderRadius.circular(
                        MediaQuery.of(context).size.width * 0.95 / 2)),
                width: MediaQuery.of(context).size.width * 0.95,
                height: MediaQuery.of(context).size.width * 0.95,
                child: SizedBox(
                  child: CircularProgressIndicator(
                    strokeWidth: 1,
                    semanticsValue: 'Scans',
                    backgroundColor: Colors.green.withOpacity(0.3),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _buildSurroundingScan(context)),
    );
  }
}
