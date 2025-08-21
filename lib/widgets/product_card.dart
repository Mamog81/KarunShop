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
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // تصویر محصول
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
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
                      child: Icon(Icons.image, size: 50, color: Colors.grey),
                    );
                  },
                )
                    : Container(
                  color: Colors.grey[200],
                  child: Icon(Icons.image, size: 50, color: Colors.grey),
                ),
              ),
            ),

            // اطلاعات محصول
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 9 , vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // نام محصول
                    Text(
                      product['title'] ?? 'Unknown',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    // برند (اگه داشته باشه)
                    if (product['brand'] != null)
                      Text(
                        product['brand'],
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey[600],
                        ),
                      ),

                    Spacer(),

                    // قیمت و دکمه
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // قیمت اصلی
                            Text(
                              '\$${product['price']?.toString() ?? '0'}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),

                            // ریتینگ (اگه داشته باشه)
                            if (product['rating'] != null)
                              Row(
                                children: [
                                  Icon(Icons.star, size: 12, color: Colors.amber),
                                  Text(
                                    product['rating'].toStringAsFixed(1),
                                    style: TextStyle(fontSize: 10, color: Colors.grey),
                                  ),
                                ],
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
                              icon: Icon(Icons.add_shopping_cart),
                              color: Colors.white,
                              iconSize: 16,
                              onPressed: onAddToCart,
                              constraints: BoxConstraints(
                                minWidth: 30,
                                minHeight: 30,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}