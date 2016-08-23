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
 *  PyzeInAppMessageType
 *
 *  This enum will be used to display New InApp messages [Unread messages] or Previous messages [Read messages] or both.
 *
 */
typedef NS_ENUM(NSInteger, PyzeInAppMessageType) {
    /**
     *  New InApp messages [Unread messages including unfetched]
     */
    PyzeInAppTypeUnread,
    /**
     *  Previous messages [Read messages]
     */
    PyzeInAppTypeRead,
    /**
     *  New InApp messages [Unread messages] & Previous messages [Read messages]
     */
    PyzeInAppTypeAll
};


/**
 *  Pyze deep link status enumeration, useful to determine whether deeplink provided, successful or failed.
 *
 *  - Since: 2.3.0
 */
typedef NS_ENUM(NSInteger, PyzeDeepLinkStatus) {
    /**
     *  Deeplink not provided while creating the in-app
     */
    PyzeDeepLinkNotProvided = 0,
    /**
     *  Deeplink successfully called. For Example: (http://pyze.com or yelp://search?term=burritos where yelp application is installed on the device)
     */
    PyzeDeepLinkCallSuccessful,
    /**
     *  Invalid or deeplink not found. For Example: (mispelt htp://pyze.com or yelp://search?term=burritos where yelp application is not installed on the device)
     */
    PyzeDeepLinkCallFailed
};


#pragma mark - Pyze

@protocol PyzeInAppMessageHandlerDelegate;
@class PyzeInAppStatus;
/**
 * Pyze main class
 * 
 * This is the main class for the Pyze iOS SDK. Use method initializeWithKey: to initialize the Library.
 * For troubleshooting during development and in debug mode, you can throttle the logging level using method
 * debugLogThrottling:
 * In the release mode or deployment the SDK will log minimally.
 * 
 * Please visit [Pyze Developer Center](http://docs.pyze.com) for more information.
 *
 * You will need an app-specific key "Pyze App Key" from: [growth.pyze.com](https://growth.pyze.com/)
 * 
 */
@interface Pyze : NSObject


/// @name Initializing Pyze

/**
 *  Initializes the Pyze library. Call this method in the app delegate's method
 *  application:willFinishLaunchingWithOptions. [Get Pyze App Key from growth.pyze.com](http://pyze.com/get-Pyze-App-Key.html)
 * 
 *  Usage:
 *
 *      [Pyze initialize:@"Pyze App Key obtained from growth.pyze.com"];
 *
 *  @param pyzeAppKey The app-specific key obtained from [growth.pyze.com](http://pyze.com/get-Pyze-App-Key.html)
 *  @warning *Important:* Get an app-specific key from [growth.pyze.com](http://pyze.com/get-Pyze-App-Key.html)
 * 
 *  - Since: 2.0.5
 *
 */
+ (void) initialize:(NSString *) pyzeAppKey;

/**
 *  Initializes the Pyze library and specify the log throttling level. Call this method in the app delegate's method
 *  application:willFinishLaunchingWithOptions. [Get Pyze App Key from growth.pyze.com](http://pyze.com/get-Pyze-App-Key.html)
 *
 *  Usage:
 *
 *      [Pyze initialize:@"Pyze App Key obtained from growth.pyze.com"   withLogThrottling: PyzelogLevelAll];
 *
 *  @param pyzeAppKey The app-specific key obtained from [growth.pyze.com](http://pyze.com/get-Pyze-App-Key.html)
 *  @param logLevel Log level you would wish to see in the console.
 *  @warning *Important:* Get an app-specific key from [growth.pyze.com](http://pyze.com/get-Pyze-App-Key.html)
 *
 *  - Since: 2.3.3 (added for consistency with Android and Unity agents)
 *
 */
+ (void) initialize:(NSString *)pyzeAppKey withLogThrottling: (PyzeLogLevel) logLevel;


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
 *  Log throttling level can be changed anytime in the app
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
 *  - Since: 2.0.5
 *
 */
+(void) logThrottling:(PyzeLogLevel) logLevel;



/// @name Push notification helper APIs

/**
 *  Use this API to set the push notification device token. This will trigger Pyze to update the device token, which internally would be used to send the push notification. Call this API in Application's AppDelegate method application:didRegisterForRemoteNotificationsWithDeviceToken:.
 *
 *
 *  @param deviceToken device Token bytes received from the AppDelegate's method call.
 
 *  - Since: 2.2.1
 */
+(void) setRemoteNotificationDeviceToken:(NSData *) deviceToken;


/**
 *  Use this API to process the push/remote notification. Call this everytime when you receive the remote notification from application:didReceiveRemoteNotification or application:didReceiveRemoteNotification:fetchCompletionHandler:
 
 *  @param userInfo User information received as a payload.
 
 *  - Since: 2.2.1
 */
