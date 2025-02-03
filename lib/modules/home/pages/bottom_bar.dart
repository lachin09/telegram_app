import 'package:flutter/material.dart';
import 'package:supa_app/modules/home/pages/add_prod_page.dart';
import 'package:supa_app/modules/home/pages/home_page.dart';

class BottomNavigator extends StatefulWidget {
  const BottomNavigator({super.key});

  @override
  State<BottomNavigator> createState() => _BottomNavigatorState();
}

class _BottomNavigatorState extends State<BottomNavigator> {
  int _selectedIndex = 0;
  static List<Widget> screens = <Widget>[
    const ProductListScreen(),
    const AddProductScreen(),
  ];
  void _onItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: screens.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "home"),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: "add product"),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: (Colors.amber[800]),
        onTap: _onItemSelected,
      ),
    );
  }
}
