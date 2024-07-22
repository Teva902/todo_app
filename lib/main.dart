import 'package:flutter/material.dart';
import 'package:todo_app/home/home_screen.dart';
import 'package:todo_app/my_theme_data.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: HomeScreen.routeName,
      routes: {
        HomeScreen.routeName: (context) => HomeScreen(),
      },
      theme: MyThemeData.lightTheme,
    );
  }
}
