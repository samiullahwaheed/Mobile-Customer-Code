import UIKit
import Flutter
import GoogleMaps   // ✅ Google Maps SDK
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate {

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    // 🔑 Google Maps API Key
    GMSServices.provideAPIKey("AIzaSyCVoe2GBYsk1jU6E9RFIxhVfsyBCSkMX_w")

    // 🔔 Required so iOS delivers notification callbacks (foreground banners / taps)
    UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate

    // 🔹 Flutter plugins register
    GeneratedPluginRegistrant.register(with: self)

    // 🔔 Register with APNs so FCM receives the device's APNs token
    application.registerForRemoteNotifications()

    return super.application(
      application,
      didFinishLaunchingWithOptions: launchOptions
    )
  }
}
