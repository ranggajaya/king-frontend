import 'package:flutter/material.dart';
import 'package:king_frontend/models/message_model.dart';
import 'package:king_frontend/providers/auth_provider.dart';
import 'package:king_frontend/providers/page_provider.dart';
import 'package:king_frontend/services/message_service.dart';
import 'package:king_frontend/themes/theme.dart';
import 'package:king_frontend/widget/chat_tile.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    PageProvider pageProvider = Provider.of<PageProvider>(context);

    Widget header() {
      return AppBar(
        backgroundColor: backgroundColor1,
        centerTitle: true,
        title: Text(
          'Message Support',
          style: primaryTextStyle.copyWith(
            fontSize: 18,
            fontWeight: medium,
          ),
        ),
        elevation: 0,
        automaticallyImplyLeading: false,
      );
    }

    Widget emptyChat() {
      return Expanded(
        child: Container(
          width: double.infinity,
          color: backgroundColor3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/icon_headset.png',
                width: 80,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Oops no message yet?',
                style: primaryTextStyle.copyWith(
                  fontSize: 16,
                  fontWeight: medium,
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Text(
                'You have never done a transaction',
                style: secondaryTextStyle,
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 44,
                child: TextButton(
                  onPressed: () {
                    pageProvider.currentIndex = 0;
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 24,
                    ),
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Explore Store',
                    style: primaryTextStyle.copyWith(
                      fontSize: 16,
                      fontWeight: medium,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    }

    Widget content() {
      return StreamBuilder<List<MessageModel>>(
        stream: MessageService().getChatForCurrentUser(authProvider.user.id),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print('Terjadi kesalahan: ${snapshot.error}');
            return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final users = snapshot.data ?? [];

          if (users.isEmpty) {
            return emptyChat();
          }

          return Expanded(
            child: Container(
              width: double.infinity,
              color: backgroundColor3,
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: defaultMargin),
                itemCount: users.length,
                itemBuilder: (context, index) {
                  return ChatTile(users[index]); // Per user
                },
              ),
            ),
          );
        },
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
