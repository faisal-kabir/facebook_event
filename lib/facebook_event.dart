library facebook_event;
import 'dart:async';

import 'package:flutter/services.dart';

class FacebookEvent {
  static const MethodChannel _channel =
      const MethodChannel('facebook_event');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
