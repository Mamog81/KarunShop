import 'package:flutter/material.dart';
import '../utils/constants.dart';

class ProductCard extends StatelessWidget {
  final Map<String, dynamic> product;
  final VoidCallback? onAddToCart;
  final VoidCallback? onTap;

  const ProductCard({
    Key? key,
    required this.product,
    this.onAddToCart,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // محاسبه قیمت با تخفیف
    final double? price = product['price']?.toDouble();
    final double? discount = product['discountPercentage']?.toDouble();
    final double? discountedPrice = (price != null && discount != null)
        ? price * (1 - discount / 100)
        : null;

    return Card(
      elevation: 6,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 180,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // تصویر محصول
              Stack(
                children: [
                  Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                      child: product['thumbnail'] != null
                          ? Image.network(
                        product['thumbnail'],
                        fit: BoxFit.contain,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).primaryColor,
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[100],
                            child: const Icon(
                              Icons.image_not_supported,
                              size: 50,
                              color: Colors.grey,
                            ),
                          );
                        },
                      )
                          : Container(
                        color: Colors.grey[100],
                        child: const Icon(
                          Icons.image_not_supported,
                          size: 50,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),

                  // بج تخفیف
                  if (discount != null && discount > 0)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Constants.nOrange,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${discount.toStringAsFixed(0)}% OFF',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),

              // محتوای پایین کارت
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // برند
                    if (product['brand'] != null)
                      Container(
                        margin: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          product['brand'],
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                    // نام محصول
                    Text(
                      product['title'] ?? 'Unknown Product',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 8),

                    // ریتینگ
                    if (product['rating'] != null)
                      Row(
                        children: [
                          ...List.generate(5, (index) {
                            return Icon(
                              index < product['rating'].floor()
                                  ? Icons.star
                                  : Icons.star_border,
                              size: 11,
                              color: Constants.nOrange,
                            );
                          }),
                          const SizedBox(width: 4),
                          Text(
                            product['rating'].toStringAsFixed(1),
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),

                    const SizedBox(height: 8),

                    // قیمت
                    Row(
                      children: [
                        if (discountedPrice != null) ...[
                          Text(
                            '\$${discountedPrice.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Constants.nOrange,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '\$${price!.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 9,
                              color: Colors.grey[500],
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ] else if (price != null)
                          Text(
                            '\$${price.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 2),

                    // دکمه افزودن به سبد
                    if (onAddToCart != null)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: onAddToCart,
                          icon: const Icon(Icons.shopping_cart_outlined, size: 16 , color: Constants.nBlue,),
                          label: const Text(
                            'Add to Cart',
                            style: TextStyle(fontSize: 12 , color: Constants.nBlue,),
                          ),
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}