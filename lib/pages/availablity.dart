import 'package:flutter/material.dart';
import '../model/pg.dart';
import '../model/floor.dart';
import '../util/dbhelper.dart';
import '../model/room.dart';
import 'dart:async';
import 'bookroom.dart';

class Availability extends StatefulWidget {
  PG pg;

  Availability(this.pg);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AvailabilityState();
  }
}

class _AvailabilityState extends State<Availability> {
  final _formKey = GlobalKey<FormState>();

  final priceController = TextEditingController();
  final bedController = TextEditingController();

  Future<List<Floor>> fetchFloors() async {
    var dbHelper = DBHelper();
    return await dbHelper.getFloor(widget.pg.id);
  }
  Future<List<Room>> fetchRooms(String floorID) async{
    var dbHelper=DBHelper();
    return await dbHelper.getRoom(widget.pg.id, floorID);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.pg.name}'),
      ),
      body: Column(
        children: <Widget>[
          Text('Floors'),
          FutureBuilder<List<Floor>>(
            future: fetchFloors(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return ExpansionTile(
                      title: Text('Floor ${index+1}'),
                      children: <Widget>[
                        
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: FutureBuilder<List<Room>>(
                            future: fetchRooms('${snapshot.data[index].id}'),
                            builder: (context,snapshot){
                              if(snapshot.hasData){
                                return ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (context,index){
                                    List<Widget> boxes=[];
                                    Room room = snapshot.data[index];
                                    for(int i=0;i<room.bedCount;i++){
                                      boxes.add(Padding(padding: EdgeInsets.all(5.0),
                                      child: GestureDetector(
                                        child: Container(
                                        width: 20.0,
                                        height: 20.0,
                                        color: room.bedStatus[i] == '0' ? Colors.greenAccent:Colors.red,
                                      ),
                                      onTap: (){
                                        if(room.bedStatus[i] == '0'){
                                          Navigator.push(context, MaterialPageRoute(
                                            builder: (context)=>BookRoom(room,i)
                                          ));
                                        }
                                      },
                                      ),));
                                    }
                                    return Column(
                                      children: <Widget>[
                                        Text('Room ${index+1}'),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children:boxes,
                                        )
                                      ],
                                    );
                                  },
                                );
                              }else {
                                return Text('No Rooms Added');
                              }
                            },
                          ),
                        )
                      ],
                    );
                  },
                );
              } else {
                return CircularProgressIndicator();
              }
            },
          )
        ],
      ),
    );
  }
}


// RaisedButton(
//                           child: Text('Add Room'),
//                           color: Colors.redAccent,
//                           onPressed: () {
//                             showDialog(
//                                 context: context,
//                                 builder: (_) {
//                                   return AlertDialog(
//                                     title: Text('Add PG'),
//                                     content: Form(
//                                       key: _formKey,
//                                       child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: <Widget>[
//                                           TextFormField(
//                                             controller: priceController,
//                                             validator: (value) {
//                                               if (value.isEmpty) {
//                                                 return 'Please enter each bed price';
//                                               }
//                                             },
//                                             decoration: InputDecoration(
//                                                 labelText: 'Room Price'),
//                                           ),
//                                           TextFormField(
//                                             controller: bedController,
//                                             validator: (value) {
//                                               if (value.isEmpty) {
//                                                 return 'Please enter bed count';
//                                               }
//                                             },
//                                             decoration: InputDecoration(
//                                                 labelText: 'Bed Count'),
//                                           ),
//                                           Padding(
//                                             padding: const EdgeInsets.symmetric(
//                                                 vertical: 16.0),
//                                             child: RaisedButton(
//                                               onPressed: () {
//                                                 // Validate will return true if the form is valid, or false if
//                                                 // the form is invalid.
//                                                 if (_formKey.currentState
//                                                     .validate()) {
//                                                   // If the form is valid, we want to show a Snackbar

//                                                   var dbHelper = DBHelper();
//                                                   dbHelper.saveRoom(
//                                                       widget.pg.id,
//                                                       snapshot.data[index].id,
//                                                       priceController.text,
//                                                       bedController.text);
//                                                   Navigator.pop(context);
//                                                 }
//                                               },
//                                               child: Text('Add PG'),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   );
//                                 });
//                           },
//                         ),