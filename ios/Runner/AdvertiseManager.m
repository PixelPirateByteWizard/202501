// AdvertiseManager.m
#import "AdvertiseManager.h"
#import <Flutter/Flutter.h>
#import "Runner-Swift.h"
#import <UMCommon/UMCommon.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h>

@implementation AdvertiseManager

NSString* const kInterstitialUnitID = @"n1gb5b3jhqmn5s";
NSString* const kBannerUnitID = @"n1gb5b3jhqmbva";
NSString* const kRewardUnitID = @"n1gb5b3jhqn0ed";
NSString* const kAnalyticsAppKey = @"67d4218065c707471a1bde5c";
NSString* const kDistributionChannel = @"App Store";
NSString* const kInterstitialUnitID1 = @"n1gb5b3jhqn4b9";
NSString* const kInterstitialUnitID2 = @"n1gb5b3jhqmqqr";
NSString* const kInterstitialUnitID3 = @"n1gb5b3jhqn8f3";
NSString* const kRewardUnitID1 = @"n1gb5b3jhqmtk1";
NSString* const kRewardUnitID2 = @"n1gb5b3jhqnc82";
NSString* const kRewardUnitID3 = @"n1gb5b3jhqngls";
NSDate *lastAdFetchTimestamp;
BOOL isRewardGranted = NO;

+ (void)initializeAdServices {
    [UMConfigure initWithAppkey:kAnalyticsAppKey channel:kDistributionChannel];
    
    if (@available(iOS 14, *)) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self fetchAdvertisements];
                });
            }];
        });
    } else {
        [self fetchAdvertisements];
    }
}

