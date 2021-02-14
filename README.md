# facebook_event

[![pub package](https://img.shields.io/pub/v/facebook_event.svg)](https://pub.dev/packages/facebook_event)

Flutter plugin for [Facebook Event](https://developers.facebook.com/docs/app-events) and Analytics.

> Facebook Events is a feature that can help you organize social gatherings via Facebook. You get a dedicated page for providing all the details of your event plus a range of tools to notify friends about it and keep track of who's going. Facebook Events are different from Facebook Groups and Facebook Pages.

>Facebook Analytics is a robust tool that lets marketers explore users' interactions with advanced goal paths and sales funnels for Facebook ads. In this article, you'll discover how to get started with Facebook Analytics.

## Installation

You must first create an app at Facebook for developers: https://developers.facebook.com/

Get your app id (referred to as `[APP_ID]` below)

### Android

Read through the "[Getting Started with App Events for Android](https://developers.facebook.com/docs/app-events/getting-started-app-events-android)" tutuorial and in particular, follow [step 2](https://developers.facebook.com/docs/app-events/getting-started-app-events-android#2--add-your-facebook-app-id) by adding the following into `/app/res/values/strings.xml` (or into respective `debug` or `release` build flavor)

After that, add that string resource reference to your main `AndroidManifest.xml` file, directly under the `<application>` tag.

```xml
<meta-data
  android:name="com.facebook.sdk.ApplicationId"
  android:value="your_facebook_app_id_here" />
```
[Example Code](https://github.com/faisal-kabir/facebook_event/blob/main/example/android/app/src/main/AndroidManifest.xml)

Add code in your android project `MainActivity.kt`
```
setAutoLogAppEventsEnabled(true)
FacebookSdk.setAutoInitEnabled(true)
FacebookSdk.fullyInitialize()
setAdvertiserIDCollectionEnabled(true)
FacebookSdk.setIsDebugEnabled(true);
FacebookSdk.addLoggingBehavior(LoggingBehavior.APP_EVENTS);
```
[Example Code](https://github.com/faisal-kabir/facebook_event/blob/main/example/android/app/src/main/kotlin/com/faisal/facebook_event/facebook_event_example/MainActivity.kt)

### iOS

Read through the "[Getting Started with App Events for iOS](https://developers.facebook.com/docs/app-events/getting-started-app-events-ios)" tutuorial and in particular, follow [step 4](https://developers.facebook.com/docs/app-events/getting-started-app-events-ios#plist-config) by opening `info.plist` "As Source Code" and add the following

If your code does not have `CFBundleURLTypes`, add the following just before the final `</dict>` element:

```xml
<key>CFBundleURLTypes</key>
<array>
  <dict>
  <key>CFBundleURLSchemes</key>
  <array>
    <string>fb[APP_ID]</string>
  </array>
  </dict>
</array>
<key>FacebookAppID</key>
<string>[APP_ID]</string>
<key>FacebookDisplayName</key>
<string>[APP_NAME]</string>
```

If your code already contains `CFBundleURLTypes`, insert the following:

```xml
<array>
 <dict>
 <key>CFBundleURLSchemes</key>
 <array>
   <string>fb[APP_ID]</string>
 </array>
 </dict>
</array>
<key>FacebookAppID</key>
<string>[APP_ID]</string>
<key>FacebookDisplayName</key>
<string>[APP_NAME]</string>
```
[Example Code](https://github.com/faisal-kabir/facebook_event/blob/main/example/ios/Runner/Info.plist)

Add code in your android project `AppDelegate.swift`
```
ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
AppEvents.activateApp()
AppEvents.logEvent(AppEvents.Name.init(rawValue: "Opened App Main VC"))
```
[Example Code](https://github.com/faisal-kabir/facebook_event/blob/main/example/ios/Runner/AppDelegate.swift)

### Get Android HashKey
```
final facebookEvent = FacebookEvent();
String hashKey='Null';

@override
void initState() {
    // TODO: implement initState
    super.initState();
    if(Platform.isAndroid)
      getHashKey();
}

void getHashKey()async{
    hashKey= await facebookEvent.getAndroidHashKey();
    print(hashKey);
}
```

### All Events
```
final facebookEvent = FacebookEvent();

// Get facebook application id
facebookEvent.getApplicationId();

/// An app is being activated, typically in the AppDelegate's applicationDidBecomeActive.
facebookEvent.logActivatedApp();

// This event when an app is being deactivated.
facebookEvent.logDeactivatedApp();

// Re-enables auto logging of app events after user consent
facebookEvent.setAutoLogAppEventsEnabled(true);

// Submit user details
facebookEvent.setUserData(
  email:'email',
  firstName:'first name',
  lastName:'last name',
  phone:'phone number',
  dateOfBirth:'dob',
  gender:'gender',
  city:'city',
  state:'state',
  zip:'zip',
  country:'country',
);

// Submit custom event
facebookEvent.logEvent(
    name: 'name',
    body: {'key':'value'},
    valueToSum: 0
);

// Submit contact details
facebookEvent.logContactEvent(contact: 'number');

// A user has viewed a form of content in the app.
facebookEvent.logViewContent(
  content: {'key':'value'},
  id: 'id',
  type: 'type'
);

// The user has completed a purchase. The FB.LogPurchase method is a shortcut for logging this event. specified currency.
facebookEvent.logPurchase(
  amount: 0,
  currency: 'USD',
  body: {'key':'value'}
);

// The user has achieved a level in the app.
facebookEvent.logAchieveLevelEvent(
  level: 'level'
);

// The user has entered their payment info.
facebookEvent.logAddPaymentInfoEvent(
  success: true
);

// The user has added an item to their cart. The valueToSum passed should be the item's price.
facebookEvent.logAddToCartEvent(
  price:0,
  contentData: 'contentData',
  contentType: 'contentType',
  contentId: 'contentId',
  currency: 'USD'
);

// This event when the user has completed registration with the app.
// A user has completed registration with the app.
facebookEvent.logCompleteRegistrationEvent(
  registrationMethod:'registrationMethod',
  name: 'name',
  currency: 'USD'
);

// The user has entered the checkout process. The valueToSum passed should be the total price in the cart.
facebookEvent.logInitiateCheckoutEvent(
  totalPrice:0,
  contentData: 'contentData',
  contentType: 'contentType',
  contentId: 'contentId',
  currency: 'USD',
  numItems: 1,
  paymentInfoAvailable: true
);

// The user has rated an item in the app. The valueToSum passed should be the numeric rating.
facebookEvent.logRateEvent(
  ratingGiven:5,
  contentData: 'contentData',
  contentType: 'contentType',
  contentId: 'contentId',
  maxRatingValue: 5
);

```

## Documentation

You will find all the [FB.LogAppEvent](https://developers.facebook.com/docs/unity/reference/current/FB.LogAppEvent/) details here.

