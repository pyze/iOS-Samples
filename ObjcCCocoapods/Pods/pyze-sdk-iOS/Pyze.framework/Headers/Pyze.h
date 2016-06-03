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

/**
 *  PyzeAspectRatio
 *
 *  It will be used to display InApp Messages screen based on the aspect ratio of the screen on which In App messages will be presented.
 */
typedef NS_ENUM(NSInteger, PyzeAspectRatio) {
    /**
     *  Full size screen. InApp Messages screen will cover the screen on which In App messages will be presented.
     */
    PyzeAspectRatioFullSize,
    /**
     *  3/4 of the screen. InApp Messages screen will cover 75% of the screen on which In App messages will be presented.
     */
    PyzeAspectRatioThreeQuarterSize,
    /**
     *  1/2 of the screen. InApp Messages screen will cover 50% of the screen on which In App messages will be presented.
     */
    PyzeAspectRatioHalfSize
};

/**
 *  PyzeMessageDisplayType
 *
 *  This enum will be used to display New InApp messages [Unread messages] or Previous messages [Read messages] or both using segmented control
 *
 */
typedef NS_ENUM(NSInteger, PyzeMessageDisplayType) {
    /**
     *  New InApp messages [Unread messages]
     */
    PyzeMessageDisplayTypeNew,
    /**
     *  Previous messages [Read messages]
     */
    PyzeMessageDisplayTypePrevious,
    /**
     *  New InApp messages [Unread messages] & Previous messages [Read messages]
     */
    PyzeMessageDisplayTypeBoth
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



/// @name Push notification helper APIs

/**
 *  Use this API to set the push notification device token. This will trigger Pyze to update the device token, which internally would be used to send the push notification. Call this API in Application's AppDelegate method application:didRegisterForRemoteNotificationsWithDeviceToken:.
 *
 *
 *  @param deviceToken device Token bytes received from the AppDelegate's method call.
 
 *  @since 2.2.1
 */
+(void) setRemoteNotificationDeviceToken:(NSData *) deviceToken;


/**
 *  Use this API to process the push/remote notification. Call this everytime when you receive the remote notification from application:didReceiveRemoteNotification or application:didReceiveRemoteNotification:fetchCompletionHandler:
 
 *  @param userInfo User information received as a payload.
 
 *  @since 2.2.1
 */
+(void) processReceivedRemoteNotification:(NSDictionary *) userInfo;




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


/**
 *  This will show the In App messages with UI by calling getUnreadMessageCount, getUnreadMessageMetadata and getMessageWithMid:andWithCid:withCompletionHandler: methods
 *
 *  @param onViewControlller  Root view controller to which UI message to be displayed.
 *  @param title              Title for the in-app message screen.
 *  @param ratio              Aspect ratio of the in-app message screen with respect to the root view controller.
 *  @param displayMessageType Display message type of in-app message which are Unread/Read and both.
 *
 *  @since 2.2.0
 */
+(void) showInAppNotificationScreenOnViewController:(UIViewController *) onViewControlller
                                     viewControllerTitle:(NSString *) title
                                          forHeightRatio:(PyzeAspectRatio) ratio
                                      forDisplayMessages:(PyzeMessageDisplayType) displayMessageType;

/**
 *  Returns the unread messages of the in-app service.
 *
 *  @param completionHandler Completion handler with result.
 *
 *  @since 2.2.0
 */
+(void) getUnreadMessageCount:(void (^)(id result)) completionHandler;

/**
 *  Returns the unread message metadata of the in-app service.
 *
 *  @param completionHandler Completion handler with result.
 *
 *  @since 2.2.0
 */
+(void) getUnreadMessageMetadata:(void (^)(id result)) completionHandler;;

/**
 *  Returns the message from mid [message ID] and cid [campaign ID] received from the unread message metadata.
 *
 *  @param mid               message ID.
 *  @param cid               Campaign ID.
 *  @param completionHandler Completion handler with result.
 *
 *  @since 2.2.0
 */
+(void) getMessageWithMid:(NSString *) mid andWithCid:(NSString *) cid withCompletionHandler:(void (^)(id result)) completionHandler;

/**
 *  Returns the previous read messages.
 *
 *  @return Contains array of metadata of messages.
 *
 *  @since 2.2.0
 */
+(NSArray *) previousReadMessages;

@end
