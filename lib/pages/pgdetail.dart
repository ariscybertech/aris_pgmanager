import 'package:flutter/material.dart';
import '../model/pg.dart';
import '../model/floor.dart';
import '../util/dbhelper.dart';
import '../model/room.dart';
import 'dart:async';
import 'bookroom.dart';

class PGDetail extends StatefulWidget {
  PG pg;
  int mode;
  PGDetail(this.pg,this.mode);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _PGDetailState();
  }
}

class _PGDetailState extends State<PGDetail> {
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
        backgroundColor: Colors.greenAccent,
        title: Text('${widget.pg.name}',style: TextStyle(color: Colors.black),),
      ),
      body: Container(
        child: 
          FutureBuilder<List<Floor>>(
            future: fetchFloors(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return ExpansionTile(
                      title: Text('Floor ${index+1}',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                      children: <Widget>[
                        widget.mode == 0 ? Container(
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: EdgeInsets.only(left: 10.0,right: 10.0),
                            child: RaisedButton(
                          child: Text('Add Room',style: TextStyle(color: Colors.white),),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                          color: Colors.redAccent,
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (_) {
                                  return AlertDialog(
                                    contentPadding: EdgeInsets.all(10.0),
                                    title: Text('Add Room'),
                                    content: SingleChildScrollView(
                                      child: Form(
                                      key: _formKey,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          TextFormField(
                                            keyboardType: TextInputType.number,
                                            controller: priceController,
                                            validator: (value) {
                                              if (value.isEmpty) {
                                                return 'Please enter each bed price';
                                              }
                                            },
                                            decoration: InputDecoration(
                                                labelText: 'Room Price'),
                                          ),
                                          TextFormField(
                                            keyboardType: TextInputType.number,
                                            controller: bedController,
                                            validator: (value) {
                                              if (value.isEmpty) {
                                                return 'Please enter bed count';
                                              }
                                            },
                                            decoration: InputDecoration(
                                                labelText: 'Bed Count'),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10.0),
                                            child: Container(
                                              width: MediaQuery.of(context).size.width,
                                              child: RaisedButton(
                                                color: Colors.blueAccent,
                                              onPressed: () {
                                                // Validate will return true if the form is valid, or false if
                                                // the form is invalid.
                                                if (_formKey.currentState
                                                    .validate()) {
                                                  // If the form is valid, we want to show a Snackbar

                                                  var dbHelper = DBHelper();
                                                  dbHelper.saveRoom(
                                                      widget.pg.id,
                                                      snapshot.data[index].id,
                                                      priceController.text,
                                                      bedController.text);
                                                  Navigator.pop(context);
                                                }
                                              },
                                              child: Text('Add Room',style: TextStyle(color: Colors.white),),
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                                            ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    ),
                                  );
                                });
                          },
                        ),
                          ),
                        ):SizedBox(),
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
                                        if(room.bedStatus[i] == '0' && widget.mode == 1){
                                          Navigator.push(context, MaterialPageRoute(
                                            builder: (context)=>BookRoom(room,i)
                                          ));
                                        }
                                      },
                                      ),));
                                    }
                                    return Column(
                                      children: <Widget>[
                                        Text('Room ${index+1}',style: TextStyle(color: Colors.white),),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children:boxes,
                                        )
                                      ],
                                    );
                                  },
                                );
                              }else {
                                return SizedBox();
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
          ),
        
      decoration: BoxDecoration(
          gradient: LinearGradient(
            // Where the linear gradient begins and ends
            begin: Alignment.topCenter,                                  // new
            end: Alignment.bottomCenter,                                  // new
            // Add one stop for each color.
            // Stops should increase
            // from 0 to 1
            stops: [0.1, 0.6, 0.7, 0.9],
            colors: [
              // Colors are easy thanks to Flutter's
              // Colors class.
              Colors.greenAccent[400],
              Colors.indigo[600],
              Colors.indigo[700],
              Colors.indigo[800],
            ],
          )
        ),
      ),
    );
  }
}
