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
     */
    PyzelogLevelMinimal = 0,
    /**
     *  Log Mininmal + warnings
     */
    PyzelogLevelWarnings = 1,
    /**
     * Log Mininmal + warnings + errors
     */
    PyzelogLevelErrors = 2,
    /**
     *  Log all messages
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
 * SDK Download instructions are here: [github.com/pyze/iOS-Library](https://github.com/pyze/iOS-Library/) 
 * 
 * You will need an app-specific key from: [growth.pyze.com](https://growth.pyze.com/) 
 * 
 */
@interface Pyze : NSObject


/// @name Initialize Pyze Library

/**
 *  Initializes the Pyze library. Call this method in the app delegate's method
 *  application:willFinishLaunchingWithOptions.
 *      
 *  @param pyzeAppKey The app-specific key obtained from [growth.pyze.com](https://growth.pyze.com/) 
 *  @warning *Important:* Get an app-specific key from [growth.pyze.com](https://growth.pyze.com/) 
 */
- (void) initializeWithKey:(NSString *) pyzeAppKey;

/// @name Debug Log Throttling

/**
 
 */
-(void) debugLogThrottling:(PyzeLogLevel) logLevel;


/// @name Shared Pyze Instance

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
