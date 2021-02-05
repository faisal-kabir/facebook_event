import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:facebook_event/facebook_event.dart';

void main() {
  const channel = MethodChannel(channelName);
  final facebookEvent = FacebookEvent();
  MethodCall methodCall;

  setUp(() async {
    channel.setMockMethodCallHandler((MethodCall m) async {
      methodCall = m;
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
    methodCall = null;
  });

  group('Event logging', () {
    test('logEvent log events', () async {
      await facebookEvent.logEvent(
        name: 'test-event',
        body: <String, dynamic>{'a': 'b'},
      );
      expect(
        methodCall,
        isMethodCall(
          'logEvent',
          arguments: <String, dynamic>{
            'name': 'test-event',
            'parameters': <String, dynamic>{'a': 'b'},
          },
        ),
      );
    });
  });
}