+(void) processReceivedRemoteNotification:(NSDictionary *) userInfo;


/// @name In-App Notifications (using Built-in User Interface)

/**
 *  This will add a badge to the UIControl (e.g.: UIButton) depicting the number of unfetched and new in-app messages available. 
 *
 *  @param control UIControl to add badge to.
 
 - Since: 2.3.2
 
 */
+(void) addBadge:(UIControl *) control;


/**
 *  Show in-app unread messages with default settings. For all the controls presented including  Message Navigation Bar, buttons
 *  will loaded with default presentation colors used by the SDK. When user taps on any of the buttons in in-app message
 *  completionhandler method will be called.
 *
 *  @param completionhandler Completion handler
 *
 *  - Since: 2.5.3
 *
 */
+(void) showUnreadInAppNotificationUIWithCompletionHandler:(void (^)(PyzeInAppStatus *inAppStatus))completionhandler;

/**
 *  Convenience method to show in-app message with custom colors as required by the app. When user taps on any of the buttons in in-app message
 *  completionhandler method will be called.
 *
 *  @param messageType             The in-app message type you would want to see. Default is PyzeInAppTypeUnread.
 *  @param buttonTextcolor         Button text color.
 *  @param buttonBackgroundColor   Button background color
 *  @param backgroundColor         Translucent background color of the 'MessageNavigationBar'
 *  @param messageCounterTextColor Message counter text color (Ex: 1 of 10 in-app messages).
 *  @param completionhandler Completion handler
 *
 *  - Since: 2.5.3

 */
+(void) showInAppNotificationUIForDisplayMessages:(PyzeInAppMessageType) messageType
                        msgNavBarButtonsTextColor:(UIColor *) buttonTextcolor
                          msgNavBarButtonsBgColor:(UIColor *) buttonBackgroundColor
                                 msgNavBarBgColor:(UIColor *) backgroundColor
                        msgNavBarCounterTextColor:(UIColor *) messageCounterTextColor
                            withCompletionHandler:(void (^)(PyzeInAppStatus *inAppStatus))completionhandler;

/// @name In-App Notifications (using API)

/**
 *  Returns the number of unread messages from the server.
 *
 *  @param completionHandler Completion handler will be called with count.
 *
 *  - Since: 2.3.0
 */
+(void) countNewUnFetched:(void (^)(NSInteger count)) completionHandler;

/**
 *  Get NSArray of message headers containing message ID and content ID.
 *
 *  @param messageType       Message type for in-app messages.
 *  @param completionHandler Completion handler will be called with result.
 *
 *  - Since: 2.3.0
 */
+(void) getMessageHeadersForType:(PyzeInAppMessageType) messageType
           withCompletionHandler:(void (^)(NSArray * messageHeaders)) completionHandler;

/**
 *  Get message details with Campaign ID and message ID received from 'getMessageHeadersForType'.
 *
 *  @param cid                  campaign ID
 *  @param messageID            message ID
 *  @param completionHandler    Completion handler will be called with message body.
 *
 *  - Since: 2.3.0
 */
+(void) getMessageBodyWithCampaignID:(NSString *) cid
                        andMessageID:(NSString *) messageID
               withCompletionHandler:(void (^)(NSDictionary * messageBody)) completionHandler;



/// @name Deprecated methods

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
 *  Show in-app unread messages with default settings. For all the controls presented including  Message Navigation Bar, buttons
 *  will loaded with default presentation colors used by the SDK. When user taps on any of the buttons in in-app message
 *  inAppMessageButtonHandlerWithIndex:buttonTitle:containingURLString:withDeepLinkStatus method will be called on your onViewController.
 *
 *  @param onViewController The controller on which the in-app should be presented.
 
 *  @see showUnreadInAppNotificationUIWithCompletionHandler:
 
 - Since: 2.3.0
 */
+(void) showUnreadInAppNotificationUI:(UIViewController *) onViewController;


/**
 *  Convenience method to show in-app message with custom colors as required by the app. When user taps on any of the buttons in in-app message
 *  inAppMessageButtonHandlerWithIndex:buttonTitle:containingURLString:withDeepLinkStatus method will be called on your onViewController.
 *
 *  @param onViewController        The controller on which the in-app should be presented.
 *  @param messageType             The in-app message type you would want to see. Default is PyzeInAppTypeUnread.
 *  @param buttonTextcolor         Button text color.
 *  @param buttonBackgroundColor   Button background color
 *  @param backgroundColor         Translucent background color of the 'MessageNavigationBar'
 *  @param messageCounterTextColor Message counter text color (Ex: 1 of 10 in-app messages).
 *
 *  @see showInAppNotificationUI: with completionHandler method.
 
 *  - Since: 2.3.0
 */

