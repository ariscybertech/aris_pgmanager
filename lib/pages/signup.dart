import 'package:flutter/material.dart';
import '../util/dbhelper.dart';

class SignUp extends StatefulWidget{

  @override
    State<StatefulWidget> createState() {
      // TODO: implement createState
      return _SignUp();
    }

}

class _SignUp extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
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
            child: Padding(
              padding: EdgeInsets.all(10.0),
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
                return 'Please enter your phone';
              }
            },
            keyboardType: TextInputType.numberWithOptions(),
            decoration: InputDecoration(
              labelText: 'Mobile Number'
            ),
            
          ),
          TextFormField(
            controller: emailController,
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter your email';
              }
            },
            decoration: InputDecoration(
              labelText: 'Email'
            ),
            
          ),
          TextFormField(
            controller: passwordController,
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter your password';
              }
            },
            decoration: InputDecoration(
              labelText: 'Password'
            ),
            obscureText: true,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Padding(
            padding: const EdgeInsets.only(left: 10.0,right: 10.0,top: 50.0),
            child: RaisedButton(
              color: Colors.blueAccent,
              onPressed: () {
                // Validate will return true if the form is valid, or false if
                // the form is invalid.
                if (_formKey.currentState.validate()) {
                  // If the form is valid, we want to show a Snackbar
                  
                  var dbHelper = DBHelper();
                  dbHelper.saveUser(nameController.text, emailController.text, passwordController.text, phoneController.text);
                  Navigator.pop(context);
                }
              },
              child: Text('Sign Up',style: TextStyle(color: Colors.white),),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
            ),
          ),
          )
          
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