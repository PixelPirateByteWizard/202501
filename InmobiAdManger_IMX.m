//
//  InmobiAdManger_IMX.m
//  Obfuscated Variant
//

#import <Foundation/Foundation.h>
#import "InmobiAdManger_IMX.h"
#import "Runner-Swift.h"
#import <Flutter/Flutter.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h>

@implementation InmobiAdManger

NSDate *imxLastInterstitialShowTime;

IMBanner *imxBannerView;
UIView *imxContainerView;

IMInterstitial *imxInterstitial;

IMInterstitial *imxRewardedInter;

static BOOL imxRewardEarnedCurrentShow = NO;

NSString* imxAccountIDKey = @"9be3fdc815c547cfa39c2cb870b6d1a9";

int64_t imxBannerPlacementId = 10000463802;

int64_t imxInterstitialPlacementId = 10000463800;

int64_t imxRewardedPlacementId = 10000463804;

+ (void) imx_bootstrapInitCore
{
    void (^completionBlock)(NSError*) = ^( NSError* _Nullable  error) {
        if (error) {
            NSLog(@"SDK Initialization Error - %@", error.description);
        }
        else {
            NSLog(@"IM Media SDK successfully initialized");
            //load ad
            // 1. 创建广告容器
            imxContainerView = [[UIView alloc] init];
            imxContainerView.translatesAutoresizingMaskIntoConstraints = NO;
            imxContainerView.backgroundColor = [UIColor clearColor];
            imxContainerView.clipsToBounds = YES;
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            UIViewController *rootVC = appDelegate.window.rootViewController;
            [rootVC.view addSubview:imxContainerView];
            
            // 2. 设置容器约束（底部居中）
            [InmobiAdManger imx_setupBannerContainerLayout];
            
            // 3. 初始化横幅广告
            CGFloat adWidth = 320;
            CGFloat adHeight = 50;
            imxBannerView = [[IMBanner alloc] initWithFrame:CGRectMake(0, 0, adWidth, adHeight)
                                               placementId:imxBannerPlacementId];
            imxBannerView.delegate = InmobiAdManger.imx_sharedInstanceToken;
            [imxContainerView addSubview:imxBannerView];
            imxContainerView.hidden = YES; // 初始化保持隐藏
            
            // 4. 加载广告
            [imxBannerView load];
            
            // 加载插页广告
            imxInterstitial = [[IMInterstitial alloc] initWithPlacementId:imxInterstitialPlacementId];
            imxInterstitial.delegate = InmobiAdManger.imx_sharedInstanceToken;
            [imxInterstitial load];
            
            
            // 加载激励视频广告
            imxRewardedInter = [[IMInterstitial alloc] initWithPlacementId:imxRewardedPlacementId];
            imxRewardedInter.delegate = InmobiAdManger.imx_sharedInstanceToken;
            [imxRewardedInter load];
        }
    };
    [IMSdk setLogLevel:IMSDKLogLevelError];
    [IMSdk initWithAccountID:imxAccountIDKey consentDictionary:@{IMCommonConstants.IM_GDPR_CONSENT_AVAILABLE: @"true", IMCommonConstants.IM_GDPR_CONSENT_IAB: @"<<consent format=\"\" iab=\"\" in=\"\">>"} andCompletionHandler:completionBlock];
}

#pragma mark - 展示激励视频广告（混淆接口）
+ (void)imx_presentRewardedBridge {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIViewController *rootVC = appDelegate.window.rootViewController;
    if (imxRewardedInter.isReady) {
        [imxRewardedInter showFrom:rootVC];
    } else {
        NSLog(@"最高价激励视频广告尚未准备好");
        [imxRewardedInter load];
        [InmobiAdManger _onRewardVideoFailed];
    }
}

