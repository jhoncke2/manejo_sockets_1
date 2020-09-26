import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:manejo_sockets_1/models/civilizacion.dart';
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Civilization names',
          style: TextStyle(
            color: Colors.black87
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 2,
      ),
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) => _crearCivilizationTile(civilizaciones[index]),
        itemCount: civilizaciones.length,        
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
            'Delete band',
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
          print('civilización: ${civilizacion.name}');
        },
      ),
      onDismissed: (DismissDirection direction){
        civilizaciones.remove(civilizacion);
        setState(() {
          
        });
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
      this.civilizaciones.add(
        Civilizacion(
          id: this.civilizaciones.length.toString(),
          name: civilizationName,
          votes: 0
        )
      );
      setState(() {
        
      });
      Navigator.pop(context);
    }
  }
}