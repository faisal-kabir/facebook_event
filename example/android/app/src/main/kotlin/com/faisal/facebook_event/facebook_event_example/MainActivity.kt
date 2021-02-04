package com.faisal.facebook_event.facebook_event_example

import android.os.Bundle
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import android.content.Context
import android.content.pm.PackageInfo
import android.content.pm.PackageManager
import android.util.Base64
import android.util.Log
import androidx.annotation.NonNull
import androidx.appcompat.app.AppCompatDelegate
import com.facebook.FacebookSdk
import com.facebook.FacebookSdk.setAdvertiserIDCollectionEnabled
import com.facebook.FacebookSdk.setAutoLogAppEventsEnabled
import com.facebook.LoggingBehavior
import com.facebook.appevents.AppEventsLogger
import com.google.firebase.FirebaseApp
import io.flutter.plugins.GeneratedPluginRegistrant
import java.security.MessageDigest
import java.security.NoSuchAlgorithmException

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        AppCompatDelegate.setCompatVectorFromResourcesEnabled(true)
        FirebaseApp.initializeApp(applicationContext)
        setAutoLogAppEventsEnabled(true)
        FacebookSdk.setAutoInitEnabled(true)
        FacebookSdk.fullyInitialize()
        setAdvertiserIDCollectionEnabled(true)
        FacebookSdk.setIsDebugEnabled(true);
        FacebookSdk.addLoggingBehavior(LoggingBehavior.APP_EVENTS);
    }
}