+(void) showInAppNotificationUI:(UIViewController *) onViewController
             forDisplayMessages:(PyzeInAppMessageType) messageType
      msgNavBarButtonsTextColor:(UIColor *) buttonTextcolor
        msgNavBarButtonsBgColor:(UIColor *) buttonBackgroundColor
               msgNavBarBgColor:(UIColor *) backgroundColor
      msgNavBarCounterTextColor:(UIColor *) messageCounterTextColor;


@end



/**
 *  Pyze In app message handler delegate. This has one optional call to action method which will inform your class 
    when user clicks on one of the in-app messsage buttons.
 *
 *  - Since: 2.3.0
 */
@protocol PyzeInAppMessageHandlerDelegate <NSObject>

/// @name Optional delegate method

@optional

/**
 *  Call to action handler for in-app message buttons implemented by your view controller to receive in-app message
    button click actions.
 *
 *  @param buttonID  Button index
 *  @param title     Title provided for the button
 *  @param urlString Deeplink url string provided.
 *  @param status    Pyze deep link status.
 *
 *  @see showUnreadInAppNotificationUI and showInAppNotificationUI methods.
 *
 *  - Since: 2.3.0
 *
 */
-(void) inAppMessageButtonHandlerWithIndex:(NSInteger) buttonIndex
                               buttonTitle:(NSString *) title
                       containingURLString:(NSString *) urlString
                        withDeepLinkStatus:(PyzeDeepLinkStatus) status;

@end


/**
 *  PyzeInAppStatus
 *  This class contains return status when any of the button pressed in in-app message.
 */
@interface PyzeInAppStatus : NSObject

/**
 *  Button index, if provided or else be zero
 */
@property (nonatomic, assign) NSInteger buttonIndex;

/**
 *  Message-ID of the in-app message.
 */
@property (nonatomic, strong) NSString *messageID;
/**
 *  Campaign-IDof the in-app message.
 */
@property (nonatomic, strong) NSString *campaignID;
/**
 *  Title of the message. 'title' can be nil.
 */
@property (nonatomic, strong) NSString *title;
/**
 *  Url string of the message for deeplink purpose. This can be nil.
 */
@property (nonatomic, strong) NSString *urlString;

/**
 *  Status of the deeplink.
 */
@property (nonatomic, assign) PyzeDeepLinkStatus status;

@end

#pragma mark - Pyze Personalization Intelligence

/**
 *  PyzePersonalizationIntelligence  
 *  See: http://pyze.com/iOS-Personalization.html and http://pyze.com/product/personalization-intelligence.html for more details.
 *
 *  This class provides access to get the personalization intelligence tags. These tags are set in the intelligence explorer.
 *
 *  - Since: 2.6.0
 */

@interface PyzePersonalizationIntelligence : NSObject

/**
 *  Get all tags assigned to the user.  Note: Tags are case sensitive, "High Value" and "high value" are different tags.
 *
 *    [PyzePersonalizationIntelligence getTags:^(NSArray *tagsList) {
 *         NSLog(@"PyzePersonalizationIntelligence tags = %@", tagsList);
 *    }];
 *
 *  @param completionHandler Handler with array of tag strings or nil.
 */
+(void) getTags:(void (^) (NSArray * tagsList)) completionHandler;


/**
 *  Returns true if requested tag is assigned to user.   Note: Tags are case sensitive, "High Value" and "high value" are different tags
 *
 *      NSLog(@"isTagSet = %d", [PyzePersonalizationIntelligence isTagSet:@"loyal"]);
 *
 *  @param tag The selected tag.
 *
 *  @return Returns YES if found.
 */
+(BOOL) isTagSet:(NSString *) tag;

/**
 *  Returns true if at least one tag is assigned.    Note: Tags are case sensitive, "High Value" and "high value" are different tags.
 *
 *      NSLog(@"areAnyTagsSet = %d",[PyzePersonalizationIntelligence areAnyTagsSet:@[@"High value"]]);
 *
 *  @param tagsList The array tag list strings.
 *
 *  @return Returns YES if any of the tags is found.
 */
+(BOOL) areAnyTagsSet:(NSArray *) tagsList;


/**
 *  Returns true if all tags specified are assigned to user.   Note: Tags are case sensitive, "High Value" and "high value" are different tags.
 *
 *     NSLog(@"areAllTagsSet = %d", [PyzePersonalizationIntelligence areAllTagsSet:@[@"loyal", @"whale",@"High value"]]);
 *
 *  @param tagsList The array tag list strings.
 *
 *  @return Returns YES if all of the tags are found.
 */
+(BOOL) areAllTagsSet:(NSArray *) tagsList;

@end
