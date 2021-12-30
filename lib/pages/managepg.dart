import 'package:flutter/material.dart';
import 'dart:async';
import '../model/pg.dart';
import '../util/dbhelper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pgdetail.dart';
import 'availablity.dart';

class ManagePG extends StatefulWidget {
  int mode;

  ManagePG(this.mode);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ManagePGState();
  }
}

class _ManagePGState extends State<ManagePG> {
  SharedPreferences sharedPreferences;
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final floorCountController = TextEditingController();

  Future<List<PG>> getSharedPrefAndPG() async {
    sharedPreferences = await SharedPreferences.getInstance();
    var dbHelper = DBHelper();
    return dbHelper.getPG(sharedPreferences.getString('user_id'));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        title: Text(
          'Manage PG',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
          child: FutureBuilder<List<PG>>(
            future: getSharedPrefAndPG(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Text(
                                '${snapshot.data[index].name} (${snapshot.data[index].floorCount.toString()})',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Text(
                                '${snapshot.data[index].address}',
                                style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    color: Colors.grey),
                              ),
                            ),
                            widget.mode == 0
                                ? Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: RaisedButton(
                                      color: Colors.blueAccent,
                                      child: Text(
                                        'Add Room',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => PGDetail(
                                                    snapshot.data[index],
                                                    widget.mode)));
                                      },
                                    ),
                                  )
                                : Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: RaisedButton(
                                      color: Colors.blueAccent,
                                      child: Text(
                                        'Availability',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => PGDetail(
                                                    snapshot.data[index],
                                                    widget.mode)));
                                      },
                                    ))
                          ],
                        ),
                      ),
                    );
                  },
                );
              } else {
                return Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Center(
                      child: RaisedButton(
                        color: Colors.blueAccent,
                        child: Text(
                          'Create PG',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (_) {
                                return AlertDialog(
                                  title: Text('Add PG'),
                                  content: SingleChildScrollView(
                                    child: Form(
                                      key: _formKey,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          TextFormField(
                                            controller: nameController,
                                            validator: (value) {
                                              if (value.isEmpty) {
                                                return 'Please enter PG name';
                                              }
                                            },
                                            decoration: InputDecoration(
                                                labelText: 'PG Name'),
                                          ),
                                          TextFormField(
                                            controller: addressController,
                                            validator: (value) {
                                              if (value.isEmpty) {
                                                return 'Please enter address';
                                              }
                                            },
                                            decoration: InputDecoration(
                                                labelText: 'Address'),
                                          ),
                                          TextFormField(
                                            controller: floorCountController,
                                            validator: (value) {
                                              if (value.isEmpty ||
                                                  int.parse(value) <= 0) {
                                                return 'Please enter valid floor count';
                                              }
                                            },
                                            decoration: InputDecoration(
                                                labelText: 'Floor Count'),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 16.0),
                                            child: Container(
                                              width: MediaQuery
                                                  .of(context)
                                                  .size
                                                  .width,
                                              child: RaisedButton(
                                                onPressed: () {
                                                  // Validate will return true if the form is valid, or false if
                                                  // the form is invalid.
                                                  if (_formKey.currentState
                                                      .validate()) {
                                                    // If the form is valid, we want to show a Snackbar

                                                    var dbHelper = DBHelper();
                                                    dbHelper.savePG(
                                                        sharedPreferences
                                                            .getString(
                                                                'user_id'),
                                                        nameController.text,
                                                        addressController.text,
                                                        floorCountController
                                                            .text);
                                                    Navigator.pop(context);
                                                  }
                                                },
                                                color: Colors.greenAccent,
                                                child: Text(
                                                  'Add PG',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius
                                                        .circular(20.0)),
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
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                      ),
                    ),
                  ),
                );
              }
            },
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
          ))),
    );
  }
}
