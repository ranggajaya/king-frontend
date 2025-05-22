import 'package:flutter/material.dart';
import 'package:king_frontend/models/cart_model.dart';
import 'package:king_frontend/themes/theme.dart';

import '../services/url.dart';

class CheckoutCard extends StatelessWidget {
  final CartModel cart;
  CheckoutCard(this.cart);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 12),
      padding: EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 20,
      ),
      decoration: BoxDecoration(
        color: backgroundColor4,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: cart.product.galleries.isNotEmpty
                  ? DecorationImage(
                      image: NetworkImage(
                        "$urlBaseImage${cart.product.galleries[0].url}",
                      ),
                      fit: BoxFit.cover,
                    )
                  : null,
              color:
                  Colors.grey[300], // fallback background jika tidak ada gambar
            ),
            child: cart.product.galleries.isEmpty
                ? Icon(Icons.image_not_supported,
                    size: 30, color: Colors.grey[600])
                : null,
          ),
          SizedBox(
            width: 12,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cart.product.name,
                  style: primaryTextStyle.copyWith(fontWeight: semiBold),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(
                  height: 2,
                ),
                Text(
                  'Rp${cart.product.price}',
                  style: priceTextStyle.copyWith(fontWeight: semiBold),
                )
              ],
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            '${cart.quantity} Items',
            style: secondaryTextStyle.copyWith(
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
