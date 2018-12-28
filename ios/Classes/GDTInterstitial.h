//
//  GDTInterstitial.h
//  flutter_gdt_plugin
//
//  Created by 王贺天 on 2018/12/22.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GDTConfig.h"
#import <GDTMobSDK/GDTMobInterstitial.h>

NS_ASSUME_NONNULL_BEGIN

@interface GDTInterstitial : UIView
- (instancetype) initWithPlacementId:(NSString *)placementId tag:(NSString *)tag;
@end

NS_ASSUME_NONNULL_END
