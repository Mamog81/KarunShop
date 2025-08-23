import 'package:flutter/material.dart';

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
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // تصویر محصول
              SizedBox(
                width: 100,
                height: 100,
                child: product['thumbnail'] != null
                    ? Image.network(
                  product['thumbnail'],
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(child: CircularProgressIndicator());
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[200],
                      child: const Icon(Icons.image, size: 50, color: Colors.grey),
                    );
                  },
                )
                    : Container(
                  color: Colors.grey[200],
                  child: const Icon(Icons.image, size: 50, color: Colors.grey),
                ),
              ),
              const SizedBox(width: 12),
              // اطلاعات محصول
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // نام و برند محصول
                    Text(
                      product['title'] ?? 'Unknown',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (product['brand'] != null)
                      Text(
                        product['brand'],
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    const SizedBox(height: 8),

                    // بخش قیمت و تخفیف
                    Row(
                      children: [
                        if (discountedPrice != null)
                          Text(
                            '\$${discountedPrice.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        const SizedBox(width: 8),
                        if (discountedPrice != null)
                          Text(
                            '\$${price!.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600],
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        if (discount != null)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              '${discount.toStringAsFixed(0)}% off',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ),
                      ],
                    ),

                    // ریتینگ و دکمه
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // ریتینگ
                        if (product['rating'] != null)
                          Row(
                            children: [
                              const Icon(Icons.star, size: 16, color: Colors.amber),
                              Text(
                                product['rating'].toStringAsFixed(1),
                                style: TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),

                        // دکمه افزودن به سبد
                        if (onAddToCart != null)
                          Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.add_shopping_cart),
                              color: Colors.white,
                              iconSize: 16,
                              onPressed: onAddToCart,
                            ),
                          ),
                      ],
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