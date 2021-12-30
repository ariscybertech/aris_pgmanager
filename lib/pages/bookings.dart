import 'package:flutter/material.dart';
import 'dart:async';
import '../util/dbhelper.dart';
import '../model/booking.dart';
import 'package:intl/intl.dart';

class BookingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _BookingsPageState();
  }
}

class _BookingsPageState extends State<BookingsPage> {
  List<Booking> bookings = [];
  List<Booking> filterBookings = [];
  String searchText = "";

  Future<List<Booking>> fetchBookings() {
    var dbHelper = DBHelper();
    return dbHelper.getBookings();
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  void checkIn(Booking booking) {
    var dbHelper = DBHelper();
    dbHelper.checkin(booking);
  }

  void deleteBooking(Booking booking){
    var dbHelper = DBHelper();
    dbHelper.deleteBooking(booking);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        title: Text(
          'Bookings',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10.0),
              child: TextField(
                decoration: InputDecoration(labelText: 'Seach Booking'),
                onChanged: (query) {
                  filterBookings.clear();
                  bookings.forEach((booking) {
                    if (booking.name
                        .toLowerCase()
                        .contains(query.toLowerCase())) {
                      filterBookings.add(booking);
                    }
                  });
                  setState(() {
                    searchText = query;
                  });
                },
              ),
            ),
            Expanded(
              child: searchText != ""
                  ? ListView.builder(
                      itemCount: filterBookings.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Card(
                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    '${filterBookings[index].name}',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    '+91${filterBookings[index].phone}',
                                    style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        color: Colors.grey),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 10.0),
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          'Floor: ',
                                          style: TextStyle(fontSize: 16.0),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 5.0),
                                          child: Text(
                                            '${filterBookings[index].floorid}',
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
                                            '${filterBookings[index].roomid}',
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
                                        'Booking:',
                                        style: TextStyle(fontSize: 16.0),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 10.0),
                                        child: Text(
                                          '${DateFormat("dd/MM/yyyy").format(DateTime.fromMillisecondsSinceEpoch(filterBookings[index].bookingDate))}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16.0),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 10.0),
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          'Move In:',
                                          style: TextStyle(fontSize: 16.0),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 10.0),
                                          child: Text(
                                            '${DateFormat("dd/MM/yyyy").format(DateTime.fromMillisecondsSinceEpoch(filterBookings[index].moveInDate))}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16.0),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  DateFormat("dd/MM/yyyy").format(
                                              DateTime.now()) ==
                                          DateFormat("dd/MM/yyyy").format(
                                              DateTime
                                                  .fromMillisecondsSinceEpoch(
                                                      bookings[index]
                                                          .moveInDate))  
                                      ? Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Padding(
                                            padding: EdgeInsets.all(5.0),
                                            child: RaisedButton(
                                              child: Text(
                                                'Check In',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              color: Colors.blueAccent,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius
                                                      .circular(20.0)),
                                              onPressed: () {
                                                checkIn(filterBookings[index]);
                                                setState(() {
                                                  searchText = "";
                                                });
                                              },
                                            ),
                                          ),
                                        )
                                      : Container(),

                                      DateTime.now().millisecondsSinceEpoch > filterBookings[index].moveInDate ? 
                                          Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Padding(
                                            padding: EdgeInsets.all(5.0),
                                            child: RaisedButton(
                                              child: Text(
                                                'Delete Booking',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              color: Colors.red,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius
                                                      .circular(20.0)),
                                              onPressed: () {
                                                deleteBooking(filterBookings[index]);
                                              },
                                            ),
                                          ),
                                        ) : Container()
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : FutureBuilder<List<Booking>>(
                      future: fetchBookings(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          bookings = snapshot.data;
                          return ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
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
                                          '${snapshot.data[index].name}',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          '+91${snapshot.data[index].phone}',
                                          style: TextStyle(
                                              fontStyle: FontStyle.italic,
                                              color: Colors.grey),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10.0),
                                          child: Row(
                                            children: <Widget>[
                                              Text(
                                                'Floor: ',
                                                style:
                                                    TextStyle(fontSize: 16.0),
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(left: 5.0),
                                                child: Text(
                                                  '${snapshot.data[index].floorid}',
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
                                                  '${snapshot.data[index].roomid}',
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
                                              'Booking:',
                                              style: TextStyle(fontSize: 16.0),
                                            ),
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(left: 10.0),
                                              child: Text(
                                                '${DateFormat("dd/MM/yyyy").format(DateTime.fromMillisecondsSinceEpoch(snapshot.data[index].bookingDate))}',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16.0),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10.0),
                                          child: Row(
                                            children: <Widget>[
                                              Text(
                                                'Move In:',
                                                style:
                                                    TextStyle(fontSize: 16.0),
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(left: 10.0),
                                                child: Text(
                                                  '${DateFormat("dd/MM/yyyy").format(DateTime.fromMillisecondsSinceEpoch(snapshot.data[index].moveInDate))}',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16.0),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        DateFormat("dd/MM/yyyy").format(
                                                    DateTime.now()) ==
                                                DateFormat("dd/MM/yyyy").format(
                                                    DateTime
                                                        .fromMillisecondsSinceEpoch(
                                                            bookings[index]
                                                                .moveInDate))
                                            ? Container(
                                                width: MediaQuery
                                                    .of(context)
                                                    .size
                                                    .width,
                                                child: Padding(
                                                  padding: EdgeInsets.all(5.0),
                                                  child: RaisedButton(
                                                    child: Text(
                                                      'Check In',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    color: Colors.blueAccent,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20.0)),
                                                    onPressed: () {
                                                      checkIn(bookings[index]);
                                                      setState(() {
                                                        searchText = "";
                                                      });
                                                    },
                                                  ),
                                                ),
                                              )
                                            : Container(),
                                        DateTime.now().millisecondsSinceEpoch > bookings[index].moveInDate ? 
                                          Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Padding(
                                            padding: EdgeInsets.all(5.0),
                                            child: RaisedButton(
                                              child: Text(
                                                'Delete Booking',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              color: Colors.red,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius
                                                      .circular(20.0)),
                                              onPressed: () {
                                                deleteBooking(bookings[index]);
                                              },
                                            ),
                                          ),
                                        ) : Container()
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        } else if (snapshot.hasError) {
                          print(snapshot.error);
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
      ),
    );
  }
}
