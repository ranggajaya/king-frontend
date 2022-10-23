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
    createdAt = DateTime.parse(json['created_at']);
    updatedAt = DateTime.parse(json['uppdated_at']);
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
      'createdAt': createdAt.toString(),
      'updatedAt': updatedAt.toString(),
    };
  }
}
