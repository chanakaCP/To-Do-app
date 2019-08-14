import 'package:flutter/material.dart';

class NoteDetail extends StatefulWidget{
  String appBaarTitle;
  NoteDetail(this.appBaarTitle);

  @override
  State<StatefulWidget> createState() {  
    return NoteDetailState(this.appBaarTitle);
  }
}

class NoteDetailState extends State<StatefulWidget>{
  static var _priorities = ['low','medium','high'];
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String appBaarTitle;
  NoteDetailState(this.appBaarTitle);

  @override
  Widget build(BuildContext context) {
    
    TextStyle textStyle = Theme.of(context).textTheme.title;

    return Scaffold(
      appBar: AppBar(
        title: Text(appBaarTitle),
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
                value: 'Low',

                onChanged: (selectedValue) {
                  setState(() {
                   debugPrint('User Selected $selectedValue'); 
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
    );
  }
}