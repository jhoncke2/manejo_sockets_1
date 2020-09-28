import 'package:flutter/material.dart';
import 'package:manejo_sockets_1/services/socket_service.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class StatusPage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    IO.Socket socket = Provider.of<SocketService>(context).socket;
    Size size = MediaQuery.of(context).size;
    final _socketService = Provider.of<SocketService>(context);
    return Scaffold(
      body: Container(
        width: size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Server status: ${_socketService.serverStatus}'
            ),
            
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.radio_button_checked
        ),
        onPressed: (){
          socket.emit('mensaje_desde_flutter_status', {
            'name':'Turtle Turtler',
            'age':23,
            'lvl':78
          });
        },
      ),
    );
  }
}