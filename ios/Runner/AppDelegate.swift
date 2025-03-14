// AppDelegate.swift
import Flutter
import UIKit
import AppTrackingTransparency

@main
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        AdvertiseManager.initializeAdServices()
        
        let controller = window?.rootViewController as! FlutterViewController
        let adChannel = FlutterMethodChannel(
            name: "transmodel/advertise",
            binaryMessenger: controller.binaryMessenger
        )
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
         if #available(iOS 14, *) {
             ATTrackingManager.requestTrackingAuthorization { status in
                 // 处理授权结果
             }
         }
     }

        
        adChannel.setMethodCallHandler { call, result in
            switch call.method {
            case "displayBannerAd":
                AdvertiseManager.displayBannerAd()
                result(nil)
            case "concealBannerAd":
                AdvertiseManager.concealBannerAd()
                result(nil)
            case "presentInterstitialAd":
                AdvertiseManager.presentInterstitialAd()
                result(nil)
            case "playIncentiveVideo":
                AdvertiseManager.playIncentiveVideo()
                result(nil)
            case "loadOtherAd":
                AdvertiseManager.loadOtherAd()
                result(nil)
            case "presentInterstitialAd1":
                AdvertiseManager.presentInterstitialAd1()
                result(nil)
            case "presentInterstitialAd2":
                AdvertiseManager.presentInterstitialAd2()
                result(nil)
            case "presentInterstitialAd3":
                AdvertiseManager.presentInterstitialAd3()
                result(nil)
            case "playIncentiveVideo1":
                AdvertiseManager.playIncentiveVideo1()
                result(nil)
            case "playIncentiveVideo2":
                AdvertiseManager.playIncentiveVideo2()
                result(nil)
            case "playIncentiveVideo3":
                AdvertiseManager.playIncentiveVideo3()
                result(nil)
            default:
                result(FlutterMethodNotImplemented)
            }
        }
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    @objc func sendEventToFlutter(eventName: String, data: Any?) {
        guard let controller = window?.rootViewController as? FlutterViewController else { return }
        let channel = FlutterMethodChannel(name: "transmodel/advertise", 
                                         binaryMessenger: controller.binaryMessenger)
        channel.invokeMethod(eventName, arguments: data)
    }
}
