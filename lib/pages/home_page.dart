import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:manejo_sockets_1/models/civilizacion.dart';
import 'package:manejo_sockets_1/services/socket_service.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';
class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Civilizacion> civilizaciones = [
    Civilizacion(
      id: '1',
      name: 'mongoles',
      votes: 1
    ),
    Civilizacion(
      id: '2',
      name: 'sarracenos',
      votes: 1
    ),
    Civilizacion(
      id: '3',
      name: 'japoneses',
      votes: 1
    ),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //con el listen: false, me permite usar el context antes de que haya terminado el initState
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.on('civilizaciones_activas', _handleActiveCivilizations);
  }

  void _handleActiveCivilizations(dynamic data){
    print('data from civilizaciones activas: ${data.toString()}');
    try{
      civilizaciones = (data as List).cast<Map<String, dynamic>>().map((Map<String, dynamic> civilization){
        print('actual civilization: ${civilization.toString()}');
        return Civilizacion.fromMap(civilization);
      }).toList();
      setState(() {
        
      });
    }catch(err){
      print('ha ocurrido un error:\n${err.toString()}');
    }
  }
  @override
  Widget build(BuildContext context) {
    SocketService socketService = Provider.of<SocketService>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Civilization names',
          style: TextStyle(
            color: Colors.black87
          ),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: ((socketService.serverStatus == ServerStatus.ONLINE)? 
              Icon(
                Icons.check_circle,
                color: Colors.blue[300],
              )
              :Icon(
                Icons.offline_bolt,
                color: Colors.deepOrangeAccent,
              )
              
            ),
            
          )
        ],
        backgroundColor: Colors.white,
        elevation: 2,
      ),
      body: Column(
        children: [
          _showGraph(),
          //Expanded: lo hace tomar todo el espacio disponible en base a la columna.
          Expanded(
            child: ListView.builder(
              itemBuilder: (BuildContext context, int index) => _crearCivilizationTile(civilizaciones[index]),
              itemCount: civilizaciones.length,        
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 2,
        child: Icon(
          Icons.add
        ),
        onPressed: (){
          _addNewCivilization();
        },
      ),
    );
  }

  Widget _showGraph(){
    Map<String, double> dataMap = {};
    civilizaciones.forEach((Civilizacion civilizacion) {
      dataMap[civilizacion.name] = civilizacion.votes.toDouble();
    });
    List<Color> colorList = [
      Colors.blue[300],
      Colors.red[200],
      Colors.green[300],
      Colors.pink[300],
      Colors.blue[100],
      Colors.red[100],
      Colors.green[100],
      Colors.pink[100]
    ];
    return Container(
      height: 400,
      width: 400,
      child: PieChart(
        dataMap: dataMap,
        animationDuration: Duration(milliseconds: 800),
        chartRadius: MediaQuery.of(context).size.width / 2,
        colorList: colorList,
        initialAngleInDegree: 0,
        chartType: ChartType.disc,
        ringStrokeWidth: 32,
        legendOptions: LegendOptions(
          showLegendsInRow: false,
          legendPosition: LegendPosition.right,
          showLegends: true,
          legendShape: BoxShape.circle,
          legendTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        chartValuesOptions: ChartValuesOptions(
          showChartValueBackground: true,
          showChartValues: true,
          showChartValuesInPercentage: false,
          showChartValuesOutside: false,
        ),
      )
    );
  }

  Widget _crearCivilizationTile(Civilizacion civilizacion) {
    return Dismissible(
      key: Key( civilizacion.id ),
      direction: DismissDirection.startToEnd,
      background: Container(
        padding: EdgeInsets.only(left: 8),
        color: Colors.redAccent,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Delete Civilization',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9)
            ),
          )
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(
            civilizacion.name.substring(0,2)
          ),
         backgroundColor: Colors.blue[100],
        ),
        title: Text(civilizacion.name),
        trailing: Text(
          '${civilizacion.votes}',
          style: TextStyle(
            fontSize: 20
          ),
        ),
        onTap: (){
          print('civilización: ${civilizacion.id}');
          final socketService = Provider.of<SocketService>(context, listen: false);
          socketService.socket.emit('vote_civilization', {'id':civilizacion.id});
        },
      ),
      onDismissed: (DismissDirection direction){
        final socketService = Provider.of<SocketService>(context, listen: false);
        socketService.socket.emit('remove_civilization', {'id':civilizacion.id});
      },
    );
  }

  void _addNewCivilization(){
    final textFieldController = TextEditingController();
      
    if(Platform.isAndroid){
      showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text(
              'new civilization name'
            ),
            content: TextField(
              controller: textFieldController,
            ),
            actions: [
              MaterialButton(
                child: Text('Add', style: TextStyle(fontSize: 17),),
                textColor: Colors.blue,
                elevation: 5,
                onPressed: () => _addCivilizationToList(textFieldController.text),
              )
            ],
          );
        }
      );
    }else if(Platform.isIOS){
      showCupertinoDialog(
        context: context, 
        builder: (_){
          return CupertinoAlertDialog(
            title: Text('New civilizatoin name'),
            content: CupertinoTextField(
              controller: textFieldController,
            ),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text('Add'),
                onPressed: () => _addCivilizationToList(textFieldController.text),
              ),
              CupertinoDialogAction(
                isDestructiveAction: true,
                child: Text('Dismiss'),
                onPressed: (){
                  Navigator.pop(context);
                },
              )
            ],
          );
        }
      );
    } 
  }

  void _addCivilizationToList(String civilizationName){
    if(civilizationName.length >= 1){
      final socketService = Provider.of<SocketService>(context, listen: false);
      socketService.socket.emit('add_civilization', {'name':civilizationName});
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    final socketService = Provider.of<SocketService>(context);
    socketService.socket.off('civilizaciones_activas');
    super.dispose();  
  }
}