// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:king_frontend/models/message_model.dart';
// import 'package:king_frontend/models/product_model.dart';
// import 'package:king_frontend/models/user_model.dart';

// class MessageService {
//   FirebaseFirestore firestore = FirebaseFirestore.instance;

//   Stream<List<MessageModel>> getMessagesByUserId({int userId}) {
//     try {
//       return firestore
//           .collection('messages')
//           .where('userId', isEqualTo: userId)
//           .snapshots()
//           .map((QuerySnapshot list) {
//         var result = list.docs.map<MessageModel>((DocumentSnapshot messages) {
//           print("🔥 Raw data: ${messages.data()}");
//           return MessageModel.fromJson(messages.data());
//         }).toList();

//         result.sort(
//           (MessageModel a, MessageModel b) =>
//               a.createdAt.compareTo(b.createdAt),
//         );

//         return result;
//       });
//     } catch (e) {
//       throw Exception("Gagal mendapatkan pesan: $e");
//     }
//   }

//   Future<void> addMessage(
//       {UserModel user,
//       bool isFromUser,
//       String message,
//       ProductModel product}) async {
//     try {
//       firestore.collection('messages').add({
//         'userId': user.id,
//         'userName': user.name,
//         'userImage': user.profilePhotoUrl,
//         'isFromUser': isFromUser,
//         'message': message,
//         'product': product is UninitializedProductModel ? {} : product.toJson(),
//         'createdAt': DateTime.now().toString(),
//         'updatedAt': DateTime.now().toString(),
//       }).then(
//         (value) => print('Pesan Berhasil Dikirim'),
//       );
//     } catch (e) {
//       throw Exception('Pesan Gagal Dikirim: $e');
//     }
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:king_frontend/models/message_model.dart';
import 'package:king_frontend/models/product_model.dart';
import 'package:king_frontend/models/user_model.dart';
import 'package:king_frontend/services/url.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MessageService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final urlFix = '$urlBase/post-message-user';

  // Ambil semua pesan dari subkoleksi 'chats' berdasarkan userId
  Stream<List<MessageModel>> getMessagesByUserId({int userId}) {
    try {
      return firestore
          .collection('messages')
          .doc(userId.toString()) // Gunakan userId sebagai ID dokumen
          .collection('chats') // Subkoleksi 'chats'
          .orderBy('createdAt') // Urutkan berdasarkan waktu
          .snapshots()
          .map((QuerySnapshot snapshot) {
        return snapshot.docs.map<MessageModel>((doc) {
          print("🔥 Raw chat data: ${doc.data()}");
          return MessageModel.fromJson(doc.data() as Map<String, dynamic>);
        }).toList();
      });
    } catch (e) {
      throw Exception("Gagal mendapatkan pesan: $e");
    }
  }

  Stream<List<MessageModel>> getChatForCurrentUser(int userId) {
    return firestore
        .collection('messages')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return MessageModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // Tambahkan pesan ke subkoleksi 'chats'
  Future<void> addMessage({
    UserModel user,
    bool isFromUser,
    String message,
    ProductModel product,
  }) async {
    try {
      final messageData = {
        'isFromUser': isFromUser,
        'message': message,
        'createdAt': Timestamp.now(),
        'product': product is UninitializedProductModel ? {} : product.toJson(),
      };

      final userDocRef =
          firestore.collection('messages').doc(user.id.toString());

      // Tambahkan metadata (optional: bisa untuk preview daftar chat)
      await userDocRef.set({
        'userId': user.id,
        'userName': user.name,
        'userImage': user.profilePhotoUrl,
        'updatedAt': Timestamp.now(),
        'lastMessage': message,
      }, SetOptions(merge: true));

      // Tambahkan pesan ke subkoleksi 'chats'
      await userDocRef.collection('chats').add(messageData);

      print('✅ Pesan berhasil dikirim');
    } catch (e) {
      throw Exception('❌ Pesan gagal dikirim: $e');
    }
  }

  Future<void> sendToBackend({
    int userId,
    String token,
    String message,
    bool isFromUser,
  }) async {
    final url = Uri.parse(urlFix);

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'user_id': userId,
          'message': message,
          'isFromUser': isFromUser,
        }),
      );

      if (response.statusCode == 200) {
        print('Pesan berhasil dikirim ke backend');
      } else {
        print('Gagal mengirim pesan ke backend: ${response.body}');
      }
    } catch (e) {
      print('Error saat mengirim pesan ke backend: $e');
      throw Exception('Gagal mengirim pesan ke backend: $e');
    }
  }
}
