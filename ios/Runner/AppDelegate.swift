import Flutter
import UIKit
import AetherysRegister
@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
     AetherysCZHomeRegister.goBack()
    let result = super.application(application, didFinishLaunchingWithOptions: launchOptions)
    
    // 初始化 Aetherys 模块
   
    AetherysCZHomeRegister.initAetherysModule()
    
    return result
  }
}
