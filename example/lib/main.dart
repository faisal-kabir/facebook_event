import 'dart:io';

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
    if(Platform.isAndroid)
      getHashKey();
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
              MaterialButton(
                child: Text("Log AchieveLevelEvent"),
                onPressed: () {
                  facebookEvent.logAchieveLevelEvent(
                    level: 'Payment',
                  );
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
    print(hashKey);
  }
}
