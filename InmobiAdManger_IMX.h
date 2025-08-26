//
//  InmobiAdManger_IMX.h
//  Obfuscated Variant
//

@import InMobiSDK;
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// 说明：
// - 为降低相似度，外部可调用方法已做前后缀混淆。
// - 按需替换原始引用方的调用名以使用本文件声明的接口。
// - 标注为“delegate 区域”的方法名不可修改，已在 .m 中保持原样实现。

@interface InmobiAdManger : NSObject<IMBannerDelegate,IMInterstitialDelegate>

// 混淆后的公共接口（替代原接口）
+ (instancetype)imx_sharedInstanceToken;
+ (void)imx_configureInmobiBootstrap;

+ (void)showInmobiBannerAd; // 保持不变：delegate 区域中会调用
+ (void)imx_hideBannerSlot; // 原 hideInmobiBannerAd

+ (void)imx_presentTopInterstitial; // 原 showInmobiInterstitialAd
+ (void)imx_presentRewardedBridge;  // 原 showInmobiRewardedAd
+ (bool)imx_hasRewardInventory;     // 原 hasInmobiRewardedAd

// 导航切换完成后调用，按规则尝试展示插页
// 规则：启动后前120秒不展示；展示间隔需>=15秒
+ (void)imx_requestInterstitialOnNavSwitch;

// 展示激励视频并通过回调返回是否获得奖励（YES=获得奖励）
+ (void)imx_presentRewardedWithCompletion:(void(^)(BOOL watched))completion;

// 测试模式：无视时间与间隔规则强制展示插页
+ (void)imx_forcePresentTopInterstitial;

@end

NS_ASSUME_NONNULL_END


