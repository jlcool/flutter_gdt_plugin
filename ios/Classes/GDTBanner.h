//
//  GDTBanner.h
//  flutter_gdt_plugin
//
//  Created by 王贺天 on 2018/12/20.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Flutter/Flutter.h>
#import <GDTMobSDK/GDTMobBannerView.h>

NS_ASSUME_NONNULL_BEGIN

@interface GDTBanner : UIView
@property (nonatomic, strong) FlutterMethodChannel* channel;
- (instancetype)initWithFlutter:(NSDictionary *)args channel:(FlutterMethodChannel*)channel vid:(int64_t)vid;
- (void) load;
@end

NS_ASSUME_NONNULL_END
