//
//  FlutterGDTNativeExpressView.m
//  flutter_gdt_plugin
//
//  Created by 王贺天 on 2018/12/22.
//

#import "FlutterGDTNativeExpressView.h"

@implementation FlutterGDTNativeExpressViewController{
    UIView* _view;
    int64_t _viewId;
    FlutterMethodChannel* _channel;
}

- (instancetype)initWithFrame:(CGRect)frame
               viewIdentifier:(int64_t)viewId
                    arguments:(id _Nullable)args
              binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger
{
    if ([super init]) {
        _viewId = viewId;
        NSString *channelName = [NSString stringWithFormat:@"plugins.hetian.me/gdtview_native_%lld", viewId];
        _channel = [FlutterMethodChannel methodChannelWithName:channelName binaryMessenger:messenger];
        __weak __typeof__(self) weakSelf = self;
        [_channel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
            [weakSelf onMethodCall:call result:result];
        }];
        _view = [[GDTNativeExpress alloc] initWithFlutter:args channel:_channel vid:_viewId];
    }
    return self;
}

- (void)onMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result
{
    
}

- (nonnull UIView *)view {
    return _view;
}
@end

@implementation FlutterGDTNativeExpressViewFactory{
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
    FlutterGDTNativeExpressViewController* gdtNativeExpressViewController = [
                                                   [FlutterGDTNativeExpressViewController alloc] initWithFrame:frame
                                                   viewIdentifier:viewId
                                                   arguments:args
                                                   binaryMessenger:_messenger
                                                   ];
    return gdtNativeExpressViewController;
}
@end
