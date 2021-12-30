import 'package:flutter/material.dart';
import 'dart:async';
import '../model/payment.dart';
import '../util/dbhelper.dart';
import 'package:intl/intl.dart';
class AllPaymentsPage extends StatefulWidget {
  @override
    State<StatefulWidget> createState() {
      // TODO: implement createState
      return _AllPaymentsState();
    }
}

class _AllPaymentsState extends State<AllPaymentsPage>{

  Future<List<Payment>> fetchPayments() async{
    var dbHelper = DBHelper();
    return await dbHelper.getPayments();
  }

  @override
    Widget build(BuildContext context) {
      // TODO: implement build
      return Container(
        child: FutureBuilder<List<Payment>>(
        future: fetchPayments(),
        builder: (context,snapshot){
          if(snapshot.hasData){
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context,index){
                Payment payment = snapshot.data[index];
                return Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('${payment.name}',textAlign: TextAlign.left,style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold
                    ),),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                      children: <Widget>[
                        Text('Floor: ',style: TextStyle(fontSize: 16.0),),
                        Padding(
                          padding: EdgeInsets.only(left:5.0),
                          child: Text('${payment.floorID}',style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold),),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10.0),
                          child: Text('Room: ',style: TextStyle(fontSize: 16.0),),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left:5.0),
                          child: Text('${payment.roomID}',style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold),),
                        )
                      ],
                    ),
                    ),
                    Row(
                      children: <Widget>[
                        Text('Payment Date: ',style: TextStyle(fontSize: 16.0),),
                        Text('${DateFormat("dd/MM/yyyy").format(DateTime.fromMillisecondsSinceEpoch(payment.paymentDate))}',style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold),),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      child: Text('\u20B9 ${payment.price}',style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold,color: Colors.green),),
                    )
                  ],
                ),
                    ),
                  ),
                );
              },
            );
          }else {
            return Center(
              child: CircularProgressIndicator(),
            );
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
      );
    }
}