// 带完成回调的激励视频展示，watched=YES 表示获得奖励
+ (void)imx_presentRewardedWithCompletion:(void(^)(BOOL watched))completion {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIViewController *rootVC = appDelegate.window.rootViewController;
    if (imxRewardedInter.isReady) {
        NSLog(@"[InMobi] 条件满足，展示激励视频");
        // 临时代理包装：使用通知回传观看结果
        __block id token1 = nil;
        __block id token2 = nil;
        token1 = [[NSNotificationCenter defaultCenter] addObserverForName:@"IMX_REWARD_WATCHED" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
            [[NSNotificationCenter defaultCenter] removeObserver:token1];
            [[NSNotificationCenter defaultCenter] removeObserver:token2];
            if (completion) completion(YES);
        }];
        token2 = [[NSNotificationCenter defaultCenter] addObserverForName:@"IMX_REWARD_FAILED" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
            [[NSNotificationCenter defaultCenter] removeObserver:token1];
            [[NSNotificationCenter defaultCenter] removeObserver:token2];
            if (completion) completion(NO);
        }];
        // 会话内奖励标记复位
        imxRewardEarnedCurrentShow = NO;
        [imxRewardedInter showFrom:rootVC];
    } else {
        NSLog(@"[InMobi] 激励未就绪，尝试重新加载");
        [imxRewardedInter load];
        if (completion) completion(NO);
    }
}

+ (bool)imx_hasRewardInventory
{
    if (imxRewardedInter.isReady)//有一个加载成功就行
        return true;
    else
        return false;
}

+ (BOOL)imx_isInterstitialGapSatisfied{
  NSDate *now = [NSDate date];
  NSTimeInterval timeIntervalBetweenNowAndLoadTime = [now timeIntervalSinceDate:imxLastInterstitialShowTime];
  return timeIntervalBetweenNowAndLoadTime > 15;
}

static NSDate *imxAppStartTime;

// 导航切换完成后调用，按规则尝试展示插页（含中文日志）
+ (void)imx_requestInterstitialOnNavSwitch{
    if (imxAppStartTime == nil) {
        imxAppStartTime = [NSDate date];
    }
    NSDate *now = [NSDate date];
    NSTimeInterval sinceLaunch = [now timeIntervalSinceDate:imxAppStartTime];
    NSLog(@"[InMobi] 导航切换后触发插页判断，距离启动 %.0fs", sinceLaunch);

    // 规则1：启动后前 120 秒不展示
    if (sinceLaunch < 120) {
        NSLog(@"[InMobi] 启动前两分钟内不展示插页，已拦截");
        return;
    }

    // 规则2：间隔 15 秒
    if (![self imx_isInterstitialGapSatisfied]) {
        NSLog(@"[InMobi] 距离上次插页不足15秒，不展示");
        return;
    }

    // 切换后展示（若已准备）
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIViewController *rootVC = appDelegate.window.rootViewController;
    if (imxInterstitial.isReady) {
        NSLog(@"[InMobi] 条件满足，展示插页广告");
        [imxInterstitial showFrom:rootVC];
        imxLastInterstitialShowTime = [NSDate date];
    } else {
        NSLog(@"[InMobi] 插页未就绪，尝试重新加载");
        [imxInterstitial load];
    }
}

#pragma mark - 展示插页广告（混淆接口）
+ (void)imx_presentTopInterstitial{
    if([self imx_isInterstitialGapSatisfied])
    {
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        UIViewController *rootVC = appDelegate.window.rootViewController;
        if (imxInterstitial.isReady) {
            [imxInterstitial showFrom:rootVC];
            imxLastInterstitialShowTime = [NSDate date];
        } else {
            NSLog(@"最高价插页广告尚未准备好");
            [imxInterstitial load];
        }
    }
}

// 测试模式：无视时间与间隔规则强制展示插页
+ (void)imx_forcePresentTopInterstitial{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIViewController *rootVC = appDelegate.window.rootViewController;
    if (imxInterstitial.isReady) {
        NSLog(@"[InMobi] 测试模式：强制展示插页");
        [imxInterstitial showFrom:rootVC];
        imxLastInterstitialShowTime = [NSDate date];
    } else {
        NSLog(@"[InMobi] 测试模式：插页未就绪，尝试重新加载");
        [imxInterstitial load];
    }
}


//以下部分是inmobi的delegate函数，请不要修改函数名及变量名。
#pragma mark - IMInterstitialDelegate
- (void)interstitialDidFinishLoading:(IMInterstitial *)interstitial {
    NSLog(@"插页广告加载成功");
}

