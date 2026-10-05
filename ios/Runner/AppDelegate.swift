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
    GMSServices.provideAPIKey("AIzaSyCCIwI5oUsQm2-iyM01ZAzWunf6NZ51EYs")

    // 🔔 Lets notifications shown while the app is open appear as banners
    // (flutter_local_notifications); without it iOS only files them in
    // Notification Center. Must be set before plugins register.
    UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate

    // 🔹 Flutter plugins register
    GeneratedPluginRegistrant.register(with: self)

    return super.application(
      application,
      didFinishLaunchingWithOptions: launchOptions
    )
  }
}
