//
//  GDTSplash.m
//  flutter_gdt_plugin
//
//  Created by 王贺天 on 2018/12/22.
//

#import "GDTSplash.h"
#import "FlutterPluginCache.h"

@implementation GDTSplash{
    NSObject<FlutterBinaryMessenger>*_messenger;
    NSObject<FlutterPluginRegistrar>*_registrar;
    FlutterMethodChannel *_methodChannel;
    GDTSplashAd *_splashAd;
    UIView *_bottomView;
}

- (instancetype) initWithMessenger:(NSObject<FlutterPluginRegistrar>*)registrar{
    self = [super init];
    if (self) {
        _messenger = registrar.messenger;
        _registrar = registrar;
    }
    return self;
}

- (void) show:(NSDictionary *)args result:(FlutterResult)result
{
    NSString *posId = args[@"posId"];
    _splashAd = [[GDTSplashAd alloc] initWithAppId:[GDTConfig sharedInstance].appid placementId:posId];
    _splashAd.delegate = self;
    _splashAd.fetchDelay = 3;
    _splashAd.backgroundColor = [UIColor clearColor];
    
    if ([args[@"has_footer"] boolValue]) {
        NSString* key = [_registrar lookupKeyForAsset:[args objectForKey:@"logo_name"]];
        NSString* path = [[NSBundle mainBundle] pathForResource:key ofType:nil];
        UIImage *logoImg=[UIImage imageWithData:[[NSData alloc] initWithContentsOfFile:path]];
        CGFloat footerHeight = logoImg.size.height / 3;
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, footerHeight)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        UIImageView *logo = [[UIImageView alloc] initWithImage:logoImg];
        logo.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, footerHeight - 24.0);
        logo.center = _bottomView.center;
        logo.contentMode = UIViewContentModeScaleAspectFit;
        
        [_bottomView addSubview:logo];
    }
    NSString *uuid = [GDTConfig createUUID];
    NSString *channelName = [NSString stringWithFormat:@"plugins.hetian.me/gdt_plugins/shlash/%@", uuid];
    _methodChannel = [FlutterMethodChannel methodChannelWithName:channelName binaryMessenger:_messenger];
    result(@{@"channel_name":channelName});
    UIWindow *fK = [[UIApplication sharedApplication] keyWindow];
    [_splashAd loadAdAndShowInWindow:fK withBottomView:_bottomView];
}

/**
 *  开屏广告成功展示
 */
- (void)splashAdSuccessPresentScreen:(GDTSplashAd *)splashAd
{
    [_methodChannel invokeMethod:@"onADPresent" arguments:@""];
}

/**
 *  开屏广告展示失败
 */
- (void)splashAdFailToPresent:(GDTSplashAd *)splashAd withError:(NSError *)error
{
    [_methodChannel invokeMethod:@"onNoAD" arguments:@{
                                                       @"code": @(error.code),
                                                       @"msg": error.localizedDescription,
                                                       }];
}

/**
 *  应用进入后台时回调
 *  详解: 当点击下载应用时会调用系统程序打开，应用切换到后台
 */
- (void)splashAdApplicationWillEnterBackground:(GDTSplashAd *)splashAd
{
    
}

/**
 *  开屏广告曝光回调
 */
- (void)splashAdExposured:(GDTSplashAd *)splashAd
{
    [_methodChannel invokeMethod:@"onADExposure" arguments:@""];
}

/**
 *  开屏广告点击回调
 */
- (void)splashAdClicked:(GDTSplashAd *)splashAd
{
    [_methodChannel invokeMethod:@"onADClicked" arguments:@""];
}

/**
 *  开屏广告将要关闭回调
 */
- (void)splashAdWillClosed:(GDTSplashAd *)splashAd
{
    
}

/**
 *  开屏广告关闭回调
 */
- (void)splashAdClosed:(GDTSplashAd *)splashAd
{
    [_methodChannel invokeMethod:@"onADDismissed" arguments:@""];
    _splashAd = NULL;
    _bottomView = NULL;
    [FlutterPluginCache sharedInstance].splash = NULL;
}

/**
 *  开屏广告点击以后即将弹出全屏广告页
 */
- (void)splashAdWillPresentFullScreenModal:(GDTSplashAd *)splashAd
{
    
}

/**
 *  开屏广告点击以后弹出全屏广告页
 */
- (void)splashAdDidPresentFullScreenModal:(GDTSplashAd *)splashAd
{
    
}

/**
 *  点击以后全屏广告页将要关闭
 */
- (void)splashAdWillDismissFullScreenModal:(GDTSplashAd *)splashAd
{
    
}

/**
 *  点击以后全屏广告页已经关闭
 */
- (void)splashAdDidDismissFullScreenModal:(GDTSplashAd *)splashAd
{
    
}

/**
 * 开屏广告剩余时间回调
 */
- (void)splashAdLifeTime:(NSUInteger)time
{
    [_methodChannel invokeMethod:@"onADTick" arguments:@{@"millisUntilFinished": @(time)}];
}


@end