- (void)interstitial:(IMInterstitial *)interstitial didFailToLoadWithError:(IMRequestStatus *)error {
    NSLog(@"插页广告加载失败: %@", error.localizedDescription);
}

- (void)interstitialDidPresent:(IMInterstitial *)interstitial {
    NSLog(@"插页广告已展示");
}

- (void)interstitialDidDismiss:(IMInterstitial *)interstitial {
    NSLog(@"插页广告已关闭");
    // 如果关闭的是激励视频且本次未获得奖励，则回调失败
    if (interstitial == imxRewardedInter) {
        if (!imxRewardEarnedCurrentShow) {
            NSLog(@"[InMobi] 激励视频未观看完成或未获得奖励，触发失败回调");
            [InmobiAdManger _onRewardVideoFailed];
        }
        imxRewardEarnedCurrentShow = NO;
    }
    [interstitial load];
}

- (void)interstitial:(IMInterstitial *)interstitial didInteractWithParams:(NSDictionary *)params {
    NSLog(@"用户与插页广告进行了交互");
}

- (void)interstitial:(IMInterstitial *)interstitial rewardActionCompletedWithRewards:(NSDictionary *)rewards {
    NSLog(@"奖励动作完成: %@", rewards);
    if (interstitial == imxRewardedInter) {
        imxRewardEarnedCurrentShow = YES;
        NSLog(@"[InMobi] 激励视频已获得奖励");
        [InmobiAdManger _onRewardVideoWatched];
    }
}

- (void)userWillLeaveApplicationFromInterstitial:(IMInterstitial *)interstitial {
    NSLog(@"用户即将离开应用");
}

#pragma mark - IMBannerDelegate
- (void)bannerDidFinishLoading:(IMBanner *)banner {
    NSLog(@"广告加载成功");
    [InmobiAdManger centerAdInContainer];
    // 预加载完成后不自动显示，等待业务触发显示
}

- (void)banner:(IMBanner *)banner didFailToLoadWithError:(IMRequestStatus *)error {
    NSLog(@"广告加载失败: %@", error.localizedDescription);
}
///结束inmobi的delegate函数部分


+ (void)showInmobiBannerAd
{
    if(imxContainerView!=NULL){
        NSLog(@"[InMobi] 即将显示横幅广告容器");
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        UIViewController *topVC = appDelegate.window.rootViewController;
        while (topVC.presentedViewController) {
            topVC = topVC.presentedViewController;
        }
        UIView *targetView = topVC.view;
        if (imxContainerView.superview != targetView) {
            [imxContainerView removeFromSuperview];
            [targetView addSubview:imxContainerView];
            [InmobiAdManger imx_setupBannerContainerLayoutForView:targetView];
        }
        imxContainerView.hidden = NO;
        // 轻微延迟后再次附着到最新顶层VC，确保与弹窗同层级
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UIViewController *currentTop = appDelegate.window.rootViewController;
            while (currentTop.presentedViewController) {
                currentTop = currentTop.presentedViewController;
            }
            if (currentTop.view != imxContainerView.superview) {
                NSLog(@"[InMobi] 发现更顶层的呈现控制器，重新附着横幅容器");
                [imxContainerView removeFromSuperview];
                [currentTop.view addSubview:imxContainerView];
                [InmobiAdManger imx_setupBannerContainerLayoutForView:currentTop.view];
            }
        });
    }
}
+ (void)imx_hideBannerSlot
{
    if(imxContainerView!=NULL){
        NSLog(@"[InMobi] 即将隐藏横幅广告容器");
        imxContainerView.hidden = YES;
    }
}

#pragma mark - 设置广告容器约束（混淆名）
// 清理与横幅相关的旧约束，避免重复添加导致冲突
+ (void)imx_clearBannerConstraintsForView:(UIView *)parentView {
    NSMutableArray<NSLayoutConstraint *> *toDeactivate = [NSMutableArray array];
    for (NSLayoutConstraint *c in imxContainerView.constraints) {
        [toDeactivate addObject:c];
    }
    for (NSLayoutConstraint *c in parentView.constraints) {
        if (c.firstItem == imxContainerView || c.secondItem == imxContainerView) {
            [toDeactivate addObject:c];
        }
    }
    [NSLayoutConstraint deactivateConstraints:toDeactivate];
}

