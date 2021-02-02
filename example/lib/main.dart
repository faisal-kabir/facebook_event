import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:facebook_event/facebook_event.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static final facebookAppEvents = FacebookEvent();
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
                future: facebookAppEvents.getAnonymousId(),
                builder: (context, snapshot) {
                  final id = snapshot.data ?? '???';
                  return Text('Anonymous ID: $id');
                },
              ),
              MaterialButton(
                child: Text("Click me!"),
                onPressed: () {
                  facebookAppEvents.logEvent(
                    name: 'button_clicked',
                    parameters: {
                      'button_id': 'the_clickme_button',
                    },
                  );
                },
              ),
              MaterialButton(
                child: Text("Test purchase!"),
                onPressed: () {
                  facebookAppEvents.logPurchase(amount: 1, currency: "USD");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}