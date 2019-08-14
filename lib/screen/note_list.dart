import 'package:flutter/material.dart';
import 'package:to_do_app/screen/note_details.dart';


class NoteList extends StatefulWidget{
 
  @override
  State<StatefulWidget> createState() {
 
    return NoteListState();
  }
}

class NoteListState extends State<NoteList> {
  
  int count = 0;

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(  
      appBar: AppBar(
        title: Text('WhatNext'),
      ),
      body: getNoteListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          debugPrint(" 'Add new' clicked");
          navigatToDetail('Add Note');
        },
        tooltip: 'Add Note',
        child: Icon(Icons.add),
      ),
    );
  }

  ListView getNoteListView(){
    TextStyle titleStyle = Theme.of(context).textTheme.subhead;

    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext contex, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.lightGreen,
              child: Icon(Icons.arrow_back_ios),
            ),
            title: Text( 'test title', style: titleStyle),
            subtitle: Text( 'test subtitle'),
            trailing: Icon( Icons.delete, color: Colors.grey ),
            onTap: (){
              debugPrint("Listitem tapped");
              navigatToDetail('Edit Note');
            },
          ),
        );
      },
    );
  }

  void navigatToDetail(noteTitle){
    Navigator.push(context, MaterialPageRoute(builder: (context){
      return NoteDetail(noteTitle);
    }));
  }
} 