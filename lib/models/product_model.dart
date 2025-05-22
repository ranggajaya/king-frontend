import 'package:king_frontend/models/categories_model.dart';
import 'package:king_frontend/models/galleries_model.dart';

class ProductModel {
  int id;
  String name;
  double price;
  String description;
  String tags;
  CategoriesModel categories;
  DateTime createdAt;
  DateTime updatedAt;
  List<GalleriesModel> galleries;

  ProductModel({
    this.id,
    this.name,
    this.price,
    this.description,
    this.tags,
    this.categories,
    this.createdAt,
    this.updatedAt,
    this.galleries,
  });

  ProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = double.parse(json['price'].toString());
    description = json['description'];
    tags = json['tags'];
    categories = CategoriesModel.fromJson(json['category']);
    galleries = json['galleries']
        .map<GalleriesModel>((gallery) => GalleriesModel.fromJson(gallery))
        .toList();
    createdAt = json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String);

    updatedAt = json['updated_at'] == null
        ? null
        : DateTime.parse(json['updated_at'] as String);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'description': description,
      'tags': tags,
      'category': categories.toJson(),
      'galleries': galleries.map((gallery) => gallery.toJson()).toList(),
      'created_at': createdAt.toString(),
      'updated_at': updatedAt.toString(),
    };
  }
}

class UninitializedProductModel extends ProductModel {}
