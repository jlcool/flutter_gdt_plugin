//
//  GDTNativeExpress.m
//  flutter_gdt_plugin
//
//  Created by 王贺天 on 2018/12/21.
//

#import "GDTNativeExpress.h"

@implementation GDTNativeExpress{
    int64_t _vid;
    NSDictionary *_args;
//    GDTNativeExpressAd *nativeExpressAd;
}

- (instancetype)initWithFlutter:(NSDictionary *)args channel:(FlutterMethodChannel*)channel vid:(int64_t)vid
{
    self = [super init];
    if (self) {
        _args = args;
        _channel = channel;
        _vid = vid;
        [self loadad];
    }
    return self;
}

- (void)loadad
{
    self.nativeExpressAd = [[GDTNativeExpressAd alloc] initWithAppId:[GDTConfig.sharedInstance appid]
                                                    placementId: _args[@"placementId"]
                                                         adSize:CGSizeMake([_args[@"width"] floatValue], [_args[@"height"] floatValue])];
    self.nativeExpressAd.delegate = self;
    _nativeExpressAd.videoAutoPlayOnWWAN = _args[@"videoAutoPlayOnWWAN"];
    _nativeExpressAd.videoMuted = _args[@"videoMuted"];
    [self.nativeExpressAd loadAd:1];
}
#pragma mark - GDTNativeExpressAdDelegete
/**
 * 拉取原生模板广告成功
 */
- (void)nativeExpressAdSuccessToLoad:(GDTNativeExpressAd *)nativeExpressAd views:(NSArray<__kindof GDTNativeExpressAdView *> *)views
{
    NSLog(@"nativeExpressAdSuccessToLoad %@", views[0]);
    GDTNativeExpressAdView *expressView = views[0];
    expressView.controller = [UIApplication sharedApplication].delegate.window.rootViewController;
    [expressView render];
    [self addSubview:expressView];
    [_channel invokeMethod:@"nativeExpressAdSuccessToLoad" arguments:@""];
}

/**
 * 拉取原生模板广告失败
 */
- (void)nativeExpressAdFailToLoad:(GDTNativeExpressAd *)nativeExpressAd error:(NSError *)error
{
    NSLog(@"nativeExpressAdFailToLoad");
    [_channel invokeMethod:@"nativeExpressAdFailToLoad" arguments:@{
                                                                @"msg": error.localizedDescription,
                                                                @"code": @(error.code),
                                                                }];
}

/**
 * 原生模板广告渲染成功, 此时的 nativeExpressAdView.size.height 根据 size.width 完成了动态更新。
 */
- (void)nativeExpressAdViewRenderSuccess:(GDTNativeExpressAdView *)nativeExpressAdView
{
    [_channel invokeMethod:@"nativeExpressAdViewRenderSuccess" arguments:@{@"width": @(nativeExpressAdView.frame.size.width), @"height": @(nativeExpressAdView.frame.size.height)}];
}

/**
 * 原生模板广告渲染失败
 */
- (void)nativeExpressAdViewRenderFail:(GDTNativeExpressAdView *)nativeExpressAdView
{
    NSLog(@"nativeExpressAdViewRenderFail");
    [_channel invokeMethod:@"nativeExpressAdViewRenderFail" arguments:@""];
}

/**
 * 原生模板广告曝光回调
 */
- (void)nativeExpressAdViewExposure:(GDTNativeExpressAdView *)nativeExpressAdView
{
    NSLog(@"nativeExpressAdViewExposure");
    [_channel invokeMethod:@"nativeExpressAdViewExposure" arguments:@""];
}

/**
 * 原生模板广告点击回调
 */
- (void)nativeExpressAdViewClicked:(GDTNativeExpressAdView *)nativeExpressAdView
{
    NSLog(@"nativeExpressAdViewClicked");
    [_channel invokeMethod:@"nativeExpressAdViewClicked" arguments:@""];
}

/**
 * 原生模板广告被关闭
 */
