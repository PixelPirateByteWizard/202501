import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    InmobiAdManger.imx_configureInmobiBootstrap()

    if let controller = window?.rootViewController as? FlutterViewController {
      let channel = FlutterMethodChannel(name: "verzephronix/ads", binaryMessenger: controller.binaryMessenger)
      channel.setMethodCallHandler { call, result in
        switch call.method {
        case "requestInterstitialAfterNav":
          InmobiAdManger.imx_requestInterstitialOnNavSwitch()
          result(nil)
        case "presentRewarded":
          InmobiAdManger.imx_presentRewarded(completion: { watched in
            result(watched)
          })
        case "showBanner":
          NSLog("[InMobi] Swift 收到 showBanner 调用")
          InmobiAdManger.showInmobiBannerAd()
          result(nil)
        case "hideBanner":
          NSLog("[InMobi] Swift 收到 hideBanner 调用")
          InmobiAdManger.imx_hideBannerSlot()
          result(nil)
        case "forcePresentInterstitial":
          InmobiAdManger.imx_forcePresentTopInterstitial()
          result(nil)
        case "presentRewarded":
          // 保持原有分支在此处，避免 fall-through
          InmobiAdManger.imx_presentRewarded(completion: { watched in
            result(watched)
          })
        default:
          result(FlutterMethodNotImplemented)
        }
      }
    }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  @objc func sendEventToFlutterWithEventName(_ eventName: String, data: Any?) {
    // Optionally bridge to Flutter via NotificationCenter or EventChannel later.
  }
}
