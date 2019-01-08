//
//  FlutterGdtView.m
//  flutter_gdt_plugin
//
//  Created by 王贺天 on 2018/12/20.
//

#import "FlutterGDTBannerView.h"
#import "GDTBanner.h"

@implementation FlutterGdtBannerViewController {
    int64_t _viewId;
    GDTBanner *gdtBanner;
    FlutterMethodChannel* _channel;
}
- (instancetype)initWithFrame:(CGRect)frame
               viewIdentifier:(int64_t)viewId
                    arguments:(id _Nullable)args
              binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger
{
    if ([super init]) {
        _viewId = viewId;
        NSString *channelName = [NSString stringWithFormat:@"plugins.hetian.me/gdtview_banner_%lld", viewId];
        _channel = [FlutterMethodChannel methodChannelWithName:channelName binaryMessenger:messenger];
        __weak __typeof__(self) weakSelf = self;
        [_channel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
            [weakSelf onMethodCall:call result:result];
        }];
        gdtBanner = [[GDTBanner alloc] initWithFlutter:args channel:_channel vid:_viewId];
    }
    return self;
}

- (nonnull UIView *)view {
    return gdtBanner;
}

- (void)onMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result
{
    if ([@"load" isEqual:call.method]) {
        [gdtBanner load];
    }
}

// 如有特殊参数修正可在此处处理
- (void)applySettings:(NSDictionary<NSString*, id>*)settings {
//    for (NSString* key in settings) {
//    }
}
@end


@implementation FlutterGdtBannerViewFactory{
    NSObject<FlutterBinaryMessenger>* _messenger;
}

- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger
{
    self = [super init];
    if (self) {
        _messenger = messenger;
    }
    return self;
}

- (NSObject<FlutterMessageCodec>*)createArgsCodec {
    return [FlutterStandardMessageCodec sharedInstance];
}

- (NSObject<FlutterPlatformView>*)createWithFrame:(CGRect)frame
                                   viewIdentifier:(int64_t)viewId
                                        arguments:(id _Nullable)args {
    FlutterGdtBannerViewController* gdtBannerViewController = [
                                                   [FlutterGdtBannerViewController alloc] initWithFrame:frame
                                                   viewIdentifier:viewId
                                                   arguments:args
                                                   binaryMessenger:_messenger
                                                   ];
    return gdtBannerViewController;
}
@end
