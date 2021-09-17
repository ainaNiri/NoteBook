// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'models/noteModel.dart';

class NoteDetailPage extends StatefulWidget {
  Db database;
  bool update;
  int? index;
  NoteDetailPage({ Key? key , this.index, required this.database, required this.update}) : super(key: key);

  @override
  _NoteDetailPageState createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  var _title = TextEditingController();
  var _content = TextEditingController();

  @override
  void initState(){
    super.initState();
    if(widget.update){
      _content.text = notes[widget.index!].content;
      _title.text = notes[widget.index!].title;
    } 
  }

  @override
  void dispose(){
    _title.dispose();
    _content.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(     
      body: Container(
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.only(top: 50),
        child :Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 15,),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(right: 13),
                  child: Icon(Icons.calendar_today, size: 17, color: Colors.grey.shade700)
                ),
                Text(
                  widget.update ? DateFormat.yMMMEd().format(notes[widget.index!].date) :  DateFormat.yMMMEd().format(DateTime.now()), 
                  style: TextStyle(color: Colors.grey)
                ),
              ],
            ),
            SizedBox(height: 10,),
            TextField(
              controller: _title,
              decoration: InputDecoration(
                labelText: "Title",
                labelStyle: TextStyle(color: Colors.grey)
              ),
            ),
            SizedBox(height: 20,),
            TextField(
              controller: _content,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: "content",
                labelStyle: TextStyle(color: Colors.grey)
              ),
            ),         
          ]
        )
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            late Note note;
            if(widget.update)
              note = Note(
                title : _title.text,
                content : _content.text,
                id : notes[widget.index!].id,
                date : DateTime.now()
              );
            else 
              note = Note(
                title : _title.text,
                content : _content.text,
                date : DateTime.now(),
              );
            if(widget.update)
              await widget.database.updateNote(notes[widget.index!].id ?? 0, note);
            else 
              await widget.database.insertNote(note);
            Navigator.pop(context, note);
          },
          backgroundColor: Colors.yellow[600],
          child: Icon( widget.update ? Icons.edit : Icons.add),
          elevation: 0,
        ),
    );
  }
}