import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/payment.dart';
import 'dart:async';
import '../util/dbhelper.dart';

class UpcomingPayments extends StatefulWidget {
  bool isDashboard;

  UpcomingPayments(this.isDashboard);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _UpcomingPaymentsState();
  }
}

class _UpcomingPaymentsState extends State<UpcomingPayments> {
  List<Payment> payments = [];
  List<Payment> filterPayments = [];
  String searchText = "";

  bool shouldReload = true;

  Future<List<Payment>> fetchPayments() async {
    var dbHelper = DBHelper();
    return await dbHelper.getUpcomingPayments();
  }

  void updatePayment(Payment payment) {
    var dbHelper = DBHelper();

    dbHelper.updatePayment(payment);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: <Widget>[
          !widget.isDashboard ? Padding(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(labelText: 'Seach Booking'),
              onChanged: (query) {
                filterPayments.clear();
                payments.forEach((payment) {
                  if (payment.name
                      .toLowerCase()
                      .contains(query.toLowerCase())) {
                    filterPayments.add(payment);
                  }
                });
                setState(() {
                  searchText = query;
                });
              },
            ),
          ):Container(),
          Expanded(
            child: searchText != ""
                ? ListView.builder(
                    itemCount: filterPayments.length,
                    itemBuilder: (context, index) {
                      Payment payment = filterPayments[index];
                      return Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Card(
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  '${payment.name}',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10.0),
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        'Floor: ',
                                        style: TextStyle(fontSize: 16.0),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 5.0),
                                        child: Text(
                                          '${payment.floorID}',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 10.0),
                                        child: Text(
                                          'Room: ',
                                          style: TextStyle(fontSize: 16.0),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 5.0),
                                        child: Text(
                                          '${payment.roomID}',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      'Renew Date: ',
                                      style: TextStyle(fontSize: 16.0),
                                    ),
                                    Text(
                                      '${DateFormat("dd/MM/yyyy").format(DateTime.fromMillisecondsSinceEpoch(payment.paymentDate).add(Duration(days:30)))}',
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.redAccent),
                                    ),
                                  ],
                                ),
                                DateFormat("dd/MM/yyyy")
                                            .format(DateTime.now()) ==
                                        DateFormat("dd/MM/yyyy").format(DateTime
                                            .fromMillisecondsSinceEpoch(
                                                payment.paymentDate)
                                            .add(Duration(days: 30)))
                                    ? Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Padding(
                                          padding: EdgeInsets.all(10.0),
                                          child: RaisedButton(
                                            child: Text(
                                              'Pay Now',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            color: Colors.blueAccent,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius
                                                    .circular(20.0)),
                                            onPressed: () {
                                              updatePayment(payment);
                                              setState(() {
                                                shouldReload = false;
                                              });
                                            },
                                          ),
                                        ),
                                      )
                                    : Container()
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : FutureBuilder<List<Payment>>(
                    future: fetchPayments(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        payments = snapshot.data;
                        return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            Payment payment = snapshot.data[index];
                            return Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Card(
                                child: Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        '${payment.name}',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10.0),
                                        child: Row(
                                          children: <Widget>[
                                            Text(
                                              'Floor: ',
                                              style: TextStyle(fontSize: 16.0),
                                            ),
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(left: 5.0),
                                              child: Text(
                                                '${payment.floorID}',
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(left: 10.0),
                                              child: Text(
                                                'Room: ',
                                                style:
                                                    TextStyle(fontSize: 16.0),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(left: 5.0),
                                              child: Text(
                                                '${payment.roomID}',
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Text(
                                            'Renew Date: ',
                                            style: TextStyle(fontSize: 16.0),
                                          ),
                                          Text(
                                            '${DateFormat("dd/MM/yyyy").format(DateTime.fromMillisecondsSinceEpoch(payment.paymentDate).add(Duration(days:30)))}',
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.redAccent),
                                          ),
                                        ],
                                      ),
                                      DateFormat("dd/MM/yyyy")
                                                  .format(DateTime.now()) ==
                                              DateFormat("dd/MM/yyyy").format(
                                                  DateTime
                                                      .fromMillisecondsSinceEpoch(
                                                          payment.paymentDate)
                                                      .add(Duration(days: 30)))
                                          ? Container(
                                              width: MediaQuery
                                                  .of(context)
                                                  .size
                                                  .width,
                                              child: Padding(
                                                padding: EdgeInsets.all(10.0),
                                                child: RaisedButton(
                                                  child: Text(
                                                    'Pay Now',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  color: Colors.blueAccent,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius
                                                          .circular(20.0)),
                                                  onPressed: () {
                                                    updatePayment(payment);
                                                    setState(() {
                                                      shouldReload = false;
                                                    });
                                                  },
                                                ),
                                              ),
                                            )
                                          : Container()
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      } else {
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
      )),
    );
  }
}

//DateFormat("dd/MM/yyyy").format(DateTime.fromMillisecondsSinceEpoch(payment.paymentDate).add(Duration(days:30)))
