import 'package:flutter/material.dart';
import 'package:manejo_sockets_1/pages/home_page.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      initialRoute: 'home',
      routes: {
        'home':(BuildContext context)=>HomePage()
      },
    );
  }
}