//
//  GDTInterstitial.h
//  flutter_gdt_plugin
//
//  Created by 王贺天 on 2018/12/22.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>
#import <GDTMobSDK/GDTUnifiedInterstitialAd.h>

#import "GDTConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface GDTInterstitial : NSObject<GDTUnifiedInterstitialAdDelegate>

@property (strong, nonatomic) GDTUnifiedInterstitialAd *interstitial;
@property (strong, nonatomic) FlutterMethodChannel *methodChannel;
+ (NSString *)createNew:(NSDictionary *)args;
+ (NSString *)getChannelName:(NSString *)uuid;

@end

NS_ASSUME_NONNULL_END
