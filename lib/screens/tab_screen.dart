import 'package:bottom_bar/bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:omega_chat/screens/auth_screen.dart';
import 'package:omega_chat/screens/home_screen.dart';
import 'package:omega_chat/screens/new_user.dart';
import 'package:omega_chat/screens/setting_screen.dart';
import 'package:omega_chat/screens/acc.dart';

class TabScreen extends StatefulWidget {
  const TabScreen({Key? key}) : super(key: key);

  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  int _selectedPageIndex = 0;
  final _pageController = PageController();

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Hero(
          tag: 'logo',
          child: Image.asset(
            'assets/images/logo.png',
            width: 100,
          ),
        ),
      ),
      body: PageView(
        controller: _pageController,
        children: [
          const Scaffold(
            backgroundColor: Colors.blue,
            
          ),
          const Scaffold(
            backgroundColor: Colors.yellow,
            
          ),
          const Scaffold(
            backgroundColor: Colors.red,
            
          ),
          SettingScreen(),
        ],
        onPageChanged: (index) {
          setState(() {
            _selectedPageIndex = index;
          });
        },
      ),
      bottomNavigationBar: BottomBar(
        selectedIndex: _selectedPageIndex,
        onTap: (int index) {
          if (index == _selectedPageIndex + 1 ||
              index == _selectedPageIndex - 1) {
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 500),
              curve: Curves.ease,
            );
          } else {
            _pageController.jumpToPage(index);
          }

          print('Index page is $index');
          setState(() => _selectedPageIndex = index);
        },
        items: <BottomBarItem>[
          const BottomBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
            activeColor: Colors.blue,
          ),
          const BottomBarItem(
            icon: Icon(Icons.favorite),
            title: Text('Favorites'),
            activeColor: Colors.red,
          ),
          BottomBarItem(
            icon: const Icon(Icons.person),
            title: const Text('Account'),
            activeColor: Colors.greenAccent.shade700,
          ),
          const BottomBarItem(
            icon: Icon(Icons.settings),
            title: Text('Settings'),
            activeColor: Colors.orange,
          ),
        ],
      ),
    );
  }
}
