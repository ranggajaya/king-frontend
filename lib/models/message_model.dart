import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:king_frontend/models/product_model.dart';

class MessageModel {
  String message;
  int userId;
  String userName;
  String userImage;
  bool isFromUser;
  ProductModel product;
  DateTime createdAt;
  DateTime updatedAt;

  MessageModel({
    this.message,
    this.userId,
    this.userName,
    this.userImage,
    this.isFromUser,
    this.product,
    this.createdAt,
    this.updatedAt,
  });

  MessageModel.fromJson(Map<String, dynamic> json) {
    message = json['message'] ?? json['lastMessage'] ?? '';
    userId = json['userId'];
    userName = json['userName'];
    userImage = json['userImage'];
    isFromUser = json['isFromUser'];
    if (json.containsKey('product') &&
        json['product'] != null &&
        json['product'].isNotEmpty) {
      product = ProductModel.fromJson(json['product']);
    } else {
      product = UninitializedProductModel();
    }
    createdAt = json['createdAt'] == null
        ? null
        : (json['createdAt'] is Timestamp
            ? (json['createdAt'] as Timestamp).toDate()
            : DateTime.parse(json['createdAt'].toString()));

    updatedAt = json['updatedAt'] == null
        ? null
        : (json['updatedAt'] is Timestamp
            ? (json['updatedAt'] as Timestamp).toDate()
            : DateTime.parse(json['updatedAt'].toString()));
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'userId': userId,
      'userName': userName,
      'isFromUser': isFromUser,
      'product': product is UninitializedProductModel ? {} : product.toJson(),
      'createdAt': createdAt.toString(),
      'updatedAt': updatedAt.toString(),
    };
  }
}