- (void)nativeExpressAdViewClosed:(GDTNativeExpressAdView *)nativeExpressAdView
{
    NSLog(@"nativeExpressAdViewClosed");
    [_channel invokeMethod:@"nativeExpressAdViewClosed" arguments:@""];
}

/**
 * 点击原生模板广告以后即将弹出全屏广告页
 */
- (void)nativeExpressAdViewWillPresentScreen:(GDTNativeExpressAdView *)nativeExpressAdView
{
    NSLog(@"nativeExpressAdViewWillPresentScreen");
    [_channel invokeMethod:@"nativeExpressAdViewWillPresentScreen" arguments:@""];
}

/**
 * 点击原生模板广告以后弹出全屏广告页
 */
- (void)nativeExpressAdViewDidPresentScreen:(GDTNativeExpressAdView *)nativeExpressAdView
{
    NSLog(@"nativeExpressAdViewDidPresentScreen");
    [_channel invokeMethod:@"nativeExpressAdViewDidPresentScreen" arguments:@""];
}

/**
 * 全屏广告页将要关闭
 */
- (void)nativeExpressAdViewWillDissmissScreen:(GDTNativeExpressAdView *)nativeExpressAdView
{
    NSLog(@"nativeExpressAdViewWillDissmissScreen");
    [_channel invokeMethod:@"nativeExpressAdViewWillDissmissScreen" arguments:@""];
}

/**
 * 全屏广告页将要关闭
 */
- (void)nativeExpressAdViewDidDissmissScreen:(GDTNativeExpressAdView *)nativeExpressAdView
{
    NSLog(@"nativeExpressAdViewDidDissmissScreen");
    [_channel invokeMethod:@"nativeExpressAdViewDidDissmissScreen" arguments:@""];
}

/**
 * 原生模板广告点击之后应用进入后台时回调
 */
- (void)nativeExpressAdViewApplicationWillEnterBackground:(GDTNativeExpressAdView *)nativeExpressAdView
{
    NSLog(@"nativeExpressAdViewApplicationWillEnterBackground");
    [_channel invokeMethod:@"nativeExpressAdViewApplicationWillEnterBackground" arguments:@""];
}

/**
 * 原生模板视频广告 player 播放状态更新回调
 */
- (void)nativeExpressAdView:(GDTNativeExpressAdView *)nativeExpressAdView playerStatusChanged:(GDTMediaPlayerStatus)status
{
    NSLog(@"nativeExpressAdViewPlayerStatusChanged");
    [_channel invokeMethod:@"nativeExpressAdViewPlayerStatusChanged" arguments:@""];
}

/**
 * 原生视频模板详情页 WillPresent 回调
 */
- (void)nativeExpressAdViewWillPresentVideoVC:(GDTNativeExpressAdView *)nativeExpressAdView
{
    NSLog(@"nativeExpressAdViewWillPresentVideoVC");
    [_channel invokeMethod:@"nativeExpressAdViewWillPresentVideoVC" arguments:@""];
}

/**
 * 原生视频模板详情页 DidPresent 回调
 */
- (void)nativeExpressAdViewDidPresentVideoVC:(GDTNativeExpressAdView *)nativeExpressAdView
{
    NSLog(@"nativeExpressAdViewDidPresentVideoVC");
    [_channel invokeMethod:@"nativeExpressAdViewDidPresentVideoVC" arguments:@""];
}

/**
 * 原生视频模板详情页 WillDismiss 回调
 */
- (void)nativeExpressAdViewWillDismissVideoVC:(GDTNativeExpressAdView *)nativeExpressAdView
{
    NSLog(@"nativeExpressAdViewWillDismissVideoVC");
    [_channel invokeMethod:@"nativeExpressAdViewWillDismissVideoVC" arguments:@""];
}

/**
 * 原生视频模板详情页 DidDismiss 回调
 */
- (void)nativeExpressAdViewDidDismissVideoVC:(GDTNativeExpressAdView *)nativeExpressAdView
{
    NSLog(@"nativeExpressAdViewDidDismissVideoVC");
    [_channel invokeMethod:@"nativeExpressAdViewDidDismissVideoVC" arguments:@""];
}


@end
