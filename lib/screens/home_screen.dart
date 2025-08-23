import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/cart_provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
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
      drawer: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return Drawer(
            child: ListView(
              children: [
                UserAccountsDrawerHeader(
                  accountName: Text(authProvider.user != null
                      ? '${authProvider.user!.firstName} ${authProvider.user!.lastName}'
                      : 'Guest User'),
                  accountEmail: Text(authProvider.user?.email ?? ''),
                  currentAccountPicture: CircleAvatar(
                    backgroundImage: NetworkImage(
                      authProvider.user?.image ??
                          'https://dummyjson.com/icon/emilys/128',
                    ),
                  ),
                ),
                ListTile(
                  title: Text('َProducts'),
                  onTap: () => Navigator.pushNamed(context, '/products'),
                ),ListTile(
                  title: Text('Categories'),
                  onTap: () => Navigator.pushNamed(context, '/categories'),
                ),
                if (authProvider.isAuthenticated) ...[
                  ListTile(
                    title: Text('Shopping Cart'),
                    onTap: () => Navigator.pushNamed(context, '/cart'),
                  ),
                  ListTile(
                    title: Text('Edit Profile'),
                    onTap: () => Navigator.pushNamed(context, '/profile'),
                  ),
                ],
                ListTile(
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
      body: Center(
        child: Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            if (authProvider.isLoading) {
              return CircularProgressIndicator();
            }
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Welcome to the Home Page!'),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}