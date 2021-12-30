import 'package:flutter/material.dart';
import 'allpayments.dart';
import 'upcomingpayments.dart';
class PaymentsPage extends StatefulWidget {
  @override
    State<StatefulWidget> createState() {
      // TODO: implement createState
      return _PaymentsState();
    }
}

class _PaymentsState extends State<PaymentsPage> {
  @override
    Widget build(BuildContext context) {
      // TODO: implement build
      return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.greenAccent,
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.all_inclusive,color: Colors.black,),text: 'All Payments',),
                Tab(icon: Icon(Icons.update,color: Colors.black,),text: 'Upcoming',)
                
              ],
            ),
            title: Text('Payments',style: TextStyle(color: Colors.black),),
          ),
          body: TabBarView(
            children: [
              AllPaymentsPage(),
              UpcomingPayments(false)
            ],
          )));
    }
}