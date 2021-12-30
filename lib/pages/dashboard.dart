import 'package:flutter/material.dart';
import 'dart:async';
import '../model/payment.dart';
import '../util/dbhelper.dart';
import 'upcomingpayments.dart';

class DashBoard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _DashBoardState();
  }
}

class _DashBoardState extends State<DashBoard> {
  Future<List<Payment>> fetchPayments() async {
    var dbHelper = DBHelper();
    return await dbHelper.getPayments();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 120.0,
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        children: <Widget>[
                          Text(
                            'Total Payment',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.blueAccent,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold),
                          ),
                          FutureBuilder<List<Payment>>(
                            future: fetchPayments(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                List<Payment> payments = snapshot.data;
                                int totalIncome = 0;
                                for (int i = 0; i < payments.length; i++) {
                                  totalIncome += payments[i].price;
                                }
                                return Padding(
                                  padding: EdgeInsets.only(top: 25.0),
                                  child: Center(
                                    child: Text(
                                      '\u20B9 ${totalIncome}',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.green,
                                          fontSize: 23.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                );
                              } else {
                                return Padding(
                                    padding: EdgeInsets.only(top: 25.0),
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ));
                              }
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 250.0,
                  child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Text(
                            'Upcoming Payment',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.blueAccent,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                          Expanded(
                            child: UpcomingPayments(true),
                          )
                      ],
                    ),
                  ),
                ),
                ),
              )
            ],
          ),
        ),
        decoration: BoxDecoration(
            gradient: LinearGradient(
          // Where the linear gradient begins and ends
          begin: Alignment.topCenter, // new
          end: Alignment.bottomCenter, // new
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
        )));
  }
}
