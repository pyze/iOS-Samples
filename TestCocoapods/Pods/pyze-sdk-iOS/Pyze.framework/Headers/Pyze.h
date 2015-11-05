/*!
 ## Pyze
 Main class for the Pyze iOS sdk.
 With this class, the SDK will be initialized with the APP key provided by Pyze team.
 You can also use this class to see the logs which would be sent to server when you post any
 event to the server based on the priority set, however this will log only in the debug 
 configuration. In the release mode or deployment the SDK will log minimally.
  */

#import <UIKit/UIKit.h>

#import "PyzeEvent.h"

//! Project version number for Pyze.
FOUNDATION_EXPORT double PyzeVersionNumber;

typedef enum{
    PyzelogLevelMinimal = 0,
    PyzelogLevelWarnings = 1,
    PyzelogLevelErrors = 2,
    PyzelogLevelAll = 3
} PyzeLogLevel;


@interface Pyze : NSObject

/*!
 *  Get the shared instance of Pyze API.
 *
 *  @return Pyze instance type.
 */


+ (Pyze*) sharedPyze;

/*!
 *  Log throttling level to be used in the lib while target is in debug mode.
 *
 *  @param logLevel Log level you would wish to see in the console.
 */

-(void) logThrottling:(PyzeLogLevel) logLevel;

/*!
 *  Initializes the Pyze library. Call this method in the app delegate's method
 *  application:willFinishLaunchingWithOptions.
 *
 *  @param pyzeAppKey The SDK key received from the Pyze.com
 */
- (void) initializeWithKey:(NSString *) pyzeAppKey;

-(instancetype) init NS_UNAVAILABLE;

@end
