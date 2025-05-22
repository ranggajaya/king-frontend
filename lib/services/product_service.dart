import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:king_frontend/models/product_model.dart';
import 'package:king_frontend/services/url.dart';

class ProductService {
  String baseUrl = urlBase;

  Future<List<ProductModel>> getProducts() async {
    var url = '$baseUrl/products';
    var headers = {'Content-Type': 'application/json'};

    var response = await http.get(Uri.parse(url), headers: headers);

    print("ini response body productnya response.body: ${response.body}");

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body)['data']['data'];
      List<ProductModel> products = [];

      for (var item in data) {
        products.add(ProductModel.fromJson(item));
      }
      print('BERHASIL MENGAMBIL: $products');
      return products;
    } else {
      throw Exception('Gagal Get Products!');
    }
  }
}
