import 'package:animation/models/noteModel.dart';
import 'package:animation/noteDetailPage.dart';
import 'package:animation/widgets/grid.dart';
import 'package:animation/widgets/list.dart';
import 'package:flutter/material.dart';

enum WhyFarther { liste, grille, selfStarter}


class NotePage extends StatefulWidget {
  const NotePage({ Key? key }) : super(key: key);

  @override
  _NotePageState createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  Db db = new Db() ;
  Color color1 = Colors.white;
  Color color2 = Colors.black;
  Color color3 = Colors.grey.shade100;
  bool list = false;
  bool darkMode = false;
  WhyFarther _selection = WhyFarther.grille;

  String _searchText = "";
  List <dynamic> filteredNotes = [];
  TextEditingController _filter = TextEditingController();

  _function() {
    if (_filter.text.isEmpty) {
      setState(() {
        _searchText = "";
      });
    } else {
      setState(() {
        _searchText = _filter.text;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _filter.addListener(() { _function();});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color1,
      appBar: AppBar(
        elevation: 2,
        title: Text("Note", style: TextStyle(color: darkMode ? Colors.white70 : Colors.black87, fontSize: 30, fontWeight: FontWeight.bold)),
        leading: Icon(Icons.menu, color: darkMode ? Colors.white70 :Colors.black87,),
        centerTitle: true,
        actions: [
          // This is the type used by the popup menu below.
          // This menu button widget updates a _selection field (of type WhyFarther,
          // not shown here).
          buildPopMenu()
        ],
        backgroundColor: color1,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15),
          margin : EdgeInsets.only(top: 15),
          child: Column(
            children: <Widget>[
              TextField(
                controller: _filter,
                style: TextStyle(color: color2),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: darkMode ? Colors.white30 : Colors.grey[100],
                  hintStyle: TextStyle( color: darkMode ? Colors.white70 :  Colors.black38),
                  prefixIcon: Icon(Icons.search, color: darkMode ? Colors.white60 : Colors.black45,),
                  hintText: "Search...",
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide( color: darkMode ? Colors.white30 :  Colors.grey.shade100, width: 1)
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide( color: darkMode ? Colors.white30 :  Colors.grey.shade100, width: 1)
                  )
                ),
              ),
              SizedBox(height: 25,),
              buildList()
            ],
          )
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          await Navigator.push(context,MaterialPageRoute(builder : (context){return NoteDetailPage(database: db, update: false);}));
          setState(() {

           });
        },
        backgroundColor: Colors.yellow[600],
        child: Icon(Icons.add),
        elevation: 0,
      ),
    );
  }
  Widget buildPopMenu(){
    return PopupMenuButton<WhyFarther>(
      icon: Icon(Icons.more_vert, color: color2),
      color : darkMode ? Colors.black38 : Colors.white,
      onSelected: (WhyFarther result) {setState((){_selection = result;});},
      itemBuilder: (BuildContext context) => <PopupMenuEntry<WhyFarther>>[
        PopupMenuItem<WhyFarther>(
          value: WhyFarther.liste,
          child: Text('Trier par liste',style: TextStyle(color: color2)),               
        ),
        PopupMenuItem<WhyFarther>(
          value: WhyFarther.grille,
          child: Text('Trier par grille',style: TextStyle(color: color2)),
        ),
        PopupMenuItem<WhyFarther>(
          value: WhyFarther.selfStarter,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text("Dark", style: TextStyle(color: color2)),
              SizedBox(width: 35),
              Switch(
                onChanged: (bool value){
                  setState((){
                    this.darkMode = value;
                    if(darkMode){
                      color1 = Colors.black87;
                      color2 = Colors.white;
                      color3 = Colors.white12;
                    }
                    else{
                      color1 = Colors.white;
                      color2 = Colors.black;
                      color3 = Colors.grey.shade100;
                    }
                    });
                },                 
                value: this.darkMode,
                activeColor: Colors.blue,
              )
            ]
          ),
        ),             
      ],
    );
  }

  Widget buildList(){    
    return FutureBuilder(
      future: db.getNotes(),
      builder: (BuildContext context, AsyncSnapshot<List<Note>> snapshot){
        if(snapshot.hasData){
          notes.clear();
          for(int i = 0; i< snapshot.data!.length; i++){
            if(_searchText.isNotEmpty)
            {
              if(snapshot.data![i].title.toLowerCase().contains(_searchText.toLowerCase()))
              {
                notes.add(snapshot.data![i]);
              }
            }
            else
              notes.add(snapshot.data![i]);
          }                
          if (_selection == WhyFarther.grille) 
            return GridNote(database: db);
          else 
            return ListNote(database: db);
        }
        return Center();
      }
    );
  }
}