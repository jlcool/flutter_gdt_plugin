//
//  GDTConfig.h
//  flutter_gdt_plugin
//
//  Created by 王贺天 on 2018/12/21.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

static FlutterMethodChannel *pluginChannel;

@interface GDTConfig : NSObject
@property (nonatomic, strong) NSString *appid;
+ (instancetype)sharedInstance;
- (void) initGDTConfig:(FlutterMethodCall*)call;
@end

NS_ASSUME_NONNULL_END
