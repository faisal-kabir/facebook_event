import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:facebook_event/facebook_event.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static final facebookEvent = FacebookEvent();
  String hashKey='Null';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //getHashKey();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FutureBuilder(
                future: facebookEvent.getAnonymousId(),
                builder: (context, snapshot) {
                  final id = snapshot.data ?? '???';
                  return Text('Anonymous ID: $id');
                },
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(hashKey,textAlign: TextAlign.center,),
              ),
              MaterialButton(
                child: Text("Click me!"),
                onPressed: () {
                  facebookEvent.logEvent(
                    name: 'button_clicked',
                    parameters: {
                      'button_id': 'the_clickme_button',
                    },
                  );
                },
              ),
              MaterialButton(
                child: Text("Log AchieveLevelEvent"),
                onPressed: () {
                  facebookEvent.logAchieveLevelEvent(
                    level: 'Payment',
                  );
                },
              ),
              MaterialButton(
                child: Text("Test purchase!"),
                onPressed: () {
                  facebookEvent.logPurchase(amount: 1, currency: "USD");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void getHashKey()async{
    hashKey= await facebookEvent.getAndroidHashKey();
    setState(() {

    });
  }
}
