import 'package:flutter/material.dart';
import 'package:manejo_sockets_1/pages/home_page.dart';
import 'package:manejo_sockets_1/pages/status_page.dart';
import 'package:manejo_sockets_1/services/socket_service.dart';
import 'package:provider/provider.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=>SocketService(),)
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        initialRoute: 'home',
        routes: {
          'home':(BuildContext context)=>HomePage(),
          'status':(BuildContext context)=>StatusPage()
        },
      ),
    );
  }
}