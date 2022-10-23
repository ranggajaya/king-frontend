import 'package:flutter/material.dart';
import 'package:king_frontend/models/user_model.dart';
import 'package:king_frontend/providers/auth_provider.dart';
import 'package:king_frontend/themes/theme.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    UserModel user = authProvider.user;

    Widget header() {
      return AppBar(
        backgroundColor: backgroundColor1,
        automaticallyImplyLeading: false,
        elevation: 0,
        flexibleSpace: SafeArea(
          child: Container(
            padding: EdgeInsets.all(defaultMargin),
            child: Row(
              children: [
                ClipOval(
                  child: Image.network(
                    user.profilePhotoUrl,
                    width: 64,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hi, ${user.name}',
                        style: primaryTextStyle.copyWith(
                          fontSize: 24,
                          fontWeight: semiBold,
                        ),
                      ),
                      Text(
                        '@${user.username}',
                        style: subtitleTextStyle.copyWith(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/sign-in', (route) => false);
                  },
                  child: Image.asset(
                    'assets/button_exit.png',
                    width: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    Widget menuItemProfile(String text) {
      return Container(
        margin: EdgeInsets.only(top: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: secondaryTextStyle.copyWith(fontSize: 16),
            ),
            Icon(
              Icons.chevron_right,
              color: primaryTextColor,
            ),
          ],
        ),
      );
    }

    Widget content() {
      return Expanded(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: defaultMargin),
          decoration: BoxDecoration(
            color: backgroundColor3,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                'Account',
                style: primaryTextStyle.copyWith(
                  fontSize: 20,
                  fontWeight: semiBold,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/edit-profile');
                },
                child: menuItemProfile('Edit Profile'),
              ),
              menuItemProfile('Your Orders'),
              menuItemProfile('Help'),
              SizedBox(
                height: 30,
              ),
              Text(
                'General',
                style: primaryTextStyle.copyWith(
                  fontSize: 20,
                  fontWeight: semiBold,
                ),
              ),
              menuItemProfile('Privacy & Policy'),
              menuItemProfile('Term of Service'),
              menuItemProfile('Rate App'),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        header(),
        content(),
      ],
    );
  }
}
