
#if TARGET_OS_OSX
#import <FlutterMacOS/FlutterMacOS.h>
#else
#import <Flutter/Flutter.h>
#endif

#define NAMESPACE @"flutter_daylight_savings"

@interface FlutterDaylightSavingsPlugin : NSObject<FlutterPlugin>
@end
