#import <Flutter/Flutter.h>


@interface FlutterGdtPlugin : NSObject<FlutterPlugin>
@property (nonatomic, strong) NSObject<FlutterPluginRegistrar> * _Nonnull registrar;

+ (instancetype ) sharedInstance;
@end
