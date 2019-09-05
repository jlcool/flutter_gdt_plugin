//
//  FlutterPluginCache.h
//  flutter_gdt_plugin
//
//  Created by 王贺天 on 2019/9/4.
//

#import <Foundation/Foundation.h>

#import "GDTInterstitial.h"
#import "GDTSplash.h"

NS_ASSUME_NONNULL_BEGIN

@interface FlutterPluginCache : NSObject
@property (nonatomic, strong) NSMutableDictionary<NSString *, GDTInterstitial *>* interstitila;
@property (nonatomic, strong, nullable) GDTSplash * splash;

+ (instancetype) sharedInstance;
@end

NS_ASSUME_NONNULL_END
