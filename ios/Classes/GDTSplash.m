//
//  GDTSplash.m
//  flutter_gdt_plugin
//
//  Created by 王贺天 on 2018/12/22.
//

#import "GDTSplash.h"
#import "FlutterGdtPlugin.h"
@interface GDTSplash () <GDTSplashAdDelegate>

@property (nonatomic, strong) GDTSplashAd *splashAd;
@property (nonatomic, strong) UIView *bottomView;

@end
@implementation GDTSplash{
    NSString *_placementId;
    NSString *_tag;
}

- (instancetype) initWithPlacementId:(NSString *)placementId tag:(NSString *)tag{
    self = [super init];
    if (self) {
        _placementId = placementId;
        _tag = tag;
        [self loadAd];
    }
    return self;
}

- (void) loadAd
{
    self.splashAd = [[GDTSplashAd alloc] initWithAppId:[GDTConfig.sharedInstance appid] placementId:_placementId];
    self.splashAd.delegate = self;
    self.splashAd.fetchDelay = 5;
    
    // 在这里更换c开屏背景
    UIImage *splashImage = [UIImage imageNamed:@"SplashNormal"];
    if (IS_IPHONEX) {
        splashImage = [UIImage imageNamed:@"SplashX"];
    } else if ([UIScreen mainScreen].bounds.size.height == 480) {
        splashImage = [UIImage imageNamed:@"SplashSmall"];
    }
    self.splashAd.backgroundImage = splashImage;
    
    // 底部布局
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height * 0.25)];
    self.bottomView.backgroundColor = [UIColor whiteColor];
    UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SplashLogo"]];
    logo.frame = CGRectMake(0, 0, 311, 47);
    logo.center = self.bottomView.center;
    [self.bottomView addSubview:logo];
    UIWindow *fK = [[UIApplication sharedApplication] keyWindow];
    [self.splashAd loadAdAndShowInWindow:fK withBottomView:self.bottomView skipView:nil];
}

/**
 *  开屏广告成功展示
 */
- (void)splashAdSuccessPresentScreen:(GDTSplashAd *)splashAd
{
    NSLog(@"splashAdSuccessPresentScreen");
    [[FlutterGdtPlugin sharedInstance].channel invokeMethod:@"splashAdSuccessPresentScreen" arguments:@{@"tag": _tag}];
}

/**
 *  开屏广告展示失败
 */
- (void)splashAdFailToPresent:(GDTSplashAd *)splashAd withError:(NSError *)error
{
    NSLog(@"splashAdFailToPresent");
    [[FlutterGdtPlugin sharedInstance].channel invokeMethod:@"splashAdFailToPresent" arguments:@{@"error": @{
                                                                @"msg": error.localizedDescription,
                                                                @"code": @(error.code),
                                                                }, @"tag": _tag}];
}

/**
 *  应用进入后台时回调
 *  详解: 当点击下载应用时会调用系统程序打开，应用切换到后台
 */
- (void)splashAdApplicationWillEnterBackground:(GDTSplashAd *)splashAd
{
    NSLog(@"splashAdApplicationWillEnterBackground");
    [[FlutterGdtPlugin sharedInstance].channel invokeMethod:@"splashAdApplicationWillEnterBackground" arguments:@{@"tag": _tag}];
}

/**
 *  开屏广告曝光回调
 */
- (void)splashAdExposured:(GDTSplashAd *)splashAd
{
    NSLog(@"splashAdExposured");
    [[FlutterGdtPlugin sharedInstance].channel invokeMethod:@"splashAdExposured" arguments:@{@"tag": _tag}];
}

/**
 *  开屏广告点击回调
 */
- (void)splashAdClicked:(GDTSplashAd *)splashAd
{
    NSLog(@"splashAdClicked");
    [[FlutterGdtPlugin sharedInstance].channel invokeMethod:@"splashAdClicked" arguments:@{@"tag": _tag}];
}

/**
 *  开屏广告将要关闭回调
 */
- (void)splashAdWillClosed:(GDTSplashAd *)splashAd
{
    NSLog(@"splashAdWillClosed");
    self.splashAd = nil;
    [FlutterGdtPlugin.sharedInstance removeGDTShlash];
    [[FlutterGdtPlugin sharedInstance].channel invokeMethod:@"splashAdWillClosed" arguments:@{@"tag": _tag}];
}

/**
 *  开屏广告关闭回调
 */
- (void)splashAdClosed:(GDTSplashAd *)splashAd
{
    NSLog(@"splashAdClosed");
    [[FlutterGdtPlugin sharedInstance].channel invokeMethod:@"splashAdClosed" arguments:@{@"tag": _tag}];
}

/**
 *  开屏广告点击以后即将弹出全屏广告页
 */
- (void)splashAdWillPresentFullScreenModal:(GDTSplashAd *)splashAd
{
    NSLog(@"splashAdWillPresentFullScreenModal");
    [[FlutterGdtPlugin sharedInstance].channel invokeMethod:@"splashAdWillPresentFullScreenModal" arguments:@{@"tag": _tag}];
}

/**
 *  开屏广告点击以后弹出全屏广告页
 */
- (void)splashAdDidPresentFullScreenModal:(GDTSplashAd *)splashAd
{
    NSLog(@"splashAdDidPresentFullScreenModal");
    [[FlutterGdtPlugin sharedInstance].channel invokeMethod:@"splashAdDidPresentFullScreenModal" arguments:@{@"tag": _tag}];
}

/**
 *  点击以后全屏广告页将要关闭
 */
- (void)splashAdWillDismissFullScreenModal:(GDTSplashAd *)splashAd
{
    NSLog(@"splashAdWillDismissFullScreenModal");
    [[FlutterGdtPlugin sharedInstance].channel invokeMethod:@"splashAdWillDismissFullScreenModal" arguments:@{@"tag": _tag}];
}

/**
 *  点击以后全屏广告页已经关闭
 */
- (void)splashAdDidDismissFullScreenModal:(GDTSplashAd *)splashAd
{
    NSLog(@"splashAdDidDismissFullScreenModal");
    [[FlutterGdtPlugin sharedInstance].channel invokeMethod:@"splashAdDidDismissFullScreenModal" arguments:@{@"tag": _tag}];
}

/**
 * 开屏广告剩余时间回调
 */
- (void)splashAdLifeTime:(NSUInteger)time
{
    NSLog(@"splashAdLifeTime ----> %ld", time);
    [[FlutterGdtPlugin sharedInstance].channel invokeMethod:@"splashAdLifeTime" arguments:@{@"time": @(time), @"tag": _tag}];
}

@end
