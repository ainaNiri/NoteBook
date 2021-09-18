import 'package:animation/models/noteModel.dart';
import 'package:animation/noteDetailPage.dart';
import 'package:animation/utils/constants.dart';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GridNote extends StatefulWidget {
  Db database;
  GridNote({ Key? key, required this.database }) : super(key: key);

  @override
  _GridState createState() => _GridState();
}

class _GridState extends State<GridNote> {

  var _tapPosition;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.only(left: 10, right: 10),
      shrinkWrap: true,
      itemCount: notes.length,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: MediaQuery.of(context).orientation == Orientation.landscape ? 3 : 2,
        crossAxisSpacing: 25,
        mainAxisSpacing: 13,
        //childAspectRatio: (2/1)
      ),
      itemBuilder: (context, index){
        return OpenContainer(
          closedBuilder: (_, openContainer){
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
                color: darkMode ? Colors.white12 : Colors.grey.shade100,
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
              ),
            );
          },
          closedColor: darkMode ? Colors.white12 : Colors.grey.shade100,
          openElevation: 0.0,
          closedElevation: 0.0,
          transitionDuration: Duration(milliseconds: 400),
          closedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          openBuilder:(context, closeContainer) {
            return NoteDetailPage(
              database: widget.database, 
              update: true, 
              index: index
            );
          }
        );
      },
    );
  }
}