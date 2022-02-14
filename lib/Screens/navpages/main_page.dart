import 'package:flutter/material.dart';
import 'package:simba_coding_project/Screens/convert/convert_screen.dart';
import 'package:simba_coding_project/Screens/home/home.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List pages = [
    HomePage(),
    ConvertScreen(),
  ];
  int currentIndex = 0;
  void onTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        unselectedFontSize: 0,
        selectedFontSize: 0,
        currentIndex: currentIndex,
        showSelectedLabels: false,
        selectedItemColor: Colors.black54,
        showUnselectedLabels: false,
        elevation: 0,
        unselectedItemColor: Colors.grey.withOpacity(0.5),
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        items: [
          BottomNavigationBarItem(
            // ignore: deprecated_member_use
            title: Text('Home'),
            icon: Icon(Icons.menu_open),
          ),
          BottomNavigationBarItem(
            // ignore: deprecated_member_use
            title: Text('Convert'),
            icon: Icon(
              Icons.money,
            ),
          ),
        ],
      ),
    );
  }
}
