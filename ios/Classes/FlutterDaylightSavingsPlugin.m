#import "FlutterDaylightSavingsPlugin.h"

#define NAMESPACE @"flutter_daylight_savings" // Assuming this is the namespace you want

@interface FlutterDaylightSavingsPlugin ()
@property(nonatomic) NSObject<FlutterPluginRegistrar> *registrar;
@property(nonatomic) FlutterMethodChannel *mMethodChannel;
@end

@implementation FlutterDaylightSavingsPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar
{
    FlutterMethodChannel *methodChannel = [FlutterMethodChannel methodChannelWithName:NAMESPACE @"/methods"
                                                                    binaryMessenger:[registrar messenger]];

    FlutterDaylightSavingsPlugin *instance = [[FlutterDaylightSavingsPlugin alloc] init];
    instance.mMethodChannel = methodChannel;

    [registrar addMethodCallDelegate:instance channel:methodChannel];
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result
{
    @try
    {
        if ([@"getNextTransitions" isEqualToString:call.method])
        {
            NSDictionary *args = (NSDictionary*)call.arguments;
            NSNumber *countNumber = args[@"count"];
            int count = [countNumber intValue];

            NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
            NSDate *currentDate = [NSDate date]; // Starting from the current date
            NSMutableArray *transitions = [[NSMutableArray alloc] init];
            int got = 0;

            while (got < count) {
                // Get the next daylight saving transition date
                NSDate *nextDSTDate = [timeZone nextDaylightSavingTimeTransitionAfterDate:currentDate];

                // Check if a next transition date is available
                if (nextDSTDate) {
                    // Get Unix timestamp and local offset
                    NSTimeInterval unixTimestamp = [nextDSTDate timeIntervalSince1970];
                    NSInteger localOffset = [timeZone secondsFromGMTForDate:nextDSTDate] / 60; // Convert seconds to minutes

                    // Add the information to the array
                    [transitions addObject:@{@"unixtime": @(unixTimestamp), @"localOffset": @(localOffset)}];

                    // Update currentDate for the next iteration
                    currentDate = nextDSTDate;

                    // Increment the got counter
                    got++;
                } else {
                    // No more transitions found
                    break;
                }
            }
            
            result(transitions);
        }
        else
        {
            result(FlutterMethodNotImplemented);
        }
    }
    @catch (NSException *e)
    {
        NSString *stackTrace = [[e callStackSymbols] componentsJoinedByString:@"\n"];
        NSDictionary *details = @{@"stackTrace": stackTrace};
        result([FlutterError errorWithCode:@"iosException" message:[e reason] details:details]);
    }
}

@end
