import 'package:flutter/material.dart';
import 'package:to_do_app/screen/note_details.dart';
import 'dart:async';
import 'package:to_do_app/model/note.dart';
import 'package:to_do_app/utils/databse_helper.dart';
import 'package:sqflite/sqflite.dart';

class NoteList extends StatefulWidget{
  
  @override
  State<StatefulWidget> createState() {
 
    return NoteListState();
  }
}

class NoteListState extends State<NoteList> {
  
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Note> noteList;
  int count = 0;

  @override
  Widget build(BuildContext context) {

    if(noteList == null){
      noteList = List<Note>();
      updateListView();
    }

    return Scaffold(  
      appBar: AppBar(
        title: Text('WhatNext'),
      ),
      body: getNoteListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          debugPrint(" Add new clicked");
          navigatToDetail(Note('','', 3),'Add Note');
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
              backgroundColor: getPriorityColor(this.noteList[position].priority),
              child: getPriorityIcon(this.noteList[position].priority),
            ),
            title: Text( this.noteList[position].title, style: titleStyle ),
            subtitle: Text( this.noteList[position].date ),
            trailing: GestureDetector(
              child: Icon( Icons.delete, color: Colors.grey ),
              onTap: (){
                _delete(contex, noteList[position]);
              },
            ),
              
            onTap: (){
              debugPrint("Listitem tapped");
              navigatToDetail(this.noteList[position], 'Edit Note');
            },
          ),
        );
      },
    );
  }

  void navigatToDetail(Note note, noteTitle) async{
    bool result = await Navigator.push(context, MaterialPageRoute(builder: (context){
      return NoteDetail(note, noteTitle);
    }));
    if(result == true){
      updateListView();
    }
  }

// return priority icon
  Icon getPriorityIcon(int priority){
    switch (priority){
      case 1: 
        return Icon(Icons.arrow_forward_ios);
        break;
      case 2: 
        return Icon(Icons.arrow_forward_ios);
        break;
      case 3: 
        return Icon(Icons.arrow_forward_ios);
        break;
    }
  }

// return priority color
  Color getPriorityColor(int priority){
    switch (priority){
      case 1: 
        return Colors.grey[800];
        break;
      case 2: 
        return Colors.grey[600];
        break;
      case 3: 
        return Colors.grey[400];
        break;
    }
  }


  void _delete(BuildContext contex, Note note) async{
    int result = await databaseHelper.deleteDate(note.id);
    if(result != 0){
      _showSnackBar(contex, 'Note deleted successfully...');
      updateListView();
    }
  }

  void _showSnackBar(BuildContext contex, String massage) {
    final snackBar = SnackBar(content: Text(massage));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void updateListView(){
    final Future<Database> dbFuture = databaseHelper.initDb();
    dbFuture.then((database){
      Future<List<Note>> noteListFuture = databaseHelper.getNoteList();
      noteListFuture.then((noteList){
        setState(() {
         this.noteList = noteList;
         this.count = noteList.length; 
        });
      });
    });
  }
} 