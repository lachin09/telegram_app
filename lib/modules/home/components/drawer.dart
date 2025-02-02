import 'package:flutter/material.dart';

Widget drawer = Drawer(
  child: ListView(
    children: [
      DrawerHeader(child: Text("O N L I N E   S H O P ")),
      ListTile(
        leading: Icon(Icons.settings),
        title: Text("S E T T I N G S"),
        trailing: Icon(Icons.forward),
        onTap: () {},
      ),
      ListTile(
        leading: Icon(Icons.category_outlined),
        title: Text("C A T E G O R I E S"),
        trailing: Icon(Icons.forward),
        onTap: () {},
      ),
      ListTile(
        leading: Icon(Icons.logout),
        title: Text("L O G O U T"),
        trailing: Icon(Icons.forward),
        onTap: () {},
      ),
      ListTile(
        leading: Icon(Icons.favorite),
        title: Text("R A T E   US"),
        trailing: Icon(Icons.forward),
        onTap: () {},
      ),
    ],
  ),
);
