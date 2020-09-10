import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kyc_client/screen/qrcodepage.dart';

class UserBanner extends StatelessWidget {
  final String profile;
  UserBanner({Key key, this.profile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Color(0xFF00B686),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.1),
                blurRadius: 8,
                spreadRadius: 3,
              )
            ],
            border: Border.all(width: 1.5, color: Colors.white),
            borderRadius: BorderRadius.circular(30),
          ),
          padding: EdgeInsets.all(5),
          child: CircleAvatar(
              // backgroundImage: CachedNetworkImageProvider(
              //   profile,
              // ),
              ),
        ),
        SizedBox(
          width: 20,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Elimu Michael',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Icon(
                    Icons.phone,
                    color: Colors.white,
                  ),
                  SizedBox(width: 10),
                  Text(
                    '0779200330',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => QRCodePage(),
            ),
          ),
          child: Image(
            image: AssetImage('assets/images/qrcode.PNG'),
            width: 20,
            height: 20,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
