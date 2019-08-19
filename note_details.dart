import 'package:flutter/material.dart';
import 'package:to_do_app/screen/note_list.dart';
import 'dart:async';
import 'package:to_do_app/model/note.dart';
import 'package:to_do_app/utils/databse_helper.dart';
import 'package:intl/intl.dart';

class NoteDetail extends StatefulWidget{
  final String appBaarTitle;
  final Note note;
  NoteDetail(this.note ,this.appBaarTitle);

  @override
  State<StatefulWidget> createState() {  
    return NoteDetailState(this.note, this.appBaarTitle);
  }
}

class NoteDetailState extends State<StatefulWidget>{
  static var _priorities = ['low','medium','high'];
  DatabaseHelper helper = DatabaseHelper(); 
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String appBaarTitle;
  Note note;

  NoteDetailState(this.note, this.appBaarTitle);

  @override
  Widget build(BuildContext context) {
    
    TextStyle textStyle = Theme.of(context).textTheme.title;
    titleController.text = note.title;
    descriptionController.text = note.description;

    return WillPopScope( 
      onWillPop: () {
        moveToLastScreen();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(appBaarTitle),
          leading: IconButton(icon: Icon(
            Icons.arrow_left),
            onPressed: () {
              moveToLastScreen();
            },
          ),
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
          child: ListView(
            children: <Widget>[
              ListTile(
                title: DropdownButton(
                  items: _priorities.map((String dropdownStringItem){
                    return DropdownMenuItem<String>(
                      value: dropdownStringItem,
                      child: Text(dropdownStringItem)
                    );
                  }).toList(), 

                  style: textStyle,
                  value: updatePriorityToString(note.priority),

                  onChanged: (selectedValue) {
                    setState(() {
                    debugPrint('User Selected $selectedValue');
                    updatePriorityToInt(selectedValue); 
                    });
                  },
                ),
              ),

              // second element
              Padding(
                padding: EdgeInsets.only(top: 20.0, bottom: 15.0, left: 20.0, right: 20.0),
                child: TextField(
                  controller: titleController,
                  style: textStyle,
                  onChanged: (value){
                    debugPrint('text entrer in title');
                    updateTitle();
                  },
                  decoration: InputDecoration(
                    labelText: 'title',
                    labelStyle: TextStyle(fontWeight: FontWeight.w400),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)
                    ),
                  ),
                ),
              ),

              // third element
              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 20.0, left: 20.0, right: 20.0),
                child: TextField(
                  controller: descriptionController,
                  style: textStyle,
                  onChanged: (value){
                    debugPrint('text entrer in dsecription');
                    updateDescription();
                  },
                  decoration: InputDecoration(
                    labelText: 'description',
                    labelStyle: TextStyle(fontWeight: FontWeight.w400),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)
                    ),
                  ),
                ),
              ),

              // fourth element
              Padding(
                padding: EdgeInsets.only(top: 20.0,bottom: 15.0, left:20.0, right: 20.0 ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: SizedBox(
                        height: 40.0,
                        child: RaisedButton(
                          color: Theme.of(context).primaryColorDark,
                          textColor: Theme.of(context).primaryColorLight,
                          shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
                          child: Text(
                            'Save',
                            textScaleFactor: 1.5,
                          ),
                          onPressed: () {
                            setState(() {
                            debugPrint('save button clicked'); 
                            _save();
                            });
                          },
                        ),
                      ),  
                    ),
                    
                    Container(width: 20.0,),

                    Expanded(
                      child: SizedBox(
                        height: 40.0,
                        child: RaisedButton(
                          color: Theme.of(context).primaryColorDark,
                          textColor: Theme.of(context).primaryColorLight,
                          shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
                          child: Text(
                            'Delete',
                            textScaleFactor: 1.5
                          ),
                          onPressed: () {
                            setState(() {
                            debugPrint('delete button clicked'); 
                            _delete();
                            });
                          },
                        ),
                      ),  
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      )
    );
  }

  void updatePriorityToInt(String priority){
    switch (priority) {
      case 'high':
        note.priority = 1;
        break;
      case 'medium':
        note.priority = 2;
        break;
      case 'low':
        note.priority = 3;
        break;
    }
  }

  String updatePriorityToString(int priority){
    String priorityText;
    switch (priority) {
      case 1:
        priorityText = _priorities[2] ;
        break;
      case 2:
        priorityText = _priorities[1] ;
        break;
      case 3:
        priorityText = _priorities[0] ;
        break;    
    }
    return priorityText;
  }
  
  void updateTitle(){
    note.title = titleController.text;
  }
   void updateDescription(){
     note.description = descriptionController.text;
  }

//  save data to database
  void _save() async{
    
    moveToLastScreen();
    note.date = DateFormat.yMMMd().format(DateTime.now());  
    int result;

    if(note.id != null){ // update 
      result =  await helper.updateData(note);
    }else{ // insert
      result = await helper.insertData(note);
    }

    if(result != 0){ //success
      _showAlert('Status','Note saved successfully');
    }else{  // failure
      _showAlert('Status','Problem saving dialog');
    }
  } 

  void _delete() async{
    moveToLastScreen();

    if(note.id == null){ // delete new note
      _showAlert('Status','No note wal deleted');
      return;
    } 
//  delete old note
    int result = await helper.deleteNode(note.id);
    
    if(result != 0){
      _showAlert('Statu','Note delete successfully');
    }else{
      _showAlert('Status','Error occured while deleting node');
    }
  }

  void _showAlert(String title, String msg){
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(msg),
    );
    showDialog(
      context: context,
      builder: (_) => alertDialog,
    );
  }

  void moveToLastScreen(){
    Navigator.pop(context, true);
  }

}