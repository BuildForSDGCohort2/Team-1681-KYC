import 'package:flutter/material.dart';
import 'package:kyc_client/widgets/build_user_banner.dart';

class TopNav extends StatelessWidget {
  final String title;
  final bool homenav;
  final bool menu;
  TopNav({this.title, this.homenav = false, this.menu = true});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: homenav ? 190 : 65,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).accentColor,
            ]),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    menu
                        ? Icon(
                            Icons.menu,
                            color: Colors.white,
                          )
                        : GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: Icon(
                              Icons.chevron_left,
                              color: Colors.white,
                            ),
                          ),
                    Text(
                      title,
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
                homenav
                    ? SizedBox(
                        height: 20,
                      )
                    : SizedBox.shrink(),
                homenav
                    ? UserBanner(
                        profile: 'https://blurha.sh/assets/images/img1.jpg')
                    : SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
