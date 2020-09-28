import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus{
  ONLINE,
  OFFLINE,
  CONNECTING
}
/**
 * change notifier me ayuda a decirle a provider cuándo tiene que redibujar widgets,
 * actualizar ui, etc
 */
class SocketService with ChangeNotifier{
  ServerStatus _serverStatus = ServerStatus.CONNECTING;
  ServerStatus get serverStatus => this._serverStatus;

  IO.Socket _socket;

  IO.Socket get socket => this._socket;

  SocketService(){
    _initConfig();
  }

  void _initConfig(){

    //IO.Socket socket = IO.io('http://localhost:3000', {
    this._socket = IO.io('http://192.168.0.12:3000', {
      "transports":["websocket"],
      "autoConnect":true
    });
    this._socket.on('connect', (_) {
     print('socket is connected now');
     this._serverStatus = ServerStatus.ONLINE;
    this. _socket.emit('mensaje', {
       "nombre":"Jhonatan Amórtegui",
       "edad":23
     });
     notifyListeners();
    });
    this._socket.on('disconnect', (_){
      print('disconnect');
      this._serverStatus = ServerStatus.OFFLINE;
      notifyListeners();
    });
    this._socket.on('mensaje', (data){
      print('ha llegado un nuevo mensaje del servidor: ${data}');
    });
  }


}