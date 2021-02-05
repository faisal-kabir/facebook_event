package com.faisal.flutter.facebook_event

import android.content.Context
import android.content.pm.PackageInfo
import android.content.pm.PackageManager
import android.os.Bundle
import android.util.Base64
import android.util.Log
import androidx.annotation.NonNull
import com.facebook.FacebookSdk
import com.facebook.GraphRequest
import com.facebook.GraphResponse
import com.facebook.appevents.AppEventsConstants
import com.facebook.appevents.AppEventsLogger
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.security.MessageDigest
import java.security.NoSuchAlgorithmException
import java.util.*


/** FacebookEventPlugin */
class FacebookEventPlugin: FlutterPlugin, MethodCallHandler {
  private lateinit var channel : MethodChannel
  private lateinit var appEventsLogger: AppEventsLogger
  private lateinit var anonymousId: String

  private lateinit var context: Context

  private val logTag = "FacebookAppEvents"

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "com.faisal/facebook_event")
    channel.setMethodCallHandler(this)
    appEventsLogger = AppEventsLogger.newLogger(flutterPluginBinding.applicationContext)
    anonymousId = AppEventsLogger.getAnonymousAppDeviceGUID(flutterPluginBinding.applicationContext)
    context=flutterPluginBinding.applicationContext
  }
  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
      "clearUserData" -> handleClearUserData(call, result)
      "clearUserID" -> handleClearUserId(call, result)
      "flush" -> handleFlush(call, result)
      "getApplicationId" -> handleGetApplicationId(call, result)
      "logEvent" -> handleLogEvent(call, result)
      "logPushNotificationOpen" -> handlePushNotificationOpen(call, result)
      "setUserData" -> handleSetUserData(call, result)
      "setUserID" -> handleSetUserId(call, result)
      "updateUserProperties" -> handleUpdateUserProperties(call, result)
      "setAutoLogAppEventsEnabled" -> handleSetAutoLogAppEventsEnabled(call, result)
      "setDataProcessingOptions" -> handleSetDataProcessingOptions(call, result)
      "getAnonymousId" -> handleGetAnonymousId(call, result)
      "logPurchase" -> handlePurchased(call, result)
      "printHashKey" -> printHashKey(context, result)
      "logAchieveLevelEvent" -> logAchieveLevelEvent(call, result)
      "logAddPaymentInfoEvent" -> logAddPaymentInfoEvent(call, result)
      "logAddToCartEvent" -> logAddToCartEvent(call, result)
      "logCompleteRegistrationEvent" -> logCompleteRegistrationEvent(call, result)
      "logInitiateCheckoutEvent" -> logInitiateCheckoutEvent(call, result)
      "logRateEvent" -> logRateEvent(call, result)
      else -> result.notImplemented()
    }
  }


  private fun handleClearUserData(call: MethodCall, result: Result) {
    AppEventsLogger.clearUserData()
    result.success(null)
  }

  private fun handleClearUserId(call: MethodCall, result: Result) {
    AppEventsLogger.clearUserID()
    result.success(null)
  }

  private fun handleFlush(call: MethodCall, result: Result) {
    appEventsLogger.flush()
    result.success(null)
  }

  private fun handleGetApplicationId(call: MethodCall, result: Result) {
    result.success(appEventsLogger.getApplicationId())
  }

  private fun handleGetAnonymousId(call: MethodCall, result: Result) {
    result.success(anonymousId)
  }

  private fun handleLogEvent(call: MethodCall, result: Result) {
    val eventName = call.argument("name") as? String
    val parameters = call.argument("parameters") as? Map<String, Object>
    val valueToSum = call.argument("_valueToSum") as? Double

    if (valueToSum != null && parameters != null) {
      val parameterBundle = createBundleFromMap(parameters)
      appEventsLogger.logEvent(eventName, valueToSum, parameterBundle)
    } else if (valueToSum != null) {
      appEventsLogger.logEvent(eventName, valueToSum)
    } else if (parameters != null) {
      val parameterBundle = createBundleFromMap(parameters)
      appEventsLogger.logEvent(eventName, parameterBundle)
    } else {
      appEventsLogger.logEvent(eventName)
    }

    result.success(null)
  }

  private fun handlePushNotificationOpen(call: MethodCall, result: Result) {
    val action = call.argument("action") as? String
    val payload = call.argument("payload") as? Map<String, Object>
    val payloadBundle = createBundleFromMap(payload)

    if (action != null) {
      appEventsLogger.logPushNotificationOpen(payloadBundle, action)
    } else {
      appEventsLogger.logPushNotificationOpen(payloadBundle)
    }

    result.success(null)
  }

  private fun handleSetUserData(call: MethodCall, result: Result) {
    val parameters = call.argument("parameters") as? Map<String, Object>
    val parameterBundle = createBundleFromMap(parameters)

    AppEventsLogger.setUserData(
            parameterBundle?.getString("email"),
            parameterBundle?.getString("firstName"),
            parameterBundle?.getString("lastName"),
            parameterBundle?.getString("phone"),
            parameterBundle?.getString("dateOfBirth"),
            parameterBundle?.getString("gender"),
            parameterBundle?.getString("city"),
            parameterBundle?.getString("state"),
            parameterBundle?.getString("zip"),
            parameterBundle?.getString("country")
    )

    result.success(null)
  }

  private fun handleUpdateUserProperties(call: MethodCall, result: Result) {
    val applicationId = call.argument("applicationId") as? String
    val parameters = call.argument("parameters") as? Map<String, Object>
    val parameterBundle = createBundleFromMap(parameters) ?: Bundle()

    val requestCallback = GraphRequest.Callback() {
      @Override
      fun onCompleted(response: GraphResponse) {
        val data = response.getJSONObject()
        result.success(data)
      }
    }

    for (key in parameterBundle.keySet()) {
      Log.d(logTag, "[updateUserProperties] " + key + ": " + parameterBundle.get(key))
    }

    if (applicationId == null) AppEventsLogger.updateUserProperties(parameterBundle, requestCallback)
    else AppEventsLogger.updateUserProperties(parameterBundle, applicationId, requestCallback)

    result.success(null)
  }

  private fun handleSetUserId(call: MethodCall, result: Result) {
    val id = call.arguments as String
    AppEventsLogger.setUserID(id)
    result.success(null)
  }

  private fun createBundleFromMap(parameterMap: Map<String, Any>?): Bundle? {
    if (parameterMap == null) {
      return null
    }

    val bundle = Bundle()
    for (jsonParam in parameterMap.entries) {
      val value = jsonParam.value
      val key = jsonParam.key
      if (value is String) {
        bundle.putString(key, value as String)
      } else if (value is Int) {
        bundle.putInt(key, value as Int)
      } else if (value is Long) {
        bundle.putLong(key, value as Long)
      } else if (value is Double) {
        bundle.putDouble(key, value as Double)
      } else if (value is Boolean) {
        bundle.putBoolean(key, value as Boolean)
      } else if (value is Map<*, *>) {
        val nestedBundle = createBundleFromMap(value as Map<String, Any>)
        bundle.putBundle(key, nestedBundle as Bundle)
      } else {
        throw IllegalArgumentException(
                "Unsupported value type: " + value.javaClass.kotlin)
      }
    }
    return bundle
  }

  private fun handleSetAutoLogAppEventsEnabled(call: MethodCall, result: Result) {
    val enabled = call.arguments as Boolean
    FacebookSdk.setAutoLogAppEventsEnabled(enabled)
    result.success(null)
  }

  private fun handleSetDataProcessingOptions(call: MethodCall, result: Result) {
    val options = call.argument("options") as? ArrayList<String> ?: arrayListOf()
    val country = call.argument("country") as? Int ?: 0
    val state = call.argument("state") as? Int ?: 0

    FacebookSdk.setDataProcessingOptions(options.toTypedArray(), country, state)
    result.success(null)
  }

  private fun handlePurchased(call: MethodCall, result: Result) {
    var amount = (call.argument("amount") as? Double)?.toBigDecimal()
    var currency = Currency.getInstance(call.argument("currency") as? String)
    val parameters = call.argument("parameters") as? Map<String, Object>
    val parameterBundle = createBundleFromMap(parameters) ?: Bundle()

    appEventsLogger.logPurchase(amount, currency, parameterBundle)
    result.success(null)
  }

  private fun printHashKey(pContext: Context, result: Result) {
    lateinit var hashKey : String
    try {
      val info: PackageInfo = pContext.getPackageManager().getPackageInfo(pContext.getPackageName(), PackageManager.GET_SIGNATURES)
      for (signature in info.signatures) {
        val md: MessageDigest = MessageDigest.getInstance("SHA")
        md.update(signature.toByteArray())
        hashKey = String(Base64.encode(md.digest(), 0))
      }
    } catch (e: NoSuchAlgorithmException) {
      Log.d("printHashKey()", e.message)
    } catch (e: Exception) {
      Log.d("printHashKey()", e.message)
    }
    result.success(hashKey)

  }

  private fun logAchieveLevelEvent(call: MethodCall, result: Result) {
    val params = Bundle()
    params.putString(AppEventsConstants.EVENT_PARAM_LEVEL, call.argument("level") as? String)
    appEventsLogger.logEvent(AppEventsConstants.EVENT_NAME_ACHIEVED_LEVEL, params)
    result.success(null)
  }
  private fun logAddPaymentInfoEvent(call: MethodCall, result: Result) {
    val params = Bundle()
    params.putInt(AppEventsConstants.EVENT_PARAM_SUCCESS, if (call.argument("success") as? Boolean == true) 1 else 0)
    appEventsLogger.logEvent(AppEventsConstants.EVENT_NAME_ADDED_PAYMENT_INFO, params)
    result.success(null)
  }
  private fun logAddToCartEvent(call: MethodCall, result: Result) {
    val params = Bundle()
    var price : Double = call.argument<Double>("price") as Double
    params.putString(AppEventsConstants.EVENT_PARAM_CONTENT, call.argument("contentData") as? String)
    params.putString(AppEventsConstants.EVENT_PARAM_CONTENT_ID, call.argument("contentId") as? String)
    params.putString(AppEventsConstants.EVENT_PARAM_CONTENT_TYPE, call.argument("contentType") as? String)
    params.putString(AppEventsConstants.EVENT_PARAM_CURRENCY, call.argument("currency") as? String)
    appEventsLogger.logEvent(AppEventsConstants.EVENT_NAME_ADDED_TO_CART, price, params)
    result.success(null)
  }
  private fun logCompleteRegistrationEvent(call: MethodCall, result: Result) {
    val params = Bundle()
    params.putString(AppEventsConstants.EVENT_PARAM_REGISTRATION_METHOD, call.argument("registrationMethod") as? String)
    params.putString(AppEventsConstants.EVENT_NAME_COMPLETED_REGISTRATION, call.argument("name") as? String)
    params.putString(AppEventsConstants.EVENT_PARAM_CURRENCY, call.argument("currency") as? String)
    appEventsLogger.logEvent(AppEventsConstants.EVENT_NAME_COMPLETED_REGISTRATION, params);
    result.success(null)
  }
  private fun logInitiateCheckoutEvent(call: MethodCall, result: Result) {
    val params = Bundle()
    var numItems : Int = call.argument<Int>("numItems") as Int
    var totalPrice : Double = call.argument<Double>("totalPrice") as Double
    params.putString(AppEventsConstants.EVENT_PARAM_CONTENT, call.argument("contentData") as? String)
    params.putString(AppEventsConstants.EVENT_PARAM_CONTENT_ID, call.argument("contentId") as? String)
    params.putString(AppEventsConstants.EVENT_PARAM_CONTENT_TYPE, call.argument("contentType") as? String)
    params.putInt(AppEventsConstants.EVENT_PARAM_NUM_ITEMS, numItems)
    params.putInt(AppEventsConstants.EVENT_PARAM_PAYMENT_INFO_AVAILABLE, if (call.argument("paymentInfoAvailable") as? Boolean == true) 1 else 0)
    params.putString(AppEventsConstants.EVENT_PARAM_CURRENCY, call.argument("currency") as? String)
    appEventsLogger.logEvent(AppEventsConstants.EVENT_NAME_INITIATED_CHECKOUT, totalPrice, params)
    result.success(null)
  }
  private fun logRateEvent(call: MethodCall, result: Result) {
    var maxRatingValue : Int = call.argument<Int>("maxRatingValue") as Int
    var ratingGiven : Double = call.argument<Double>("ratingGiven") as Double
    val params = Bundle()
    params.putString(AppEventsConstants.EVENT_PARAM_CONTENT, call.argument("contentData") as? String)
    params.putString(AppEventsConstants.EVENT_PARAM_CONTENT_ID, call.argument("contentId") as? String)
    params.putString(AppEventsConstants.EVENT_PARAM_CONTENT_TYPE, call.argument("contentType") as? String)
    params.putInt(AppEventsConstants.EVENT_PARAM_MAX_RATING_VALUE, maxRatingValue)
    appEventsLogger.logEvent(AppEventsConstants.EVENT_NAME_RATED, ratingGiven, params)
    result.success(null)
  }
}
