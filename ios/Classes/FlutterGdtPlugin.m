#import "FlutterGdtPlugin.h"
#import "GDTConfig.h"

#import "GDTBannerFactory.h"
#import "GDTNativeExpressFactory.h"

#import "GDTInterstitial.h"
#import "GDTSplash.h"

#import "FlutterPluginCache.h"

// banner 使用视图方式展示
// 插屏广告 插件通道唤起
// 开屏广告 插件通道唤起
// 原生模版广告 需要使用视图方式
// ------------TODO 原生自渲染广告 需要使用视图方式 试图布局需要原生方式实现展示 有特殊需求在做
@implementation FlutterGdtPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    
    FlutterGdtPlugin* instance = [FlutterGdtPlugin sharedInstance];
    instance.registrar = registrar;
    
    // 注册banner视图
    GDTBannerFactory *GDTBannerView = [[GDTBannerFactory alloc] initWithMessenger:registrar.messenger];
    [registrar registerViewFactory:GDTBannerView withId:@"plugins.hetian.me/gdtview_banner"];
    
    // 注册原生模版广告
    GDTNativeExpressFactory *GDTNativeView = [[GDTNativeExpressFactory alloc] initWithMessenger:registrar.messenger];
    [registrar registerViewFactory:GDTNativeView withId:@"plugins.hetian.me/gdtview_native"];
    
    // 注册插件通道
    pluginChannel = [FlutterMethodChannel
                     methodChannelWithName:@"plugins.hetian.me/gdt_plugins"
                     binaryMessenger:[registrar messenger]];
    [registrar addMethodCallDelegate:instance channel:pluginChannel];
}

+ (instancetype) sharedInstance
{
    static FlutterGdtPlugin *instance = nil;
    if (!instance) {
        instance = [[FlutterGdtPlugin alloc] init];
    }
    return instance;
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result
{
    if([@"init" isEqual:call.method]) {
        [self GDTConfigInit:call result:result];
    }else if ([@"interstitial" isEqual:call.method]) {
        NSString *uuid = [GDTInterstitial createNew:call.arguments];
        result(@{@"channel_name":[GDTInterstitial getChannelName:uuid]});
    }else if ([@"splash" isEqual:call.method]) {
        if ([FlutterPluginCache sharedInstance].splash) {
            [FlutterPluginCache sharedInstance].splash = NULL;
        }
        [FlutterPluginCache sharedInstance].splash = [[GDTSplash alloc] initWithMessenger:_registrar];
        [[FlutterPluginCache sharedInstance].splash show:call.arguments result:result];
    } else {
        result(FlutterMethodNotImplemented);
    }
}

-(void) GDTConfigInit:(FlutterMethodCall*)call result:(FlutterResult)result
{
    [GDTConfig.sharedInstance initGDTConfig:call];
    result(@"success");
}

@end
