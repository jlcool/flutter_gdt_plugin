//
//  GDTNativeExpressView.m
//  flutter_gdt_plugin
//
//  Created by 王贺天 on 2019/9/1.
//

#import "GDTNativeExpressView.h"
#import "GDTConfig.h"

@implementation GDTNativeExpressView
{
    CGRect _frame;
    int64_t _viewId;
    NSDictionary *_args;
    NSObject<FlutterBinaryMessenger>* _messenger;
    FlutterMethodChannel *_methodChannel;
    GDTNativeExpressAd *_nativeExpressAd;
}

- (instancetype)initWithFrame:(CGRect)frame
               viewIdentifier:(int64_t)viewId
                    arguments:(id _Nullable)args
                    messenger:(NSObject<FlutterBinaryMessenger>*)messenger
{
    self = [super init];
    if (self) {
        _frame = frame;
        _viewId = viewId;
        _args = args;
        _messenger = messenger;
        NSString *channelName = [NSString stringWithFormat:@"plugins.hetian.me/gdtview_express/%lld", _viewId];
        _methodChannel = [FlutterMethodChannel methodChannelWithName:channelName binaryMessenger:messenger];
        [self loadAds];
    }
    return self;
}

- (void) loadAds
{
    NSString *posId = _args[@"posId"];
    _nativeExpressAd = [[GDTNativeExpressAd alloc] initWithAppId:[GDTConfig sharedInstance].appid placementId:posId adSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width, 0.0)];
    _nativeExpressAd.delegate = self;
    [_nativeExpressAd loadAd:1];
}


//GDTNativeExpressAdDelegete

/**
 * 拉取原生模板广告成功
 */
- (void)nativeExpressAdSuccessToLoad:(GDTNativeExpressAd *)nativeExpressAd views:(NSArray<__kindof GDTNativeExpressAdView *> *)views
{
    [_methodChannel invokeMethod:@"onADLoaded" arguments:@""];
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self addSubview:views.firstObject];
    views.firstObject.controller = [UIApplication sharedApplication].delegate.window.rootViewController;
    [views.firstObject render];
}

/**
 * 拉取原生模板广告失败
 */
- (void)nativeExpressAdFailToLoad:(GDTNativeExpressAd *)nativeExpressAd error:(NSError *)error
{
    [_methodChannel invokeMethod:@"onNoAD" arguments:@{
                                                       @"code": @(error.code),
                                                       @"msg": error.localizedDescription,
                                                       }];
}

/**
 * 原生模板广告渲染成功, 此时的 nativeExpressAdView.size.height 根据 size.width 完成了动态更新。
 */
- (void)nativeExpressAdViewRenderSuccess:(GDTNativeExpressAdView *)nativeExpressAdView
{
    [_methodChannel invokeMethod:@"onRenderSuccess" arguments:@""];
}

/**
 * 原生模板广告渲染失败
 */
- (void)nativeExpressAdViewRenderFail:(GDTNativeExpressAdView *)nativeExpressAdView
{
    [_methodChannel invokeMethod:@"onRenderFail" arguments:@""];
}

/**
 * 原生模板广告曝光回调
 */
- (void)nativeExpressAdViewExposure:(GDTNativeExpressAdView *)nativeExpressAdView
{
    [_methodChannel invokeMethod:@"onADExposure" arguments:@{
                                                             @"width": @(nativeExpressAdView.bounds.size.width),
                                                             @"height": @(nativeExpressAdView.bounds.size.height),
                                                             }];
}

/**
 * 原生模板广告点击回调
 */
- (void)nativeExpressAdViewClicked:(GDTNativeExpressAdView *)nativeExpressAdView
{
    [_methodChannel invokeMethod:@"onADClicked" arguments:@""];
}

/**
 * 原生模板广告被关闭
 */
- (void)nativeExpressAdViewClosed:(GDTNativeExpressAdView *)nativeExpressAdView
{
    [_methodChannel invokeMethod:@"onADClosed" arguments:@""];
}

/**
 * 点击原生模板广告以后即将弹出全屏广告页
 */
- (void)nativeExpressAdViewWillPresentScreen:(GDTNativeExpressAdView *)nativeExpressAdView
{
    [_methodChannel invokeMethod:@"onADLeftApplication" arguments:@""];
}

/**
 * 点击原生模板广告以后弹出全屏广告页
 */
- (void)nativeExpressAdViewDidPresentScreen:(GDTNativeExpressAdView *)nativeExpressAdView
{
    [_methodChannel invokeMethod:@"onADOpenOverlay" arguments:@""];
}

/**
 * 全屏广告页将要关闭
 */
- (void)nativeExpressAdViewWillDissmissScreen:(GDTNativeExpressAdView *)nativeExpressAdView
{
    [_methodChannel invokeMethod:@"onADCloseOverlay" arguments:@""];
}

/**
 * 全屏广告页将要关闭
 */
- (void)nativeExpressAdViewDidDissmissScreen:(GDTNativeExpressAdView *)nativeExpressAdView
{
    [_methodChannel invokeMethod:@"onADClosed" arguments:@""];
}

/**
 * 详解:当点击应用下载或者广告调用系统程序打开时调用
 */
- (void)nativeExpressAdViewApplicationWillEnterBackground:(GDTNativeExpressAdView *)nativeExpressAdView
{
}

// 暂不支持视频广告

/**
 * 原生模板视频广告 player 播放状态更新回调
 */
- (void)nativeExpressAdView:(GDTNativeExpressAdView *)nativeExpressAdView playerStatusChanged:(GDTMediaPlayerStatus)status
{
    
}

/**
 * 原生视频模板详情页 WillPresent 回调
 */
- (void)nativeExpressAdViewWillPresentVideoVC:(GDTNativeExpressAdView *)nativeExpressAdView
{
    
}

/**
 * 原生视频模板详情页 DidPresent 回调
 */
- (void)nativeExpressAdViewDidPresentVideoVC:(GDTNativeExpressAdView *)nativeExpressAdView
{
    
}

/**
 * 原生视频模板详情页 WillDismiss 回调
 */
- (void)nativeExpressAdViewWillDismissVideoVC:(GDTNativeExpressAdView *)nativeExpressAdView
{
    
}

/**
 * 原生视频模板详情页 DidDismiss 回调
 */
- (void)nativeExpressAdViewDidDismissVideoVC:(GDTNativeExpressAdView *)nativeExpressAdView
{
    
}


@end
