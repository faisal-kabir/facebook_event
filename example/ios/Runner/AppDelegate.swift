import UIKit
import Flutter
import FBSDKCoreKit

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
    AppEvents.activateApp()
    AppEvents.logEvent(AppEvents.Name.init(rawValue: "Opened App Main VC"))
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
