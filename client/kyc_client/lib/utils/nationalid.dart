import 'package:flutter/material.dart';

class NationalID extends StatelessWidget {
  const NationalID({
    Key key,
    @required TextEditingController surNameController,
    @required TextEditingController givenNameController,
    @required TextEditingController dobController,
    @required TextEditingController ninController,
  })  : _surNameController = surNameController,
        _givenNameController = givenNameController,
        _dobController = dobController,
        _ninController = ninController,
        super(key: key);

  final TextEditingController _surNameController;
  final TextEditingController _givenNameController;
  final TextEditingController _dobController;
  final TextEditingController _ninController;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 170,
        width: 285,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.red[200],
              Colors.purple[100],
              Colors.purple[200],
              Colors.red[100]
            ],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            // Add one stop for each color
            // Values should increase from 0.0 to 1.0
            stops: [0.0, 0.4, 0.6, 1.0],
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          children: <Widget>[
            Container(
              width: 80,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: 7,
                    right: 5,
                    child: Image.asset(
                      'assets/images/mapug.png',
                      width: 45,
                      height: 45,
                    ),
                  ),
                  Positioned(
                    bottom: 5,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 7, right: 5, bottom: 15, top: 10),
                      child: Container(
                        width: 70,
                        height: 85,
                        decoration: BoxDecoration(
                          color: Colors.white30,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 200,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: 5,
                    left: 2,
                    child: Text(
                      'REPUBLIC OF UGANDA',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Container(
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          top: 20,
                          left: 20,
                          child: Text(
                            'NATIONAL ID CARD',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 30,
                          right: 20,
                          child: Container(
                            width: 25,
                            height: 25,
                            child: Image.asset(
                              'assets/images/mapug.png',
                              width: 25,
                              height: 25,
                              color: Colors.purple,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 40,
                          left: 5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'SURNAME',
                                style: TextStyle(
                                  fontSize: 7,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '${_surNameController.text.toUpperCase()}',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 1,
                              ),
                              Text(
                                'GIVEN NAME',
                                style: TextStyle(
                                  fontSize: 7,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '${_givenNameController.text.toUpperCase()}',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 1,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'NATIONALITY',
                                        style: TextStyle(
                                          fontSize: 7,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        'UGA',
                                        style: TextStyle(
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 13,
                                  ),
                                  Column(
                                    children: <Widget>[
                                      Text(
                                        'SEX',
                                        style: TextStyle(
                                          fontSize: 7,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        'M',
                                        style: TextStyle(
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 13,
                                  ),
                                  Column(
                                    children: <Widget>[
                                      Text(
                                        'DATE OF BIRTH',
                                        style: TextStyle(
                                            fontSize: 7,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 0.2,
                                            wordSpacing: 0.2),
                                      ),
                                      Text(
                                        '${_dobController.text}',
                                        style: TextStyle(
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          bottom: 50,
                          left: 5,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'NIN',
                                style: TextStyle(
                                  fontSize: 7,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '${_ninController.text.toUpperCase()}',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.1,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          bottom: 50,
                          right: 55,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'CARD NO',
                                style: TextStyle(
                                  fontSize: 7,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.2,
                                  wordSpacing: 0.2,
                                ),
                              ),
                              Text(
                                'XXXXXXXXX',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          bottom: 30,
                          left: 5,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'DATE OF EXPIRY',
                                style: TextStyle(
                                  fontSize: 7,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                'XX.XX.XXXX',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.1,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          bottom: 10,
                          left: 5,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'HOLDERS SIGNATURE',
                                style: TextStyle(
                                  fontSize: 7,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                'XXXXXXXX',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.1,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          child: Container(
                            width: 55,
                            height: 55,
                            child: Image.asset(
                              'assets/images/worldoutline.png',
                              colorBlendMode: BlendMode.darken,
                              width: 55,
                              height: 55,
                            ),
                          ),
                          bottom: 2,
                          right: 2,
                        ),
                        Positioned(
                          bottom: 11,
                          right: 11,
                          child: Container(
                            padding: EdgeInsets.all(5),
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              color: Colors.white54,
                            ),
                            child: Image.asset(
                              'assets/images/mapug.png',
                              width: 30,
                              height: 30,
                              color: Colors.purple,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
