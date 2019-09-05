//
//  GDTNativeExpressView.h
//  flutter_gdt_plugin
//
//  Created by 王贺天 on 2019/9/1.
//

#import <UIKit/UIKit.h>
#import <Flutter/Flutter.h>
#import <GDTMobSDK/GDTNativeExpressAdView.h>
#import <GDTMobSDK/GDTNativeExpressAd.h>

NS_ASSUME_NONNULL_BEGIN

@interface GDTNativeExpressView : UIView<GDTNativeExpressAdDelegete>
- (instancetype)initWithFrame:(CGRect)frame
               viewIdentifier:(int64_t)viewId
                    arguments:(id _Nullable)args
                    messenger:(NSObject<FlutterBinaryMessenger>*)messenger;
- (void) loadAds;
@end

NS_ASSUME_NONNULL_END
