#import <Flutter/Flutter.h>

@interface FlutterGdtPlugin : NSObject<FlutterPlugin>
@property (nonatomic, retain) UIViewController *viewController;
+ (instancetype) sharedInstance;
- (void) removeGDTInterstitial;
- (void) removeGDTShlash;
@property (nonatomic, retain) FlutterMethodChannel *channel;
@end