+ (instancetype)sharedManager {
    static AdvertiseManager *manager = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

+ (void)fetchAdvertisements {
    [[ATAPI sharedInstance] startWithAppID:@"h67d420cd589f5" appKey:@"a87eb5b63568bffaf029f8a276391b4bb" error:nil];
    
    // Load interstitial
    [[ATAdManager sharedManager] loadADWithPlacementID:kInterstitialUnitID extra:nil delegate:[[self sharedManager] self]];
    
    // Load reward video
    [[ATAdManager sharedManager] loadADWithPlacementID:kRewardUnitID extra:nil delegate:[[self sharedManager] self]];
    
    // Configure banner size
    CGSize adDimensions = CGSizeMake([UIScreen mainScreen].bounds.size.width, ([UIScreen mainScreen].bounds.size.width * 50)/320);
    NSDictionary *bannerConfig = @{kATAdLoadingExtraBannerAdSizeKey : [NSValue valueWithCGSize:adDimensions]};
    [[ATAdManager sharedManager] loadADWithPlacementID:kBannerUnitID extra:bannerConfig delegate:[[self sharedManager] self]];
    
    lastAdFetchTimestamp = [NSDate date];
}

+ (void)loadOtherAd {
    
    // Load interstitial1
    [[ATAdManager sharedManager] loadADWithPlacementID:kInterstitialUnitID1 extra:nil delegate:[[self sharedManager] self]];
    // Load interstitial2
    [[ATAdManager sharedManager] loadADWithPlacementID:kInterstitialUnitID2 extra:nil delegate:[[self sharedManager] self]];
    // Load interstitial3
    [[ATAdManager sharedManager] loadADWithPlacementID:kInterstitialUnitID3 extra:nil delegate:[[self sharedManager] self]];
    
    // Load reward video1
    [[ATAdManager sharedManager] loadADWithPlacementID:kRewardUnitID1 extra:nil delegate:[[self sharedManager] self]];
    // Load reward video2
    [[ATAdManager sharedManager] loadADWithPlacementID:kRewardUnitID2 extra:nil delegate:[[self sharedManager] self]];
    // Load reward video3
    [[ATAdManager sharedManager] loadADWithPlacementID:kRewardUnitID3 extra:nil delegate:[[self sharedManager] self]];
    
}

+ (BOOL)isAdCooldownElapsed {
    NSTimeInterval elapsed = [[NSDate date] timeIntervalSinceDate:lastAdFetchTimestamp];
    return elapsed > 15;
}

#pragma mark - ATBannerDelegate (名称恢复原始)
- (void)bannerView:(ATBannerView*)bannerView didShowAdWithPlacementID:(NSString*)placementID extra:(NSDictionary *)extra {}

- (void)bannerView:(ATBannerView*)bannerView didClickWithPlacementID:(NSString*)placementID extra:(NSDictionary *)extra{}

- (void)bannerView:(ATBannerView*)bannerView didAutoRefreshWithPlacement:(NSString*)placementID extra:(NSDictionary *)extra {}

- (void)bannerView:(ATBannerView *)bannerView failedToAutoRefreshWithPlacementID:(NSString *)placementID error:(NSError *)error {}

- (void)bannerView:(ATBannerView*)bannerView didTapCloseButtonWithPlacementID:(NSString*)placementID extra:(NSDictionary*)extra {}

- (void)bannerView:(ATBannerView *)bannerView didDeepLinkOrJumpForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra result:(BOOL)success {}

#pragma mark - ATAdLoadingDelegate (名称恢复原始)
- (void)didFinishLoadingADWithPlacementID:(NSString *)placementID {}

- (void)didFailToLoadADWithPlacementID:(NSString*)placementID error:(NSError*)error {}

#pragma mark - ATRewardedVideoDelegate (名称恢复原始)
- (void)rewardedVideoDidRewardSuccessForPlacemenID:(NSString *)placementID extra:(NSDictionary *)extra {
    if(placementID==kRewardUnitID)
        isRewardGranted = YES;
}

- (void)rewardedVideoDidStartPlayingForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {}

- (void)rewardedVideoDidEndPlayingForPlacementID:(NSString*)placementID extra:(NSDictionary *)extra {}

- (void)rewardedVideoDidFailToPlayForPlacementID:(NSString*)placementID error:(NSError*)error extra:(NSDictionary *)extra {
    if(placementID==kRewardUnitID)
        [self.class _notifyIncentiveFailure];
}

- (void)rewardedVideoDidCloseForPlacementID:(NSString*)placementID rewarded:(BOOL)rewarded extra:(NSDictionary *)extra {
    if(placementID==kRewardUnitID)
    {
        [[ATAdManager sharedManager] loadADWithPlacementID:kRewardUnitID extra:nil delegate:self];
        isRewardGranted ? [self.class _notifyIncentiveComplete] : [self.class _notifyIncentiveFailure];
        isRewardGranted = NO;
    }
    else if(placementID==kRewardUnitID1)
        [[ATAdManager sharedManager] loadADWithPlacementID:kRewardUnitID1 extra:nil delegate:self];
    else if(placementID==kRewardUnitID2)
        [[ATAdManager sharedManager] loadADWithPlacementID:kRewardUnitID2 extra:nil delegate:self];
    else if(placementID==kRewardUnitID3)
        [[ATAdManager sharedManager] loadADWithPlacementID:kRewardUnitID3 extra:nil delegate:self];
}

- (void)rewardedVideoDidClickForPlacementID:(NSString*)placementID extra:(NSDictionary *)extra {}

- (void)rewardedVideoDidDeepLinkOrJumpForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra result:(BOOL)success {}

#pragma mark - 广告展示逻辑
+ (void)displayBannerAd {
    if ([self sharedManager].bannerContainer != nil) {
        [self sharedManager].bannerContainer.hidden = NO;
    } else {
        if ([[ATAdManager sharedManager] bannerAdReadyForPlacementID:kBannerUnitID]) {
            [self sharedManager].bannerContainer = [[ATAdManager sharedManager] retrieveBannerViewForPlacementID:kBannerUnitID];
            if ([self sharedManager].bannerContainer) {
                AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                UIViewController *rootVC = delegate.window.rootViewController;
                [self sharedManager].bannerContainer.delegate = [self sharedManager];
                [self sharedManager].bannerContainer.presentingViewController = rootVC;
                [rootVC.view addSubview:[self sharedManager].bannerContainer];
                // Layout constraints...
            }
        }
    }
}

+ (void)concealBannerAd {
    if ([self sharedManager].bannerContainer != nil) {
        [self sharedManager].bannerContainer.hidden = YES;
    }
}

+ (void)presentInterstitialAd {
    if ([[ATAdManager sharedManager] interstitialReadyForPlacementID:kInterstitialUnitID] && [self isAdCooldownElapsed]) {
        lastAdFetchTimestamp = [NSDate date];
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [[ATAdManager sharedManager] showInterstitialWithPlacementID:kInterstitialUnitID 
                                                         inViewController:delegate.window.rootViewController 
                                                                 delegate:[self sharedManager]];
    }
    else
    {
        // Load interstitial
        [[ATAdManager sharedManager] loadADWithPlacementID:kInterstitialUnitID extra:nil delegate:[[self sharedManager] self]];
    }
}

+ (void)presentInterstitialAd1 {
    if ([[ATAdManager sharedManager] interstitialReadyForPlacementID:kInterstitialUnitID1] && [self isAdCooldownElapsed]) {
        lastAdFetchTimestamp = [NSDate date];
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [[ATAdManager sharedManager] showInterstitialWithPlacementID:kInterstitialUnitID1
                                                         inViewController:delegate.window.rootViewController
                                                                 delegate:[self sharedManager]];
    }
    else
    {
        // Load interstitial
        [[ATAdManager sharedManager] loadADWithPlacementID:kInterstitialUnitID1 extra:nil delegate:[[self sharedManager] self]];
    }
}

+ (void)presentInterstitialAd2 {
    if ([[ATAdManager sharedManager] interstitialReadyForPlacementID:kInterstitialUnitID2] && [self isAdCooldownElapsed]) {
        lastAdFetchTimestamp = [NSDate date];
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [[ATAdManager sharedManager] showInterstitialWithPlacementID:kInterstitialUnitID2
                                                         inViewController:delegate.window.rootViewController
                                                                 delegate:[self sharedManager]];
    }
    else
    {
        // Load interstitial
        [[ATAdManager sharedManager] loadADWithPlacementID:kInterstitialUnitID2 extra:nil delegate:[[self sharedManager] self]];
    }
}

+ (void)presentInterstitialAd3 {
    if ([[ATAdManager sharedManager] interstitialReadyForPlacementID:kInterstitialUnitID3] && [self isAdCooldownElapsed]) {
        lastAdFetchTimestamp = [NSDate date];
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [[ATAdManager sharedManager] showInterstitialWithPlacementID:kInterstitialUnitID3
                                                         inViewController:delegate.window.rootViewController
                                                                 delegate:[self sharedManager]];
    }
    else
    {
        // Load interstitial
        [[ATAdManager sharedManager] loadADWithPlacementID:kInterstitialUnitID3 extra:nil delegate:[[self sharedManager] self]];
    }
}

+ (void)playIncentiveVideo {
    if ([[ATAdManager sharedManager] rewardedVideoReadyForPlacementID:kRewardUnitID]) {
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        isRewardGranted = NO;
        [[ATAdManager sharedManager] showRewardedVideoWithPlacementID:kRewardUnitID 
                                                                    config:nil 
                                                          inViewController:delegate.window.rootViewController 
                                                                 delegate:[self sharedManager]];
    } else {
        [[ATAdManager sharedManager] loadADWithPlacementID:kRewardUnitID extra:nil delegate:self];
        [self _notifyIncentiveFailure];
    }
}

+ (void)playIncentiveVideo1 {
    if ([[ATAdManager sharedManager] rewardedVideoReadyForPlacementID:kRewardUnitID1]) {
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [[ATAdManager sharedManager] showRewardedVideoWithPlacementID:kRewardUnitID1
                                                                    config:nil
                                                          inViewController:delegate.window.rootViewController
                                                                 delegate:[self sharedManager]];
    } else {
        [[ATAdManager sharedManager] loadADWithPlacementID:kRewardUnitID1 extra:nil delegate:self];
    }
}

+ (void)playIncentiveVideo2 {
    if ([[ATAdManager sharedManager] rewardedVideoReadyForPlacementID:kRewardUnitID2]) {
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [[ATAdManager sharedManager] showRewardedVideoWithPlacementID:kRewardUnitID2
                                                                    config:nil
                                                          inViewController:delegate.window.rootViewController
                                                                 delegate:[self sharedManager]];
    } else {
        [[ATAdManager sharedManager] loadADWithPlacementID:kRewardUnitID2 extra:nil delegate:self];
    }
}

+ (void)playIncentiveVideo3 {
    if ([[ATAdManager sharedManager] rewardedVideoReadyForPlacementID:kRewardUnitID3]) {
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [[ATAdManager sharedManager] showRewardedVideoWithPlacementID:kRewardUnitID3
                                                                    config:nil
                                                          inViewController:delegate.window.rootViewController
                                                                 delegate:[self sharedManager]];
    } else {
        [[ATAdManager sharedManager] loadADWithPlacementID:kRewardUnitID3 extra:nil delegate:self];
    }
}

#pragma mark - Flutter通信
+ (void)_notifyIncentiveComplete {
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate sendEventToFlutterWithEventName:@"incentiveVideoCompleted" data:nil];
}

+ (void)_notifyIncentiveFailure {
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate sendEventToFlutterWithEventName:@"incentiveVideoFailed" data:nil];
}

@end
