//
//  GDTSplash.h
//  flutter_gdt_plugin
//
//  Created by 王贺天 on 2018/12/22.
//

#import <Foundation/Foundation.h>
#import "GDTConfig.h"
#import <Flutter/Flutter.h>
#import <GDTMobSDK/GDTSplashAd.h>

NS_ASSUME_NONNULL_BEGIN

#define IS_IPHONEX (([[UIScreen mainScreen] nativeBounds].size.height-2436)?NO:YES)
@interface GDTSplash : NSObject<GDTSplashAdDelegate>
- (instancetype) initWithMessenger:(NSObject<FlutterPluginRegistrar>*)registrar;
- (void) show:(NSDictionary *)args result:(FlutterResult)result;
@end

NS_ASSUME_NONNULL_END
