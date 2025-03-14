// AdvertiseManager.h
#import <Foundation/Foundation.h>
#import <AnyThinkSDK/AnyThinkSDK.h>
#import <AnyThinkInterstitial/AnyThinkInterstitial.h>
#import <AnyThinkBanner/AnyThinkBanner.h>
#import <AnyThinkRewardedVideo/AnyThinkRewardedVideo.h>

NS_ASSUME_NONNULL_BEGIN

@interface AdvertiseManager : NSObject<ATInterstitialDelegate, ATBannerDelegate, ATAdLoadingDelegate, ATRewardedVideoDelegate>

@property(nonatomic, strong) ATBannerView *bannerContainer;
+ (instancetype)sharedManager;
+ (void)initializeAdServices;
+ (void)fetchAdvertisements;
+ (void)displayBannerAd;
+ (void)concealBannerAd;
+ (void)presentInterstitialAd;
+ (void)playIncentiveVideo;
+ (void)loadOtherAd;
+ (void)presentInterstitialAd1;
+ (void)presentInterstitialAd2;
+ (void)presentInterstitialAd3;
+ (void)playIncentiveVideo1;
+ (void)playIncentiveVideo2;
+ (void)playIncentiveVideo3;

@end

NS_ASSUME_NONNULL_END