+ (void)imx_setupBannerContainerLayoutForView:(UIView *)parentView {
    CGFloat adWidth = 320;
    CGFloat adHeight = 50;
    imxContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    [InmobiAdManger imx_clearBannerConstraintsForView:parentView];
    [imxContainerView.heightAnchor constraintEqualToConstant:adHeight].active = YES;
    [imxContainerView.widthAnchor constraintEqualToConstant:adWidth].active = YES;
    [imxContainerView.centerXAnchor constraintEqualToAnchor:parentView.centerXAnchor].active = YES;
    if (@available(iOS 11.0, *)) {
        [imxContainerView.bottomAnchor constraintEqualToAnchor:parentView.safeAreaLayoutGuide.bottomAnchor].active = YES;
    } else {
        [imxContainerView.bottomAnchor constraintEqualToAnchor:parentView.bottomAnchor].active = YES;
    }
}

+ (void)imx_setupBannerContainerLayout {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIViewController *rootVC = appDelegate.window.rootViewController;
    [InmobiAdManger imx_setupBannerContainerLayoutForView:rootVC.view];
}

#pragma mark - 居中广告（名称保持不变，因 delegate 区域调用）
+ (void)centerAdInContainer {
    // 确保在主线程更新UI
    dispatch_async(dispatch_get_main_queue(), ^{
        CGFloat containerWidth = imxContainerView.frame.size.width;
        CGFloat containerHeight = imxContainerView.frame.size.height;
        CGFloat adWidth = imxBannerView.frame.size.width;
        CGFloat adHeight = imxBannerView.frame.size.height;
        
        // 计算居中位置
        CGFloat adX = (containerWidth - adWidth) / 2;
        CGFloat adY = (containerHeight - adHeight) / 2;
        
        // 更新广告位置
        imxBannerView.frame = CGRectMake(adX, adY, adWidth, adHeight);
    });
}

// OC 端回调 Flutter 视频观看完成（名称保持不变，因 delegate 区域调用）
+ (void)_onRewardVideoWatched {
    // 1. Get the AppDelegate instance (Corrected)
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    // 2. Call the Swift method (Corrected)
    if ([appDelegate respondsToSelector:@selector(sendEventToFlutterWithEventName:data:)]) {
        [appDelegate sendEventToFlutterWithEventName:@"onRewardVideoWatched" data:nil];
    } else {
        NSLog(@"AppDelegate does not respond to sendEventToFlutterWithEventName:data:");
    }
    // 中文日志与通知
    NSLog(@"[InMobi] 激励视频观看完成，发送成功回调");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"IMX_REWARD_WATCHED" object:nil];
}

// OC 端回调 Flutter 视频观看失败（名称保持不变，因外部逻辑调用）
+ (void)_onRewardVideoFailed {
    // 1. Get the AppDelegate instance (Corrected)
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    // 2. Call the Swift method (Corrected)
    if ([appDelegate respondsToSelector:@selector(sendEventToFlutterWithEventName:data:)]) {
        [appDelegate sendEventToFlutterWithEventName:@"onRewardVideoFailed" data:nil];
    } else {
        NSLog(@"AppDelegate does not respond to sendEventToFlutterWithEventName:data:");
    }
    // 中文日志与通知
    NSLog(@"[InMobi] 激励视频未获得奖励或失败，发送失败回调");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"IMX_REWARD_FAILED" object:nil];
}

+ (instancetype)imx_sharedInstanceToken {
    static InmobiAdManger *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

+ (void)imx_configureInmobiBootstrap{
    if (@available(iOS 14, *)) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
                dispatch_async(dispatch_get_main_queue(), ^{
                });
            }];
        });
    } else {
    }
    [InmobiAdManger imx_bootstrapInitCore];
    imxLastInterstitialShowTime = [NSDate date];
    imxAppStartTime = [NSDate date];
}

@end


