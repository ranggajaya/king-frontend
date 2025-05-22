import 'package:flutter/material.dart';
import 'package:king_frontend/models/message_model.dart';
import 'package:king_frontend/models/product_model.dart';
import 'package:king_frontend/providers/auth_provider.dart';
import 'package:king_frontend/services/message_service.dart';
import 'package:king_frontend/themes/theme.dart';
import 'package:king_frontend/widget/chat_bubble.dart';
import 'package:provider/provider.dart';

import '../services/url.dart';

class DetailChatScreen extends StatefulWidget {
  ProductModel product;

  DetailChatScreen(this.product);

  @override
  State<DetailChatScreen> createState() => _DetailChatScreenState();
}

class _DetailChatScreenState extends State<DetailChatScreen>
    with WidgetsBindingObserver {
  TextEditingController messageController = TextEditingController(text: '');
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Future.delayed(Duration(milliseconds: 100), () {
    //   scrollToBottom(jump: true); // Gunakan jump untuk langsung ke bawah
    // });
    WidgetsBinding.instance.addObserver(this); // ⬅️ Tambahkan observer
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // ⬅️ Hapus observer
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final bottomInset = WidgetsBinding.instance.window.viewInsets.bottom;
    if (bottomInset > 0.0) {
      // Keyboard muncul
      Future.delayed(Duration(milliseconds: 100), () {
        scrollToBottom(jump: true); // Gunakan jump untuk langsung ke bawah
      });
    }
  }

  void scrollToBottom({bool jump = false}) {
    if (_scrollController.hasClients) {
      if (jump) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      } else {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);

    handleAddMessage() async {
      await MessageService().addMessage(
        user: authProvider.user,
        isFromUser: true,
        product: widget.product,
        message: messageController.text,
      );

      await MessageService().sendToBackend(
        userId: authProvider.user.id,
        token: authProvider.user.token,
        message: messageController.text,
        isFromUser: true,
      );

      widget.product = UninitializedProductModel();
      messageController.clear();
      setState(() {});

      // // ✅ Scroll otomatis ke bawah saat pesan berhasil dimuat
      // WidgetsBinding.instance.addPostFrameCallback((_) {
      //   scrollToBottom(jump: true);
      // });
    }

    Widget header() {
      return PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppBar(
          backgroundColor: backgroundColor1,
          centerTitle: false,
          title: Row(
            children: [
              Image.asset(
                'assets/image_shop_logo_online.png',
                width: 50,
              ),
              SizedBox(
                width: 12,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Shoes Store',
                    style: primaryTextStyle.copyWith(
                      fontWeight: medium,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'Online',
                    style: secondaryTextStyle.copyWith(
                      fontWeight: light,
                      fontSize: 14,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      );
    }

    Widget productAskChat() {
      return Container(
        width: 225,
        height: 100,
        margin: EdgeInsets.only(bottom: 20),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: backgroundColor5,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: primaryColor,
          ),
        ),
        child: Stack(
          children: [
            // Konten utama (gambar + teks) sejajar kiri, tapi tetap vertikal center
            Align(
              alignment: Alignment.centerLeft,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SizedBox(
                      width: 60,
                      height: 60,
                      child: widget.product.galleries.isNotEmpty
                          ? Image.network(
                              "$urlBaseImage${widget.product.galleries[0].url}",
                              fit: BoxFit.cover,
                            )
                          : Container(
                              color: Colors.grey[200],
                              child: Icon(Icons.image_not_supported),
                            ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.product.name,
                          style: primaryTextStyle,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Rp${widget.product.price}',
                          style: priceTextStyle.copyWith(
                            fontWeight: medium,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Tombol close tetap di pojok kanan atas
            Positioned(
              top: 0,
              right: 0,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    widget.product = UninitializedProductModel();
                  });
                },
                child: Image.asset(
                  'assets/button_close.png',
                  width: 18,
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget chatInput() {
      return Container(
        margin: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.product is UninitializedProductModel
                ? SizedBox()
                : productAskChat(),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 45,
                    padding: EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: backgroundColor4,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: TextFormField(
                        controller: messageController,
                        style: primaryTextStyle,
                        decoration: InputDecoration.collapsed(
                          hintText: 'Type Message...',
                          hintStyle: subtitleTextStyle,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                GestureDetector(
                  onTap: handleAddMessage,
                  child: Image.asset(
                    'assets/button_send.png',
                    width: 45,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    Widget content() {
      return StreamBuilder<List<MessageModel>>(
        stream: MessageService().getMessagesByUserId(
          userId: authProvider.user.id,
        ),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return SizedBox(); // Tidak tampilkan apa-apa
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Terjadi kesalahan: ${snapshot.error}',
                style: TextStyle(color: Colors.red),
              ),
            );
          }
          final messages = snapshot.data ?? [];

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_scrollController.hasClients) {
              scrollToBottom(jump: true);
            }
          });

          if (messages.isEmpty) {
            return Center(
              child: Text(
                'Belum ada pesan',
                style: primaryTextStyle.copyWith(fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            controller: _scrollController,
            padding: EdgeInsets.symmetric(horizontal: defaultMargin),
            itemCount: messages.length,
            //reverse: true, // <--- bikin WhatsApp-like
            itemBuilder: (context, index) {
              // Karena reverse, messages[0] akan di paling bawah
              final message = messages[index];
              return ChatBubble(
                isSender: message.isFromUser,
                text: message.message,
                product: message.product,
              );
            },
          );
        },
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor3,
      appBar: header(),
      body: Column(
        children: [
          Expanded(child: content()), // akan scroll saat keyboard muncul
          chatInput(), // akan tetap di atas keyboard
        ],
      ),
    );
  }
}
