//
//  GDTInterstitial.m
//  flutter_gdt_plugin
//
//  Created by 王贺天 on 2018/12/22.
//
// 广点通插屏广告

#import "GDTInterstitial.h"
#import "FlutterGdtPlugin.h"
@interface GDTInterstitial()<GDTMobInterstitialDelegate>
@property (nonatomic, strong) GDTMobInterstitial *interstitial;
@end
@implementation GDTInterstitial{
    NSString *_placementId;
    NSString *_tag;
}

- (instancetype) initWithPlacementId:(NSString *)placementId tag:(NSString *)tag{
    self = [super init];
    if (self) {
//        self.tag = placementId;
        _placementId = placementId;
        _tag = tag;
        [self loadAd];
    }
    return self;
}

- (void)loadAd {
    if(self.interstitial) {
        self.interstitial.delegate = nil;
    }
    self.interstitial = [[GDTMobInterstitial alloc] initWithAppId:[GDTConfig.sharedInstance appid] placementId:_placementId];
    self.interstitial.delegate = self;
    //预加载广告
    [self.interstitial loadAd];
}

- (void)showAd
{
    [self.interstitial presentFromRootViewController:[UIApplication sharedApplication].delegate.window.rootViewController];
}

#pragma mark - GDTMobInterstitialDelegate
// 广告预加载成功回调
//
// 详解:当接收服务器返回的广告数据成功后调用该函数
- (void)interstitialSuccessToLoadAd:(GDTMobInterstitial *)interstitial
{
    [self showAd];
    NSLog(@"interstitialSuccessToLoadAd");
    [pluginChannel invokeMethod:@"interstitialSuccessToLoadAd" arguments:@{@"tag": _tag}];
}

// 广告预加载失败回调
//
// 详解:当接收服务器返回的广告数据失败后调用该函数
- (void)interstitialFailToLoadAd:(GDTMobInterstitial *)interstitial error:(NSError *)error
{
    NSLog(@"interstitialFailToLoadAd");
    [pluginChannel invokeMethod:@"interstitialFailToLoadAd" arguments:@{@"error": @{
                                                                @"msg": error.localizedDescription,
                                                                @"code": @(error.code),
                                                                }, @"tag": _tag}];
}

// 插屏广告将要展示回调
//
// 详解: 插屏广告即将展示回调该函数
- (void)interstitialWillPresentScreen:(GDTMobInterstitial *)interstitial
{
    NSLog(@"interstitialWillPresentScreen");
    [pluginChannel invokeMethod:@"interstitialWillPresentScreen" arguments:@{@"tag": _tag}];
}

// 插屏广告视图展示成功回调
//
// 详解: 插屏广告展示成功回调该函数
- (void)interstitialDidPresentScreen:(GDTMobInterstitial *)interstitial
{
    NSLog(@"interstitialDidPresentScreen");
    [pluginChannel invokeMethod:@"interstitialDidPresentScreen" arguments:@{@"tag": _tag}];
}

// 插屏广告展示结束回调
//
// 详解: 插屏广告展示结束回调该函数
- (void)interstitialDidDismissScreen:(GDTMobInterstitial *)interstitial
{
    self.interstitial = nil;
    [FlutterGdtPlugin.sharedInstance removeGDTInterstitial];
    NSLog(@"interstitialDidDismissScreen");
    [pluginChannel invokeMethod:@"interstitialDidDismissScreen" arguments:@{@"tag": _tag}];
}

// 应用进入后台时回调
//
// 详解: 当点击下载应用时会调用系统程序打开，应用切换到后台
- (void)interstitialApplicationWillEnterBackground:(GDTMobInterstitial *)interstitial
{
    NSLog(@"interstitialApplicationWillEnterBackground");
    [pluginChannel invokeMethod:@"interstitialApplicationWillEnterBackground" arguments:@{@"tag": _tag}];
}

@end
