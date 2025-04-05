import Flutter
import UIKit
// import EnyxorameaRegister
import AppTrackingTransparency

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
        // 初始化 Enyxoramea 模块
    // EnyxorameaCZHomeRegister.goBack()
    GeneratedPluginRegistrant.register(with: self)
    let result = super.application(application, didFinishLaunchingWithOptions: launchOptions)
           DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { status in
                // 处理授权结果
            }
        }
    }


    // EnyxorameaCZHomeRegister.initEnyxorameaModule()
    
    return result
  }
}
