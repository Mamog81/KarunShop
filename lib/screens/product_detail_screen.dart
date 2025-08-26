import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../utils/constants.dart'; // Import Constants for colors

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  ProductDetailScreen({required this.product});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  PageController _pageController = PageController();
  int _currentImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.title),
        backgroundColor: Constants.nBlue, // AppBar color from palette
        foregroundColor: Colors.white,
        actions: [
          Consumer<CartProvider>(
            builder: (context, cartProvider, child) {
              return Stack(
                children: [
                  IconButton(
                    icon: Icon(Icons.shopping_cart),
                    onPressed: () => Navigator.pushNamed(context, '/cart'),
                  ),
                  if (cartProvider.itemCount > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '${cartProvider.itemCount}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Image Gallery ---
            Container(
              height: 300,
              child: Stack(
                children: [
                  PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentImageIndex = index;
                      });
                    },
                    itemCount: widget.product.images.length,
                    itemBuilder: (context, index) {
                      return Image.network(
                        widget.product.images[index],
                        fit: BoxFit.contain,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(child: CircularProgressIndicator());
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[200],
                            child: Icon(Icons.image, size: 100, color: Colors.grey),
                          );
                        },
                      );
                    },
                  ),
                  if (widget.product.images.length > 1)
                    Positioned(
                      bottom: 10,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          widget.product.images.length,
                              (index) => Container(
                            width: 8,
                            height: 8,
                            margin: EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentImageIndex == index
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.4),
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (widget.product.discountPercentage > 0)
                    Positioned(
                      top: 16,
                      right: 16,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${widget.product.discountPercentage.toStringAsFixed(0)}% OFF',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // --- Product Details ---
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Title
                  Text(
                    widget.product.title,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Constants.nCharcoal, // Title color from palette
                    ),
                  ),
                  SizedBox(height: 8),

                  // Brand Info
                  if (widget.product.brand.isNotEmpty)
                    Text(
                      'Brand: ${widget.product.brand}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  SizedBox(height: 8),

                  // Price & Rating
                  Row(
                    children: [
                      Text(
                        '\$${widget.product.price.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Constants.nOrange, // Price color from palette
                        ),
                      ),
                      SizedBox(width: 16),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 20),
                          Text(
                            widget.product.rating.toStringAsFixed(1),
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 8),

                  // Availability Status
                  SizedBox(height: 8),
                  Text(
                    widget.product.availabilityStatus.isNotEmpty
                        ? widget.product.availabilityStatus
                        : 'In Stock: ${widget.product.stock}',
                    style: TextStyle(
                      fontSize: 16,
                      color: widget.product.stock > 0
                          ? Colors.green
                          : Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 16),

                  // Product Description
                  Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Constants.nCharcoal,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    widget.product.description,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 24),

                  // Customer Reviews Section
                  Text(
                    'Customer Reviews',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Constants.nCharcoal,
                    ),
                  ),
                  SizedBox(height: 16),
                  _buildReviewSection(),
                  SizedBox(height: 80),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, -3),
            ),
          ],
        ),
        child: Consumer<CartProvider>(
          builder: (context, cartProvider, child) {
            return ElevatedButton(
              onPressed: widget.product.stock > 0
                  ? () {
                cartProvider.addToCart(widget.product);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${widget.product.title} added to cart'),
                    duration: Duration(seconds: 2),
                    action: SnackBarAction(
                      label: 'View Cart',
                      onPressed: () => Navigator.pushNamed(context, '/cart'),
                    ),
                  ),
                );
              }
                  : null,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                backgroundColor: widget.product.stock > 0
                    ? Constants.nBlue // Use nBlue for available stock
                    : Colors.grey,
              ),
              child: Text(
                widget.product.stock > 0 ? 'Add to Cart' : 'Out of Stock',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildReviewSection() {
    if (widget.product.reviews.isEmpty) {
      return Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          'No reviews yet',
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          textAlign: TextAlign.center,
        ),
      );
    }

    Map<int, int> ratingCounts = {};
    for (int i = 1; i <= 5; i++) {
      ratingCounts[i] = widget.product.reviews
          .where((review) => review.rating == i)
          .length;
    }

    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text(
                    widget.product.rating.toStringAsFixed(1),
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: List.generate(5, (index) {
                      return Icon(
                        index < widget.product.rating.floor()
                            ? Icons.star
                            : Icons.star_border,
                        color: Colors.amber,
                        size: 20,
                      );
                    }),
                  ),
                  Text('${widget.product.reviews.length} reviews'),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(5, (index) {
                  int starCount = 5 - index;
                  int reviewCount = ratingCounts[starCount] ?? 0;
                  double percentage = widget.product.reviews.isNotEmpty
                      ? reviewCount / widget.product.reviews.length
                      : 0;

                  return Row(
                    children: [
                      Text('$starCount'),
                      Icon(Icons.star, size: 16, color: Colors.amber),
                      Container(
                        width: 100,
                        height: 8,
                        margin: EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: percentage,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                      Text('$reviewCount'),
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
        SizedBox(height: 16),
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: widget.product.reviews.length,
          separatorBuilder: (context, index) => Divider(),
          itemBuilder: (context, index) {
            final review = widget.product.reviews[index];
            return ListTile(
              leading: CircleAvatar(
                child: Text(review.reviewerName[0].toUpperCase()),
                backgroundColor: Constants.nBlue,
                foregroundColor: Colors.white,
              ),
              title: Row(
                children: [
                  Text(
                    review.reviewerName,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  Row(
                    children: List.generate(5, (starIndex) {
                      return Icon(
                        starIndex < review.rating
                            ? Icons.star
                            : Icons.star_border,
                        color: Colors.amber,
                        size: 16,
                      );
                    }),
                  ),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 4),
                  Text(review.comment),
                  SizedBox(height: 4),
                  Text(
                    review.formattedDate,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
