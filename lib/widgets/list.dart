import 'package:animation/models/noteModel.dart';
import 'package:animation/utils/constants.dart';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../noteDetailPage.dart';

class ListNote extends StatefulWidget {
  Db database;
  ListNote({ Key? key, required this.database }) : super(key: key);

  @override
  _ListState createState() => _ListState();
}

class _ListState extends State<ListNote> {

  var _tapPosition;

  void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
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
                      await widget.database.deleteNote(notes[index].id ?? 0);
                      setState((){});
                    },
                    title: Text('Delete', style: TextStyle(color: color2))
                  ),               
                ),
                PopupMenuItem<WhyFarther>(
                  value: WhyFarther.grille,
                  child: ListTile(
                    onTap: ()async{
                      await Navigator.push(context,MaterialPageRoute(builder : (context){return NoteDetailPage(database: widget.database, update: true, index: index);}));
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
              await Navigator.push(context,MaterialPageRoute(builder : (context){return NoteDetailPage(database: widget.database, update: true, index: index);}));
              setState(() {

              });
          },
          child: Container(
            margin: EdgeInsets.only(bottom: 15),
            child: OpenContainer(
              closedBuilder:(_, openContainer) {
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
                              await widget.database.deleteNote(notes[index].id ?? 0);
                              setState((){});
                            },
                            title: Text('Delete', style: TextStyle(color: color2))
                          ),               
                        ),
                        PopupMenuItem<WhyFarther>(
                          value: WhyFarther.grille,
                          child: ListTile(
                            onTap: ()async{
                              await Navigator.push(context,MaterialPageRoute(builder : (context){return NoteDetailPage(database: widget.database, update: true, index: index);}));
                              setState((){});
                            },
                            title: Text('Edit', style: TextStyle(color: color2))
                          ),   
                        ),            
                      ],
                    );
                  },
                  onTap: openContainer,
                  child: Card(
                    elevation: 0,
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(Icons.calendar_today, size: 17, color: Colors.grey.shade700),
                              SizedBox(width: 10,),
                              Text(DateFormat.yMMMEd().format(notes[index].date), style: TextStyle(fontSize: 12, color: color2, fontWeight: FontWeight.w300)),
                            ],
                          )
                        ]
                      ),
                    )
                  ),
                );
              },
              openElevation: 0.0,
              closedElevation: 0.0,
              closedColor: darkMode ? Colors.white12 : Colors.grey.shade100,
              closedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              transitionDuration: Duration(milliseconds: 400),
              openBuilder:(_, closeBuilder) {
                return NoteDetailPage(
                  database: widget.database, 
                  update: true, 
                  index: index
                );
              }
            ),
          )
        );
      },
    );
  }
}