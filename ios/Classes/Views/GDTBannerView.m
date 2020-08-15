//
//  GDTBannerView.m
//  flutter_gdt_plugin
//
//  Created by 王贺天 on 2019/9/1.
//

#import "GDTBannerView.h"
#import "GDTConfig.h"

@implementation GDTBannerView
{
    CGRect _frame;
    int64_t _viewId;
    NSDictionary *_args;
    NSObject<FlutterBinaryMessenger>* _messenger;
    FlutterMethodChannel *_methodChannel;
    GDTUnifiedBannerView *_bannerView;
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
        NSString *channelName = [NSString stringWithFormat:@"plugins.hetian.me/gdtview_banner/%lld", _viewId];
        _methodChannel = [FlutterMethodChannel methodChannelWithName:channelName binaryMessenger:messenger];
        [self addSubview:[self loadShow]];
    }
    return self;
}

- (GDTUnifiedBannerView *) loadShow
{
    if (!_bannerView) {
        NSString *posId = _args[@"posId"];
        CGFloat padd = [[UIScreen mainScreen] bounds].size.width - 375.0;
        CGRect rect = {CGPointMake(padd / 2, 0), CGSizeMake(375, 60)};
        _bannerView = [[GDTUnifiedBannerView alloc]
                       initWithFrame:rect
                       placementId:posId
                       viewController:[UIApplication sharedApplication].delegate.window.rootViewController];
        _bannerView.animated = YES;
        _bannerView.autoSwitchInterval = 10;
        _bannerView.delegate = self;
        [_bannerView loadAdAndShow];
    }
    return _bannerView;
}

// GDTUnifiedBannerViewDelegate

/**
 *  请求广告条数据成功后调用
 *  当接收服务器返回的广告数据成功后调用该函数
 */
- (void)unifiedBannerViewDidLoad:(GDTUnifiedBannerView *)unifiedBannerView
{
    [_methodChannel invokeMethod:@"onADReceive" arguments:@""];
}

/**
 *  请求广告条数据失败后调用
 *  当接收服务器返回的广告数据失败后调用该函数
 */
- (void)unifiedBannerViewFailedToLoad:(GDTUnifiedBannerView *)unifiedBannerView error:(NSError *)error
{
    [_methodChannel invokeMethod:@"onNoAD" arguments:@{
                                                       @"code": @(error.code),
                                                       @"msg": error.localizedDescription
                                                       }];
}

/**
 *  banner2.0曝光回调
 */
- (void)unifiedBannerViewWillExpose:(GDTUnifiedBannerView *)unifiedBannerView
{
    [_methodChannel invokeMethod:@"onADExposure" arguments:@{
                                                             @"width": @(_bannerView.bounds.size.width),
                                                             @"height": @(_bannerView.bounds.size.height),
                                                             }];
}

/**
 *  banner2.0点击回调
 */
- (void)unifiedBannerViewClicked:(GDTUnifiedBannerView *)unifiedBannerView
{
    [_methodChannel invokeMethod:@"onADClicked" arguments:@""];
}

/**
 *  banner2.0广告点击以后即将弹出全屏广告页
 */
- (void)unifiedBannerViewWillPresentFullScreenModal:(GDTUnifiedBannerView *)unifiedBannerView
{
    [_methodChannel invokeMethod:@"onADLeftApplication" arguments:@""];
}

/**
 *  banner2.0广告点击以后弹出全屏广告页完毕
 */
- (void)unifiedBannerViewDidPresentFullScreenModal:(GDTUnifiedBannerView *)unifiedBannerView
{
    [_methodChannel invokeMethod:@"onADOpenOverlay" arguments:@""];
}

/**
 *  全屏广告页即将被关闭
 */
- (void)unifiedBannerViewWillDismissFullScreenModal:(GDTUnifiedBannerView *)unifiedBannerView
{
}

/**
 *  全屏广告页已经被关闭
 */
- (void)unifiedBannerViewDidDismissFullScreenModal:(GDTUnifiedBannerView *)unifiedBannerView
{
    [_methodChannel invokeMethod:@"onADCloseOverlay" arguments:@""];
}

/**
 *  当点击应用下载或者广告调用系统程序打开
 */
- (void)unifiedBannerViewWillLeaveApplication:(GDTUnifiedBannerView *)unifiedBannerView
{
}

/**
 *  banner2.0被用户关闭时调用
 */
- (void)unifiedBannerViewWillClose:(GDTUnifiedBannerView *)unifiedBannerView
{
    [_methodChannel invokeMethod:@"onADClosed" arguments:@""];
}

@end
