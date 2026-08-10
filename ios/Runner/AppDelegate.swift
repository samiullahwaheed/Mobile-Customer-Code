import UIKit
import Flutter
import GoogleMaps   // ✅ Google Maps SDK

@main
@objc class AppDelegate: FlutterAppDelegate {

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    // 🔑 Google Maps API Key
    GMSServices.provideAPIKey("AIzaSyCVoe2GBYsk1jU6E9RFIxhVfsyBCSkMX_w")

    // 🔹 Flutter plugins register
    GeneratedPluginRegistrant.register(with: self)

    return super.application(
      application,
      didFinishLaunchingWithOptions: launchOptions
    )
  }
}
