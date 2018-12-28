//
//  GDTNativeExpress.h
//  flutter_gdt_plugin
//
//  Created by 王贺天 on 2018/12/21.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>
#import <UIKit/UIKit.h>
#import "GDTConfig.h"
#import <GDTMobSDK/GDTNativeExpressAd.h>
#import <GDTMobSDK/GDTNativeExpressAdView.h>

NS_ASSUME_NONNULL_BEGIN

@interface GDTNativeExpress : UIView <GDTNativeExpressAdDelegete>
@property (nonatomic, strong) FlutterMethodChannel* channel;
@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) GDTNativeExpressAd *nativeExpressAd;
- (instancetype)initWithFlutter:(NSDictionary *)args channel:(FlutterMethodChannel*)channel vid:(int64_t)vid;
@end

NS_ASSUME_NONNULL_END
