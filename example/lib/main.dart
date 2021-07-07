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
  static FacebookEvent? facebookEvent;
  String hashKey='Null';


  _MyAppState(){
    facebookEvent = FacebookEvent();
  }

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
              ElevatedButton(
                child: Text("Log AchieveLevelEvent"),
                onPressed: () {
                  facebookEvent!.logAchieveLevelEvent(
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
    hashKey = (await facebookEvent!.getAndroidHashKey())!;
    print(hashKey);
  }
}
