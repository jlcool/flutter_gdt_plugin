//
//  FlutterPluginCache.m
//  flutter_gdt_plugin
//
//  Created by 王贺天 on 2019/9/4.
//

#import "FlutterPluginCache.h"

@implementation FlutterPluginCache

+ (instancetype) sharedInstance
{
    static FlutterPluginCache *instance = nil;
    if (!instance) {
        instance = [[FlutterPluginCache alloc] init];
        instance.interstitila = [[NSMutableDictionary alloc] init];
    }
    return instance;
}

@end
