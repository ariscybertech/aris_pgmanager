import 'package:flutter/material.dart';
import 'pages/login.dart';
import 'dart:async';
import 'pages/home.dart';

import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(new PgManagerApp());

class PgManagerApp extends StatelessWidget {
  // This widget is the root of your application.
  SharedPreferences sharedPreferences;

  Future<Widget> _getSharedPref() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getBool('isLoggedIn') ?? false) {
              return HomePage();
    } else {
      return LoginPage();
    }
    
  }

  @override
  Widget build(BuildContext context) {
    

    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder<Widget>(
        future: _getSharedPref(),
        builder: (context,snapshot){
          if(snapshot.hasData){
            return snapshot.data;
          }else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}


