import 'package:flutter/material.dart';
import 'managepg.dart';
import 'bookings.dart';
import 'inmates.dart';
import 'payments.dart';
import 'login.dart';
import 'dashboard.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  @override
    State<StatefulWidget> createState() {
      // TODO: implement createState
      return _HomePageState();
    }
}

class _HomePageState extends State<HomePage>{

  SharedPreferences sharedPreferences;

  Future<Widget> _getSharedPref() async {
    sharedPreferences = await SharedPreferences.getInstance();
    return Scaffold(
      
        appBar: AppBar(
          backgroundColor: Colors.greenAccent,
          title: Text('PG Manager',style: TextStyle(color: Colors.black),),
        ),
        drawer: SizedBox(
          width: 250.0,
          child: Drawer(
          
          child: ListView(
    // Important: Remove any padding from the ListView.
    padding: EdgeInsets.zero,
    children: <Widget>[
      SizedBox(
        height: 180.0,
        child: Container(
        child: DrawerHeader(
          child: 
            
            Column(
              children: <Widget>[
                Icon(Icons.account_circle,size: 50.0,color: Colors.white,),
                Text('${sharedPreferences.getString('name')}',style: TextStyle(color: Colors.white,)),
                Text('${sharedPreferences.getString('email')}',style: TextStyle(color: Colors.white,)),
                Text('+91${sharedPreferences.getString('phone')}',style: TextStyle(color: Colors.white,))
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
        )
        ),
      ),
      ),
      
      ListTile(
        title: Text('Manage'),
        onTap: () {
          // Update the state of the app
          // ...
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (context)=>ManagePG(0)));
        },
      ),
      
      ListTile(
        title: Text('Booking'),
        onTap: () {
          // Update the state of the app
          // ...
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(
            builder: (context)=>BookingsPage()
          ));
        },
      ),
      ListTile(
        title: Text('Inmates'),
        onTap: () {
          // Update the state of the app
          // ...
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(
            builder: (context)=>InmatesPage()
          ));
        },
      ),
      ListTile(
        title: Text('Availability'),
        onTap: () {
          // Update the state of the app
          // ...
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (context)=>ManagePG(1)));
        },
      ),
      ListTile(
        title: Text('Payments'),
        onTap: () {
          // Update the state of the app
          // ...
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (context)=>PaymentsPage()));
        },
      ),
      
      ListTile(
        title: Text('Log Out'),
        onTap: () {
          // Update the state of the app
          // ...
          // Navigator.pop(context);
          // Navigator.pop(context);
          sharedPreferences.setBool("isLoggedIn", false);
          Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context)=> LoginPage()
          ));
          
        },
      ),
    ],
  ),
        ),
        ),
        body: Container(
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
          child: DashBoard(),
        ),
      );
  }

  @override
    void initState() {
      // TODO: implement initState
      _getSharedPref();
      super.initState();
    }

  @override
    Widget build(BuildContext context) {

      // TODO: implement build
      return FutureBuilder(
        future: _getSharedPref(),
        builder: (context,snapshot){
          if(snapshot.hasData){
            return snapshot.data;
          }else {
            return Scaffold(appBar: AppBar(
              title: Text('PG Manager'),
            ),
            body: Center(
              child: CircularProgressIndicator(),
            ),
            );
          }
        },
      );
    }
}