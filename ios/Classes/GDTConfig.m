//
//  GDTConfig.m
//  flutter_gdt_plugin
//
//  Created by 王贺天 on 2018/12/21.
//

#import "GDTConfig.h"

@implementation GDTConfig

+ (instancetype) sharedInstance
{
    static GDTConfig *instance = nil;
    if (!instance) {
        instance = [[GDTConfig alloc] init];
    }
    return instance;
}

// 初始化广点通配置
- (void) initGDTConfig:(FlutterMethodCall *)call
{
    self.appid = call.arguments[@"appid"];
}

@end
