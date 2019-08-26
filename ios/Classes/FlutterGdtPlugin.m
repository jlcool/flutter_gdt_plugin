#import "FlutterGdtPlugin.h"
#import "FlutterGDTBannerView.h"
#import "FlutterGDTNativeExpressView.h"
#import "GDTConfig.h"
#import "GDTInterstitial.h"
#import "GDTSplash.h"

// banner 使用视图方式展示
// 插屏广告 插件通道唤起
// 开屏广告 插件通道唤起 需要背景图资源、底部版权视图
// 原生模版广告 需要使用视图方式
// ------------TODO 原生自渲染广告 需要使用视图方式 试图布局需要原生方式实现展示 有特殊需求在做
@implementation FlutterGdtPlugin{
    GDTInterstitial * gdtInterstitial;
    GDTSplash  * gdtSplash;
}
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    // 注册banner视图
    FlutterGdtBannerViewFactory *GDTBannerView = [[FlutterGdtBannerViewFactory alloc] initWithMessenger:registrar.messenger];
    [registrar registerViewFactory:GDTBannerView withId:@"plugins.hetian.me/gdtview_banner"];
    
    // 注册原生模版广告
    FlutterGDTNativeExpressViewFactory *GDTNativeView = [[FlutterGDTNativeExpressViewFactory alloc] initWithMessenger:registrar.messenger];
    [registrar registerViewFactory:GDTNativeView withId:@"plugins.hetian.me/gdtview_native"];
    
    // 注册插件通道
    pluginChannel = [FlutterMethodChannel
               methodChannelWithName:@"plugins.hetian.me/gdt_plugins"
               binaryMessenger:[registrar messenger]];
    FlutterGdtPlugin* instance = [[FlutterGdtPlugin sharedInstance] initWithChannel:pluginChannel];
    
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

- (instancetype)initWithChannel:(FlutterMethodChannel *)channel {
    self = [super init];
    if (self) {
        self.channel = channel;
        self.viewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    }
    return self;
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result
{
    if([@"init" isEqual:call.method]) {
        [self GDTConfigInit:call result:result];
    }else if ([@"interstitial" isEqual:call.method]) {
        gdtInterstitial = [[GDTInterstitial alloc] initWithPlacementId:call.arguments[@"placementId"] tag:call.arguments[@"tag"]];
        [self.viewController.view addSubview:gdtInterstitial];
    }else if ([@"closeInterstitial" isEqual:call.method]) {
        [self removeGDTInterstitial];
    }else if ([@"shlash" isEqual:call.method]) {
        gdtSplash = [[GDTSplash alloc] initWithPlacementId:call.arguments[@"placementId"] tag:call.arguments[@"tag"]];
        [self.viewController.view addSubview:gdtSplash];
    }else if ([@"closeShlash" isEqual:call.method]) {
        [self removeGDTShlash];
    }
}

- (void) removeGDTShlash
{
    for(UIView *itemview in [self.viewController.view subviews])
    {
        if ([itemview isKindOfClass:[GDTSplash class]]) {
            [itemview removeFromSuperview];
            break;
        }
    }
    gdtSplash = nil;
}

- (void) removeGDTInterstitial
{
    for(UIView *itemview in [self.viewController.view subviews])
    {
        if ([itemview isKindOfClass:[GDTInterstitial class]]) {
            [itemview removeFromSuperview];
            break;
        }
    }
    gdtInterstitial = nil;
}

-(void) GDTConfigInit:(FlutterMethodCall*)call result:(FlutterResult)result
{
    [GDTConfig.sharedInstance initGDTConfig:call];
    result(@"success");
}

@end
