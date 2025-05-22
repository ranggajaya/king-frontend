import 'package:flutter/material.dart';
import 'package:king_frontend/models/product_model.dart';
import 'package:king_frontend/screens/detail_product_screen.dart';
import 'package:king_frontend/themes/theme.dart';

import '../services/url.dart';

class ProductTile extends StatelessWidget {
  final ProductModel product;
  ProductTile(this.product);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailProductScreen(product),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(
          left: defaultMargin,
          right: defaultMargin,
          bottom: defaultMargin,
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: product.galleries.isNotEmpty
                  ? Image.network(
                      "$urlBaseImage${product.galleries[0].url}",
                      width: 215,
                      height: 150,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: 215,
                      height: 150,
                      color: Colors.grey[200],
                      child: Icon(Icons.image_not_supported),
                    ),
            ),
            SizedBox(
              width: 12,
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.categories.name,
                  style: secondaryTextStyle.copyWith(
                    fontSize: 12,
                  ),
                ),
                SizedBox(
                  height: 6,
                ),
                Text(
                  product.name,
                  style: primaryTextStyle.copyWith(
                    fontSize: 16,
                    fontWeight: semiBold,
                  ),
                ),
                SizedBox(
                  height: 6,
                ),
                Text(
                  'Rp${product.price}',
                  style: priceTextStyle.copyWith(
                    fontWeight: medium,
                  ),
                ),
              ],
            ))
          ],
        ),
      ),
    );
  }
}
