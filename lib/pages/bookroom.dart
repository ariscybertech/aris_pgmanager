import 'package:flutter/material.dart';
import '../model/room.dart';
import '../util/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import '../util/dbhelper.dart';

class BookRoom extends StatefulWidget {
  Room room;
  int index;

  BookRoom(this.room,this.index);

  @override
    State<StatefulWidget> createState() {
      // TODO: implement createState
      return _BookRoomState();
    }
}

class _BookRoomState extends State<BookRoom>{

  final _formKey=GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final moveInDateController = TextEditingController();
  final dateFormat = DateFormat("dd/MM/yyyy");
  DateTime selectedDate;
  @override
    Widget build(BuildContext context) {
      // TODO: implement build
      print('ANURAN room bedStatus ${widget.room.bedStatus}');
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.greenAccent,
          title: Text('Book Room',style: TextStyle(color: Colors.black),),
        ),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Form(
          key: _formKey,
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: nameController,
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter your name';
              }
            },
            decoration: InputDecoration(
              labelText: 'Name'
            ),
            
          ),
          TextFormField(
            controller: phoneController,
            validator: (value) {
              if (value.isEmpty || value.length < 10) {
                return 'Please enter your 10 digit phone';
              }
            },
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Mobile Number'
            ),
            
          ),
          TextFormField(
            controller: addressController,
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter your address';
              }
            },
            decoration: InputDecoration(
              labelText: 'Address'
            ),
            
          ),
          DateTimePickerFormField(
            controller: moveInDateController,
            validator: (value) {
              if (value == null) {
                return 'Please enter your move in date';
              }
            },
            format: dateFormat,
            onChanged: (date) {
              print('ANURAN ${date}');
              selectedDate=date;
            },
          ),
          Padding(
            padding: EdgeInsets.only(left:10.0,right: 10.0,top: 50.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: RaisedButton(
              onPressed: () {
                // Validate will return true if the form is valid, or false if
                // the form is invalid.
                if (_formKey.currentState.validate()) {
                  // If the form is valid, we want to show a Snackbar
                  print("ANURAN form validated true");
                  print('ANURAN ${widget.index}');
                  var dbHelper = DBHelper();
                  dbHelper.saveBooking(widget.index,widget.room.pgID.toString(), widget.room.floorID.toString(),
                   widget.room.id.toString(), nameController.text, phoneController.text, addressController.text,widget.room.price.toString(),selectedDate.millisecondsSinceEpoch.toString(),
                   widget.room.bedStatus);
                  Navigator.pop(context);
                }
              },
              child: Text('Book',style: TextStyle(color: Colors.white),),
              color: Colors.blueAccent,
            ),
            ),
          ),
          
        ],
      ),
        ),
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
        ),
      );
    }
}