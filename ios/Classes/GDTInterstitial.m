//
//  GDTInterstitial.m
//  flutter_gdt_plugin
//
//  Created by 王贺天 on 2018/12/22.
//
// 广点通插屏广告

#import "GDTInterstitial.h"

#import "FlutterGdtPlugin.h"
#import "FlutterPluginCache.h"

@implementation GDTInterstitial
{
    FlutterMethodChannel *_methodChannel;
    Boolean isOk;
    NSString *_uuid;
}

+ (NSString *)createNew:(NSDictionary *)args
{
    NSString *uuid = [GDTConfig createUUID];
    [[FlutterPluginCache sharedInstance].interstitila setValue:[[GDTInterstitial alloc] initWithMessenger:uuid args:args] forKey:uuid];
    return uuid;
}

+ (NSString *)getChannelName:(NSString *)uuid
{
    NSString *channelName = [NSString stringWithFormat:@"plugins.hetian.me/gdt_plugins/interstitial/%@", uuid];
    return channelName;
}

- (instancetype)initWithMessenger:(NSString *)uuid args:(NSDictionary *)args
{
    self = [super init];
    if (self) {
        isOk = NO;
        _uuid = uuid;
        NSString *channelName = [GDTInterstitial getChannelName:uuid];
        _methodChannel = [FlutterMethodChannel methodChannelWithName:channelName binaryMessenger:[FlutterGdtPlugin sharedInstance].registrar.messenger];
        __weak __typeof__(self) weakSelf = self;
        [_methodChannel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result){
            [weakSelf onMethodCall:call result: result];
        }];
        
        NSString *posId = args[@"posId"];
        self.interstitial = [[GDTUnifiedInterstitialAd alloc] initWithAppId:[GDTConfig sharedInstance].appid placementId:posId];
        self.interstitial.delegate = self;
    }
    return self;
}

- (void)load:(FlutterResult)result {
    //预加载广告
    [self.interstitial loadAd];
    result(@(true));
}

- (void)show:(FlutterResult)result {
    if (isOk) {
        [self.interstitial presentAdFromRootViewController:UIApplication.sharedApplication.keyWindow.rootViewController];
        result(@(true));
    }else{
        result(@(false));
    }
}

- (void)destroy
{
    [[FlutterPluginCache sharedInstance].interstitila removeObjectForKey:_uuid];
}

- (void)onMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result
{
    if ([call.method isEqualToString:@"load"]) {
        [self load:result];
    } else if ([call.method isEqualToString:@"show"]) {
        [self show:result];
    } else if ([call.method isEqualToString:@"destroy"]) {
        [self destroy];
        result(@(true));
    } else {
        result(@(true));
    }
}

#pragma mark - GDTUnifiedInterstitialAdDelegate
/**
 *  插屏2.0广告预加载成功回调
 *  当接收服务器返回的广告数据成功且预加载后调用该函数
 */
- (void)unifiedInterstitialSuccessToLoadAd:(GDTUnifiedInterstitialAd *)unifiedInterstitial
{
    isOk = YES;
    [_methodChannel invokeMethod:@"onADReceive" arguments:@""];
}

/**
 *  插屏2.0广告预加载失败回调
 *  当接收服务器返回的广告数据失败后调用该函数
 */
- (void)unifiedInterstitialFailToLoadAd:(GDTUnifiedInterstitialAd *)unifiedInterstitial error:(NSError *)error
{
    [_methodChannel invokeMethod:@"onNoAD" arguments:@{
                                                       @"code": @(error.code),
                                                       @"msg": error.localizedDescription,
                                                       }];
}

/**
 *  插屏2.0广告将要展示回调
 *  插屏2.0广告即将展示回调该函数
 */
- (void)unifiedInterstitialWillPresentScreen:(GDTUnifiedInterstitialAd *)unifiedInterstitial
{
    
}

/**
 *  插屏2.0广告视图展示成功回调
 *  插屏2.0广告展示成功回调该函数
 */
- (void)unifiedInterstitialDidPresentScreen:(GDTUnifiedInterstitialAd *)unifiedInterstitial
{
    
}

/**
 *  插屏2.0广告展示结束回调
 *  插屏2.0广告展示结束回调该函数
 */
- (void)unifiedInterstitialDidDismissScreen:(GDTUnifiedInterstitialAd *)unifiedInterstitial
{
    [_methodChannel invokeMethod:@"onADClosed" arguments:@""];
}

/**
 *  当点击下载应用时会调用系统程序打开其它App或者Appstore时回调
 */
- (void)unifiedInterstitialWillLeaveApplication:(GDTUnifiedInterstitialAd *)unifiedInterstitial
{
    
}

/**
 *  插屏2.0广告曝光回调
 */
- (void)unifiedInterstitialWillExposure:(GDTUnifiedInterstitialAd *)unifiedInterstitial
{
    [_methodChannel invokeMethod:@"onADExposure" arguments:@""];
}

/**
 *  插屏2.0广告点击回调
 */
- (void)unifiedInterstitialClicked:(GDTUnifiedInterstitialAd *)unifiedInterstitial
{
    [_methodChannel invokeMethod:@"onADClicked" arguments:@""];
}

/**
 *  点击插屏2.0广告以后即将弹出全屏广告页
 */
- (void)unifiedInterstitialAdWillPresentFullScreenModal:(GDTUnifiedInterstitialAd *)unifiedInterstitial
{
    
}

/**
 *  点击插屏2.0广告以后弹出全屏广告页
 */
- (void)unifiedInterstitialAdDidPresentFullScreenModal:(GDTUnifiedInterstitialAd *)unifiedInterstitial
{
    [_methodChannel invokeMethod:@"onADLeftApplication" arguments:@""];
}

/**
 *  全屏广告页将要关闭
 */
- (void)unifiedInterstitialAdWillDismissFullScreenModal:(GDTUnifiedInterstitialAd *)unifiedInterstitial
{
    
}

/**
 *  全屏广告页被关闭
 */
- (void)unifiedInterstitialAdDidDismissFullScreenModal:(GDTUnifiedInterstitialAd *)unifiedInterstitial
{
    
}


@end
