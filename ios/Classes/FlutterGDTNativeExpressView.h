//
//  FlutterGDTNativeExpressView.h
//  flutter_gdt_plugin
//
//  Created by 王贺天 on 2018/12/22.
//
#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>
#import "GDTNativeExpress.h"

NS_ASSUME_NONNULL_BEGIN

@interface FlutterGDTNativeExpressViewController : NSObject <FlutterPlatformView>

- (instancetype)initWithFrame:(CGRect)frame
               viewIdentifier:(int64_t)viewId
                    arguments:(id _Nullable)args
              binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger;

- (UIView*)view;
@end

@interface FlutterGDTNativeExpressViewFactory : NSObject <FlutterPlatformViewFactory>
- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger;
@end

NS_ASSUME_NONNULL_END
