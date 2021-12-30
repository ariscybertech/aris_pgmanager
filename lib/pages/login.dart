import 'package:flutter/material.dart';
import '../util/dbhelper.dart';
import 'signup.dart';
import '../model/user.dart';
import 'home.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  SharedPreferences sharedPreferences;

  void _getSharedPref() async {
    sharedPreferences=await SharedPreferences.getInstance();
  }

  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.greenAccent,
          title: Text('PG Manager',style: TextStyle(color: Colors.black),),
        ),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
          child: Builder(
          builder: (ctx) {
            _getSharedPref();
            return Padding(
              padding: EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                      controller: emailController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter your email';
                        }
                      },
                      decoration: InputDecoration(labelText: 'Email'),
                    ),
                    TextFormField(
                      controller: passwordController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter your password';
                        }
                      },
                      decoration: InputDecoration(labelText: 'Password'),
                      obscureText: true,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Container(
                        height: 100.0,
                        child: Center(
                          child: Container(
                            width: 200.0,
                            child: RaisedButton(
                            
                        onPressed: () {
                          // Validate will return true if the form is valid, or false if
                          // the form is invalid.
                          if (_formKey.currentState.validate()) {
                            // If the form is valid, we want to show a Snackbar
                            var dbHelper = DBHelper();
                            dbHelper
                                .getUser(emailController.text,
                                    passwordController.text)
                                .then((List<User> users) {
                              if (users != null && users.length > 0) {
                                sharedPreferences.setBool('isLoggedIn', true);
                                sharedPreferences.setString('user_id', users[0].id);
                                sharedPreferences.setString('name', users[0].name);
                                sharedPreferences.setString('email', users[0].email);
                                sharedPreferences.setString('phone', users[0].phone);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomePage()));
                                //Navigator.pop(context);
                              } else {
                                Scaffold.of(ctx).showSnackBar(SnackBar(
                                    content: Text('Invalid Credentials')));
                              }
                            });
                          }
                        },
                        child: Text('Login',style: TextStyle(fontSize: 20.0),),
                        color: Colors.greenAccent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                      ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Text('Don\'t have an account?',textAlign: TextAlign.center,style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.white
                      ),),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 30.0),
                      child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: RaisedButton(
                      child: Text('Create One Here',style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white
                      ),),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => SignUp()));
                      },
                      color: Colors.blueAccent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                    ),
                    ),
                    )
                  ],
                ),
              ),
            );
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
        ));
  }
}
