import 'dart:async';

import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

const channelName = 'com.faisal/facebook_event';

class FacebookEvent {
  static const _channel = MethodChannel(channelName);


  /// Clear user data
  Future<void> clearUserData() {
    return _channel.invokeMethod<void>('clearUserData');
  }

  /// Clear user id.
  Future<void> clearUserID() {
    return _channel.invokeMethod<void>('clearUserID');
  }

  /// Explicitly flush any stored events to the server.
  Future<void> flush() {
    return _channel.invokeMethod<void>('flush');
  }

  /// This method returns the app ID.
  Future<String> getApplicationId() {
    return _channel.invokeMethod<String>('getApplicationId');
  }

  ///Each app/device pair gets an GUID that is sent back with App Events and persisted with this app/device pair.
  Future<String> getAnonymousId() {
    return _channel.invokeMethod<String>('getAnonymousId');
  }

  /// Log an app event with the specified name and set of parameters.
  Future<void> logEvent({
    @required String name,
    Map<String, dynamic> body,
    double valueToSum,
  }) {
    final data = <String, dynamic>{
      'name': name,
      'parameters': body,
      '_valueToSum': valueToSum,
    };

    return _channel.invokeMethod<void>('logEvent', data);
  }

  /// Sets user data to associate with all events.
  Future<void> setUserData({
    String email,
    String firstName,
    String lastName,
    String phone,
    String dateOfBirth,
    String gender,
    String city,
    String state,
    String zip,
    String country,
  }) {
    final data = <String, dynamic>{
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'dateOfBirth': dateOfBirth,
      'gender': gender,
      'city': city,
      'state': state,
      'zip': zip,
      'country': country,
    };

    return _channel.invokeMethod<void>('setUserData', data);
  }


  /// Logs an app event that tracks that the application was open via Push Notification.
  Future<void> logPushNotificationOpen({
    @required Map<String, dynamic> payload,
    String action,
  }) {
    final data = <String, dynamic>{
      'payload': payload,
      'action': action,
    };

    return _channel.invokeMethod<void>('logPushNotificationOpen', data);
  }

  /// Sets a user [id] to associate with all events.
  Future<void> setUserID(String id) {
    return _channel.invokeMethod<void>('setUserID', id);
  }

  /// Update user properties as provided by a map of [body]
  Future<void> updateUserProperties({
    @required Map<String, dynamic> body,
    String applicationId,
  }) {
    final data = <String, dynamic>{
      'parameters': body,
      'applicationId': applicationId,
    };

    return _channel.invokeMethod<void>('updateUserProperties', data);
  }

  ///This event when an app is being activated.
  Future<void> logActivatedApp() {
    return logEvent(name: 'fb_mobile_activate_app');
  }

  /// This event when an app is being deactivated.
  Future<void> logDeactivatedApp() {
    return logEvent(name: 'fb_mobile_deactivate_app');
  }
  


  ///
  Future<void> logContactEvent({
    @required String contact,
  }) {
    return logEvent(
      name: 'Contact',
      body: {
        'button_id': contact,
      },
    );
  }

  /// This event when the user has viewed a form of content in the app.
  /*
   * Parameter key used to specify data for the one or more pieces of content being logged about.
   * Data should be a JSON encoded string. Example: "[{\"id\": \"1234\", \"quantity\": 2,
   * \"item_price\": 5.99}, {\"id\": \"5678\", \"quantity\": 1, \"item_price\": 9.99}]"
   */
  Future<void> logViewContent({
    Map<String, dynamic> content,
    String id,
    String type,
  }) {
    return logEvent(
      name: 'fb_mobile_content_view',
      body: {
        'fb_content': content,
        'fb_content_id': id,
        'fb_content_type': type,
      },
    );
  }

  /// Re-enables auto logging of app events after user consent
  Future<void> setAutoLogAppEventsEnabled(bool enabled) {
    return _channel.invokeMethod<void>('setAutoLogAppEventsEnabled', enabled);
  }

  /// Set Data Processing Options
  Future<void> setDataProcessingOptions(
      List<String> options, {
        int country,
        int state,
      }) {
    final data = <String, dynamic>{
      'options': options,
      'country': country,
      'state': state,
    };

    return _channel.invokeMethod<void>('setDataProcessingOptions', data);
  }


  ///Logs a purchase event with Facebook explicitly, in the specified amount and with the specified currency.
  Future<void> logPurchase({
    @required double amount,
    @required String currency,
    Map<String, dynamic> body,
  }) {
    final data = <String, dynamic>{
      'amount': amount,
      'currency': currency,
      'parameters': body,
    };
    return _channel.invokeMethod<void>('logPurchase', data);
  }


  Future<void> logAchieveLevelEvent({
    @required String level,
  }) {
    final data = <String, dynamic>{
      'level': level,
    };
    return _channel.invokeMethod<void>('logAchieveLevelEvent', data);
  }

  ///Android apps must be digitally signed with a release key before you can upload them to the store.
  ///This method helps to get the release key for setup android in facebook portal
  Future<String> getAndroidHashKey() {
    if(Platform.isAndroid)
      return _channel.invokeMethod('printHashKey');
    else
      return null;
  }

  /// This event use when compete a successful payment
  Future<void> logAddPaymentInfoEvent({@required bool success}) {
    final data = <String, dynamic>{
    'success': success,
    };
    return _channel.invokeMethod('logAddPaymentInfoEvent',data);
  }

  ///This event uses when the addition of an item to a shopping cart or basket.
  Future<void> logAddToCartEvent(
      {
        @required double price,
        String contentData,
        String contentId,
        String contentType,
        String currency='USD',
      }) {
      final data = <String, dynamic>{
          'price': price,
          'contentData': contentData,
          'contentId': contentId,
          'contentType': contentType,
          'currency': currency,
      };
    return _channel.invokeMethod('logAddToCartEvent',data);
  }

  /// This event when the user has completed registration with the app.
  /// Parameter [registrationMethod] is used to specify the method the user has
  Future<void> logCompleteRegistrationEvent(
      {
        @required String registrationMethod,
        @required String name,
        @required String currency
      }) {
      final data = <String, dynamic>{
          'registrationMethod': registrationMethod,
          'name': name,
          'currency': currency,
      };
    return _channel.invokeMethod('logCompleteRegistrationEvent',data);
  }


  ///The event for the checkout process. For example, clicking a Checkout button.
  Future<void> logInitiateCheckoutEvent(
      {
        @required double totalPrice,
        String contentData,
        String contentId,
        String contentType,
        String currency='USD',
        int numItems=1,
        bool paymentInfoAvailable=false
      }) {
      final data = <String, dynamic>{
        'numItems': numItems,
        'totalPrice': totalPrice,
        'contentData': contentData,
        'contentId': contentId,
        'contentType': contentType,
        'currency': currency,
        'paymentInfoAvailable': paymentInfoAvailable,
      };
    return _channel.invokeMethod('logInitiateCheckoutEvent',data);
  }


  Future<void> logRateEvent(
      {
        @required double ratingGiven,
        String contentData,
        String contentId,
        String contentType,
        int maxRatingValue=5,
      }) {
      final data = <String, dynamic>{
        'maxRatingValue': maxRatingValue,
        'ratingGiven': ratingGiven,
        'contentData': contentData,
        'contentId': contentId,
        'contentType': contentType,
      };
    return _channel.invokeMethod('logRateEvent',data);
  }
  
}
