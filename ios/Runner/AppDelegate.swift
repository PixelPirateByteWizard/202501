import Flutter
import UIKit
import AVFoundation

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    // 配置音频会话以支持后台播放
    do {
      let audioSession = AVAudioSession.sharedInstance()
      try audioSession.setCategory(.playback, mode: .default, options: [.allowAirPlay, .allowBluetooth])
      try audioSession.setActive(true)
    } catch {
      print("Failed to set up audio session: \(error)")
    }
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  override func applicationWillResignActive(_ application: UIApplication) {
    // 当应用即将进入后台时，确保音频会话保持活跃
    do {
      try AVAudioSession.sharedInstance().setActive(true)
    } catch {
      print("Failed to keep audio session active: \(error)")
    }
  }
  
  override func applicationDidEnterBackground(_ application: UIApplication) {
    // 应用进入后台时的处理
    do {
      try AVAudioSession.sharedInstance().setActive(true)
    } catch {
      print("Failed to maintain audio session in background: \(error)")
    }
  }
  
  override func applicationWillEnterForeground(_ application: UIApplication) {
    // 应用即将进入前台时的处理
    do {
      try AVAudioSession.sharedInstance().setActive(true)
    } catch {
      print("Failed to reactivate audio session: \(error)")
    }
  }
}
