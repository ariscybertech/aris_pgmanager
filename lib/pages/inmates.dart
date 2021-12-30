import 'package:flutter/material.dart';
import 'dart:async';
import '../util/dbhelper.dart';
import '../model/inmate.dart';
import 'package:intl/intl.dart';

class InmatesPage extends StatefulWidget {
  @override
    State<StatefulWidget> createState() {
      // TODO: implement createState
      return _InmatesPageState();
    }
}

class _InmatesPageState extends State<InmatesPage> {

  List<Inmate> inmates=[];
  List<Inmate> filterInmates = [];
  String searchText = "";

  Future<List<Inmate>> fetchBookings(){
    var dbHelper = DBHelper();
    return dbHelper.getInmates();
  }

  @override
    Widget build(BuildContext context) {
      // TODO: implement build
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.greenAccent,
          title: Text('Inmates',style: TextStyle(color: Colors.black))
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10.0),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Seach Booking'
                  ),
                  onChanged: (query){
                    filterInmates.clear();
                    inmates.forEach((booking){
                      if(booking.name.toLowerCase().contains(query.toLowerCase())){
                        filterInmates.add(booking);
                      }
                    });
                    setState(() {
                         searchText = query;                 
                    });
                  },
                ),
              )
              ,
              Expanded(
                child: searchText != "" ? 
                
                ListView.builder(
                itemCount: filterInmates.length,
                itemBuilder: (context,index){
                  return Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Card(
                      child:Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('${filterInmates[index].name}',style: TextStyle(
                        fontSize: 16.0,fontWeight: FontWeight.bold
                      ),),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 5.0),
                        child: Text('+91${filterInmates[index].phone}',style: TextStyle(
                          fontStyle: FontStyle.italic,color: Colors.grey
                        ),),
                      ),
                      Row(
                        children: <Widget>[
                          Text('Floor:',style: TextStyle(fontSize: 16.0),),
                          Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Text('${filterInmates[index].floorid}',style: TextStyle(
                              fontSize: 16.0,fontWeight: FontWeight.bold
                            ),),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Text('Room:',style: TextStyle(
                              fontSize: 16.0
                            ),),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Text('${filterInmates[index].roomid}',style: TextStyle(
                              fontSize: 16.0,fontWeight: FontWeight.bold
                            ),),
                          ),
                          
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
                        child: Row(
                        children: <Widget>[
                          Text('Check-In:',style: TextStyle(fontSize: 16.0),),
                          Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Text('${DateFormat("dd/MM/yyyy").format(DateTime.fromMillisecondsSinceEpoch(filterInmates[index].checkinDate))}',
                          style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold),),
                          )
                        ],
                      ),
                      )
                    ],
                  ),
                    ),)
                  );
                },
              )
                
                :FutureBuilder<List<Inmate>>(
          future: fetchBookings(),
          builder: (context,snapshot){
            if(snapshot.hasData){
              inmates = snapshot.data;
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context,index){
                  return Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Card(
                      child:Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('${snapshot.data[index].name}',style: TextStyle(
                        fontSize: 16.0,fontWeight: FontWeight.bold
                      ),),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 5.0),
                        child: Text('+91${snapshot.data[index].phone}',style: TextStyle(
                          fontStyle: FontStyle.italic,color: Colors.grey
                        ),),
                      ),
                      Row(
                        children: <Widget>[
                          Text('Floor:',style: TextStyle(fontSize: 16.0),),
                          Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Text('${snapshot.data[index].floorid}',style: TextStyle(
                              fontSize: 16.0,fontWeight: FontWeight.bold
                            ),),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Text('Room:',style: TextStyle(
                              fontSize: 16.0
                            ),),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Text('${snapshot.data[index].roomid}',style: TextStyle(
                              fontSize: 16.0,fontWeight: FontWeight.bold
                            ),),
                          ),
                          
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
                        child: Row(
                        children: <Widget>[
                          Text('Check-In:',style: TextStyle(fontSize: 16.0),),
                          Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Text('${DateFormat("dd/MM/yyyy").format(DateTime.fromMillisecondsSinceEpoch(snapshot.data[index].checkinDate))}',
                          style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold),),
                          )
                        ],
                      ),
                      )
                    ],
                  ),
                    ),)
                  );
                },
              );
            }else if(snapshot.hasError){
              print(snapshot.error);
            }
            else{
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
              )
            ],
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