import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.search , color: Colors.blueAccent,),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home , color: Colors.blueAccent,),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.category, color: Colors.blueAccent,),
          label: 'Categories',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person, color: Colors.blueAccent,),
          label: 'Profile',
        ),
      ],
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.pushNamed(context, '/search');
            break;
          case 1:
            Navigator.pushNamed(context, '/home');
            break;
          case 2:
            Navigator.pushNamed(context, '/category');
            break;
          case 3:
            Navigator.pushNamed(context, '/profile');
            break;
        }
      },
    );
  }
}
