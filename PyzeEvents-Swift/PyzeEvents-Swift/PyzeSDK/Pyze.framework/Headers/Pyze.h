#import <UIKit/UIKit.h>

#import "PyzeEvent.h"


/**
 *  Significant build number for Pyze SDK.
 */
FOUNDATION_EXPORT double PyzeVersionNumber;

/**
 *  PyzeLogLevel
 *  Log level of the SDK. 
 *  Default is Minimal Logs
 */
typedef NS_ENUM(NSInteger, PyzeLogLevel) {
    /**
     *  Log Minimal
     *
     *  How to use:
     *
     *    [Pyze logThrottling:PyzelogLevelMinimal];
     */
    PyzelogLevelMinimal = 0,
    /**
     *  Log Mininmal + warnings
     *
     *  How to use:
     *
     *    [Pyze logThrottling:PyzelogLevelWarnings];
     */
    PyzelogLevelWarnings = 1,
    /**
     * Log Mininmal + warnings + errors
     *
     * How to use:
     *
     *    [Pyze logThrottling:PyzelogLevelErrors];
     */
    PyzelogLevelErrors = 2,
    /**
     * Log all messages
     *
     * How to use:
     *
     *    [Pyze logThrottling:PyzelogLevelAll];
     */
    PyzelogLevelAll = 3
};

#pragma mark - Pyze
/**
 * Pyze main class
 * 
 * This is the main class for the Pyze iOS SDK. Use method initializeWithKey: to initialize the Library.
 * For troubleshooting during development and in debug mode, you can throttle the logging level using method
 * debugLogThrottling:
 * In the release mode or deployment the SDK will log minimally.
 * 
 * Documentation is here: [docs.pyze.com](http://docs.pyze.com)
 *
 * You will need an app-specific key "Pyze App Key" from: [growth.pyze.com](https://growth.pyze.com/)
 * 
 */
@interface Pyze : NSObject


/// @name Initializing Pyze

/**
 *  Initializes the Pyze library. Call this method in the app delegate's method
 *  application:willFinishLaunchingWithOptions.
 * 
 *  Usage:
 *
 *      [Pyze initialize:@"Pyze App Key obtained from growth.pyze.com"];
 *
 *  @param pyzeAppKey The app-specific key obtained from [growth.pyze.com](https://growth.pyze.com/)
 *  @warning *Important:* Get an app-specific key from [growth.pyze.com](https://growth.pyze.com/)
 * 
 *  @since 2.0.5
 *
 */
+ (void) initialize:(NSString *) pyzeAppKey;

/// @name  Timer Reference to use with timed custom events

/**
 *  Pyze Timer Reference is a time interval since a Pyze internal reference time in seconds with millisecond precision e.g. 6.789 seconds (or 6789 milliseconds)
 *
 *  It is used to time tasks and report in events.
 *
 *  usage:
 *
 *     //Start timing
 *     double referenceFileUploadStart = [Pyze timerReference];
 *     ...
 *     ...
 *     //time and send elapsedSeconds
 *     [PyzeCustomEvent postWithEventName:@“File Uploaded”
 *                     withTimerReference:referenceFileUploadStart];
 *
 */
+(double) timerReference;



/// @name Throttling logs for troubleshooting

/**
 *  Log throttling level to be used in the lib while target is in debug mode.
 *
 *  How to use:
 *
 *    [Pyze logThrottling:PyzelogLevelMinimal];
 *
 *  or
 *
 *    [Pyze logThrottling:PyzelogLevelErrors];
 *
 *  @param logLevel Log level you would wish to see in the console.
 *
 *  @since 2.0.5
 *
 */
+(void) logThrottling:(PyzeLogLevel) logLevel;



/// @name Marked for Deprecation

/**
 *  Deprecated in favor of static initialize: method
 *
 *  @see +initialize:
 *
 */
- (void) initializeWithKey:(NSString *) pyzeAppKey;

/**
 *  Deprecated in favor of static method logThrottling:
 *
 *  @see +logThrottling:
 *
 */
-(void) logThrottling:(PyzeLogLevel) logLevel;

/**
 *  Get the shared instance of Pyze API
 *
 *  @return Pyze instance type.
 */
+ (Pyze*) sharedPyze;


/**
 *  init method is unavailable. Use initializeWithKey: method instead.
 *
 *  @see initializeWithKey:
 *
 *  @return instance type
 */
-(instancetype) init NS_UNAVAILABLE;

@end
