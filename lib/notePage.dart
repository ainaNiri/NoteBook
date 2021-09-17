import 'package:animation/models/noteModel.dart';
import 'package:animation/noteDetailPage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
  var _tapPosition;
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

  void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
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
                  fillColor: darkMode ? Colors.white38 : Colors.white,
                  hintStyle: TextStyle( color: darkMode ? Colors.white70 :  Colors.black38),
                  prefixIcon: Icon(Icons.search, color: darkMode ? Colors.white60 : Colors.black45,),
                  hintText: "Search...",
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide( color: darkMode ? Colors.white38 :  Colors.grey.shade400, width: 1)
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide( color: darkMode ? Colors.white38 :  Colors.grey.shade400, width: 1)
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
      icon: Icon(Icons.menu, color: color1),
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
                      color3 = Colors.white;
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
          if (_selection == WhyFarther.grille) return GridView.builder(
            shrinkWrap: true,
            itemCount: notes.length,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: MediaQuery.of(context).orientation == Orientation.landscape ? 3 : 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 13,
              //childAspectRatio: (2/1)
            ),
            itemBuilder: (context, index){
              return GestureDetector(
                onLongPress: (){
                  final RenderBox overlay = Overlay.of(context)!.context.findRenderObject() as RenderBox;
                  showMenu(
                    color: darkMode ? Colors.grey : Colors.white,
                    context: context,
                    position: RelativeRect.fromRect(
                      _tapPosition & const Size(40, 40), // smaller rect, the touch area
                      Offset.zero & overlay.size   // Bigger rect, the entire screen
                    ),
                    items: <PopupMenuEntry<WhyFarther>>[
                      PopupMenuItem<WhyFarther>(
                        value: WhyFarther.liste,
                        child: ListTile(
                          onTap: ()async{
                            await db.deleteNote(notes[index].id ?? 0);
                            setState((){});
                          },
                          title: Text('Delete', style: TextStyle(color: color2))
                        ),               
                      ),
                      PopupMenuItem<WhyFarther>(
                        value: WhyFarther.grille,
                        child: ListTile(
                          onTap: ()async{
                            await Navigator.push(context,MaterialPageRoute(builder : (context){return NoteDetailPage(database: db, update: true, index: index);}));
                            setState((){});
                          },
                          title: Text('Edit', style: TextStyle(color: color2))
                        ),   
                      ),                       
                    ],
                  );
                },
                onTapDown: _storePosition,
                onTap: () async{
                    await Navigator.push(context,MaterialPageRoute(builder : (context){return NoteDetailPage(database: db, update: true, index: index);}));
                    setState(() {

                    });
                },
                child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                color: darkMode ? Colors.white24 : Colors.grey.shade100,
                child: Container(
                  constraints: BoxConstraints(maxWidth: 200, maxHeight: 150),
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: <Widget>[
                      Text(notes[index].title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color2)),
                      SizedBox(height: 5,),
                      Expanded(child: Text(notes[index].content,overflow: TextOverflow.fade, style: TextStyle(fontSize: 16, color: color2))),
                      SizedBox(height: 5,),
                      Text(DateFormat.yMMMEd().format(notes[index].date), style: TextStyle(fontSize: 12, color: color2, fontWeight: FontWeight.w300))
                    ]
                  ),
                )
                  )
              );
            },
          );
          else return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: notes.length,
            itemBuilder: (context, index){
              return GestureDetector(
                 onLongPress: (){
                  final RenderBox overlay = Overlay.of(context)!.context.findRenderObject() as RenderBox;
                  showMenu(
                    color:  darkMode ? Colors.grey : Colors.white,
                    context: context,
                    position: RelativeRect.fromRect(
                      _tapPosition & const Size(40, 40), // smaller rect, the touch area
                      Offset.zero & overlay.size   // Bigger rect, the entire screen
                    ),
                    items: <PopupMenuEntry<WhyFarther>>[
                      PopupMenuItem<WhyFarther>(
                        value: WhyFarther.liste,
                        child: ListTile(
                          onTap: ()async{
                            await db.deleteNote(notes[index].id ?? 0);
                            setState((){});
                          },
                          title: Text('Delete', style: TextStyle(color: color2))
                        ),               
                      ),
                      PopupMenuItem<WhyFarther>(
                        value: WhyFarther.grille,
                        child: ListTile(
                          onTap: ()async{
                            await Navigator.push(context,MaterialPageRoute(builder : (context){return NoteDetailPage(database: db, update: true, index: index);}));
                            setState((){});
                          },
                          title: Text('Edit', style: TextStyle(color: color2))
                        ),   
                      ),            
                    ],
                  );
                },
                onTapDown: _storePosition,
                onTap: () async{
                    await Navigator.push(context,MaterialPageRoute(builder : (context){return NoteDetailPage(database: db, update: true, index: index);}));
                    setState(() {

                    });
                },
                child: Card(
                elevation: 0,
                margin: EdgeInsets.only(bottom: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                color: color3,
                child: Container(
                  constraints: BoxConstraints(maxWidth: 150, maxHeight: 110),
                  padding: EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(notes[index].title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color2)),
                      SizedBox(height: 5,),
                      Expanded(child: Text(notes[index].content,overflow: TextOverflow.fade, style: TextStyle(fontSize: 16, color: color2))),
                      SizedBox(height: 5,),
                      Align(alignment: Alignment.bottomRight,
                        child: Text(DateFormat.yMMMEd().format(notes[index].date), style: TextStyle(fontSize: 12, color: color2, fontWeight: FontWeight.w300))
                      )
                    ]
                  ),
                )
                  )
              );
            },
          );
        }
        return Center();
      }
    );
  }
}