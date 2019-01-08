//
//  GDTBanner.m
//  flutter_gdt_plugin
//
//  Created by 王贺天 on 2018/12/20.
//

#import "GDTBanner.h"
#import "GDTConfig.h"
@interface GDTBanner()<GDTMobBannerViewDelegate>
@property (nonatomic, strong) GDTMobBannerView *bannerView;
@end
@implementation GDTBanner{
    int64_t _vid;
    NSDictionary *_args;
}
- (instancetype)initWithFlutter:(NSDictionary *)args channel:(FlutterMethodChannel*)channel vid:(int64_t)vid
{
    self = [super init];
    if (self) {
        _args = args;
        _channel = channel;
        _vid = vid;
        [self addSubview:[self getView]];
    }
    return self;
}

- (GDTMobBannerView *)getView
{
    if (!_bannerView) {
        // 广告位ID
        NSString *placementId = _args[@"placementId"];
        // 轮播间隔
        NSNumber *interval = _args[@"interval"];
        // 是否动画
        BOOL isAnimationOn = _args[@"isAnimationOn"];
        // 是否显示关闭按钮
        BOOL showCloseBtn = _args[@"showCloseBtn"];
        // 是否开启GPS
        BOOL isGpsOn = _args[@"isGpsOn"];
        // 广告尺寸 0，1，2 位内置尺寸，其他为自定义宽度，高度不更改
        NSNumber *size = _args[@"size"];
        CGSize adSizeMake;
        if ([size isEqual:[NSNumber numberWithInt:0]]) {
            adSizeMake = GDTMOB_AD_SUGGEST_SIZE_320x50;
        }else if ([size isEqual:[NSNumber numberWithInt:1]]) {
            adSizeMake = GDTMOB_AD_SUGGEST_SIZE_468x60;
        }else if ([size isEqual:[NSNumber numberWithInt:2]]) {
            adSizeMake = GDTMOB_AD_SUGGEST_SIZE_728x90;
        }else {
            adSizeMake = CGSizeMake([size floatValue], 50.0f);
        }
        CGRect rect = {CGPointZero, adSizeMake};
        _bannerView = [[GDTMobBannerView alloc] initWithFrame:rect appId:[GDTConfig.sharedInstance appid] placementId:placementId];
        _bannerView.currentViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
        _bannerView.interval = [interval intValue];
        _bannerView.isAnimationOn = isAnimationOn;
        _bannerView.showCloseBtn = showCloseBtn;
        _bannerView.isGpsOn = isGpsOn;
        _bannerView.delegate = self;
        [_bannerView loadAdAndShow];
    }
    return _bannerView;
}

- (void) load
{
    if (_bannerView != nil) {
        [_bannerView loadAdAndShow];
    }
}

- (void)dealloc
{
    if (_bannerView != nil) {
        _bannerView.delegate = NULL;
        _bannerView.currentViewController = NULL;
        _bannerView = NULL;
    }
}

#pragma mark - GDTMobBannerViewDelegate
// 请求广告条数据成功后调用
//
// 详解:当接收服务器返回的广告数据成功后调用该函数
- (void)bannerViewDidReceived
{
    NSLog(@"bannerViewDidReceived");
    [_channel invokeMethod:@"bannerViewDidReceived" arguments:@""];
}

// 请求广告条数据失败后调用
//
// 详解:当接收服务器返回的广告数据失败后调用该函数
- (void)bannerViewFailToReceived:(NSError *)error
{
    NSLog(@"bannerViewFailToReceived %@", error);
    [_channel invokeMethod:@"bannerViewFailToReceived" arguments:@{
                                                                @"msg": error.localizedDescription,
                                                                @"code": @(error.code),
                                                                }];
}

// 广告栏被点击后调用
//
// 详解:当接收到广告栏被点击事件后调用该函数
- (void)bannerViewClicked
{
    NSLog(@"bannerViewClicked");
    [_channel invokeMethod:@"bannerViewClicked" arguments:@""];
}

// 应用进入后台时调用
//
// 详解:当点击下载或者地图类型广告时，会调用系统程序打开，
// 应用将被自动切换到后台
- (void)bannerViewWillLeaveApplication
{
    NSLog(@"bannerViewWillLeaveApplication");
    [_channel invokeMethod:@"bannerViewWillLeaveApplication" arguments:@""];
}


-(void)bannerViewDidDismissFullScreenModal
{
    NSLog(@"bannerViewDidDismissFullScreenModal");
    [_channel invokeMethod:@"bannerViewDidDismissFullScreenModal" arguments:@""];
}

-(void)bannerViewWillDismissFullScreenModal
{
    NSLog(@"bannerViewWillDismissFullScreenModal");
    [_channel invokeMethod:@"bannerViewWillDismissFullScreenModal" arguments:@""];
}

-(void)bannerViewWillPresentFullScreenModal
{
    NSLog(@"bannerViewWillPresentFullScreenModal");
    [_channel invokeMethod:@"bannerViewWillPresentFullScreenModal" arguments:@""];
}

-(void)bannerViewDidPresentFullScreenModal
{
    NSLog(@"bannerViewDidPresentFullScreenModal");
    [_channel invokeMethod:@"bannerViewDidPresentFullScreenModal" arguments:@""];
}

- (void) bannerViewWillClose
{
    NSLog(@"bannerViewWillClose");
    [_channel invokeMethod:@"bannerViewWillClose" arguments:@""];
}

- (void) bannerViewWillExposure
{
    NSLog(@"bannerViewWillExposure");
    [_channel invokeMethod:@"bannerViewWillExposure" arguments:@""];
}

@end
