import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/product_provider.dart';
import '../providers/category_provider.dart';
import '../widgets/product_card.dart';
import 'product_detail_screen.dart';
import 'category_screen.dart';
import '../models/product.dart';
import '../utils/constants.dart'; // Import Constants for colors

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Constants.nBlue, // Change the status bar color to blue
        statusBarIconBrightness: Brightness.light, // Adjust the icon brightness (light or dark)
      ),
    );


    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false).loadMoreProducts();
      Provider.of<ProductProvider>(context, listen: false).loadAmazingDeals();
    });
  }

  void _navigateToAllProducts(String query) {
    if (query.trim().isNotEmpty) {
      Navigator.pushNamed(
        context,
        '/products',
        arguments: {'query': query.trim()},
      );
    }
  }

  void _onSearchSubmitted(String query) {
    _navigateToAllProducts(query);
  }

  void _onSearchPressed() {
    _navigateToAllProducts(_searchController.text);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Amazing Deals Section
  Widget _buildAmazingDealsSection(List<Product> products) {
    if (products.isEmpty) {
      return SizedBox.shrink();
    }

    return Container(
      color: Constants.nOrange.withOpacity(0.1), // Using your color palette
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical:10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Constants.nOrange, Constants.nOrange], // Color from your palette
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.flash_on, color: Constants.nCharcoal, size: 20),
                SizedBox(width: 8),
                Text(
                  'Amazing Deals',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Constants.nCharcoal,
                  ),
                ),
                Spacer(),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/amazing-deals');
                  },
                  child: Row(
                    children: [
                      Text(
                        'See More...',
                        style: TextStyle(
                          fontSize: 12,
                          color: Constants.nCharcoal,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Constants.nCharcoal,
                        size: 12,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Products Horizontal List using the new ProductCard widget
          Container(
            height: 330,
            padding: EdgeInsets.symmetric(vertical: 12),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 7,
              padding: EdgeInsets.only(right: 16),
              itemBuilder: (context, index) {
                final product = products[index];
                return Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: ProductCard(
                    product: product.toJson(),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ProductDetailScreen(product: product)));
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection() {
    final categories = [
      {'name': 'Beauty', 'icon': Icons.face},
      {'name': 'Furniture', 'icon': Icons.chair},
      {'name': 'Laptops', 'icon': Icons.laptop},
      {'name': 'Motorcycle', 'icon': Icons.motorcycle},
      {'name': 'Phones', 'icon': Icons.phone_android},
      {'name': 'Sunglasses', 'icon': Icons.sunny},
      {'name': 'Tablets', 'icon': Icons.tablet},
      {'name': 'Tops', 'icon': Icons.emoji_people},
      {'name': 'Vehicles', 'icon': Icons.car_repair},
    ];

    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Categories',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Constants.nCharcoal, // From palette
            ),
          ),
          SizedBox(height: 8),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return GestureDetector(
                onTap: () {
                  String categoryName = category['name'] as String;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CategoryScreen(
                        category: categoryName,
                      ),
                    ),
                  );
                },
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          category['icon'] as IconData,
                          size: 40,
                          color: Constants.nBlue, // Use color from palette
                        ),
                        SizedBox(height: 8),
                        Text(
                          category['name'] as String,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Constants.nCharcoal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/categories');
              },
              child: Text(
                'See All Categories',
                style: TextStyle(
                  fontSize: 14,
                  color: Constants.nBlue, // Matching palette color
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Constants.nGrey),
        title: Text('Karun' , style: TextStyle(color: Constants.nGrey , fontWeight: FontWeight.bold),),
        backgroundColor: Constants.nBlue,
        actions: [
          Consumer<CartProvider>(
            builder: (context, cartProvider, child) {
              return Stack(
                children: [
                  IconButton(
                    icon: Icon(Icons.shopping_cart , size: 30,),
                    onPressed: () => Navigator.pushNamed(context, '/cart'),
                  ),
                  if (cartProvider.itemCount > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Constants.nOrange,
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
                            fontSize: 10,
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
      drawer: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return Drawer(
            child: ListView(
              children: [
                UserAccountsDrawerHeader(
                  decoration: BoxDecoration(
                    color: Constants.nBlue, // Use nBlue for background color
                  ),
                  accountName: Text(
                    authProvider.user != null
                        ? '${authProvider.user!.firstName} ${authProvider.user!.lastName}'
                        : 'Guest User',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  accountEmail: Text(
                    authProvider.user?.email ?? '',
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                  currentAccountPicture: CircleAvatar(
                    backgroundImage: authProvider.getProfileImage(
                      authProvider.user?.localImagePath,
                      authProvider.user?.image,
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.shop, color: Constants.nBlue), // Products icon
                  title: Text('Products'),
                  onTap: () => Navigator.pushNamed(context, '/products'),
                ),
                ListTile(
                  leading: Icon(Icons.category, color: Constants.nBlue), // Categories icon
                  title: Text('Categories'),
                  onTap: () => Navigator.pushNamed(context, '/categories'),
                ),
                if (authProvider.isAuthenticated) ...[
                  ListTile(
                    leading: Icon(Icons.shopping_cart, color: Constants.nBlue), // Cart icon
                    title: Text('Shopping Cart'),
                    onTap: () => Navigator.pushNamed(context, '/cart'),
                  ),
                  ListTile(
                    leading: Icon(Icons.edit, color: Constants.nBlue), // Edit profile icon
                    title: Text('Edit Profile'),
                    onTap: () => Navigator.pushNamed(context, '/profile'),
                  ),
                ],
                ListTile(
                  leading: Icon(Icons.support_agent, color: Constants.nBlue), // Support icon
                  title: Text('Support'),
                  onTap: () => Navigator.pushNamed(context, '/support'),
                ),
                ListTile(
                  leading: Icon(
                      authProvider.isAuthenticated ? Icons.logout : Icons.login,
                      color: Constants.nBlue), // Logout/Login icon
                  title: Text(authProvider.isAuthenticated ? 'Logout' : 'Login'),
                  onTap: () {
                    if (authProvider.isAuthenticated) {
                      authProvider.logout();
                      Navigator.pushReplacementNamed(context, '/login');
                    } else {
                      Navigator.pushReplacementNamed(context, '/login');
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
      body: Consumer2<AuthProvider, ProductProvider>(
        builder: (context, authProvider, productProvider, child) {
          if (authProvider.isLoading || productProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search Bar Section
                Container(
                  padding: EdgeInsets.symmetric(vertical: 40 , horizontal: 20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Constants.nBlue,
                        Constants.nBlue.withOpacity(0.7),
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello! What are you looking for?',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 16),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _searchController,
                          onSubmitted: _onSearchSubmitted,
                          onChanged: (value) {
                            setState(() {});
                          },
                          decoration: InputDecoration(
                            hintText: 'Search products...',
                            hintStyle: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 16,
                            ),
                            prefixIcon: IconButton(
                              icon: Icon(
                                Icons.search,
                                color: Constants.nBlue,
                                size: 24,
                              ),
                              onPressed: _onSearchPressed,
                            ),
                            suffixIcon: _searchController.text.isNotEmpty
                                ? IconButton(
                              icon: Icon(
                                Icons.clear,
                                color: Colors.grey[400],
                              ),
                              onPressed: () {
                                setState(() {
                                  _searchController.clear();
                                });
                              },
                            )
                                : null,
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 15,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Amazing Deals Section
                _buildAmazingDealsSection(productProvider.amazingDeals),
                // Categories Section
                _buildCategorySection(),
              ],
            ),
          );
        },
      ),
    );
  }
}
