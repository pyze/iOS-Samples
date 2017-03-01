
#import <Foundation/Foundation.h>
#import "PATravelInfo.h"
#import "PAUser.h"

@interface PAFeedManager : NSObject

+ (void) fetchUserDetailsForId:(NSString *)userId completionHandler:(void (^)(PAUser * user)) completionHandler;
+ (void) fetchLoginInfo:(void (^)(NSMutableArray * loginInfo)) completionHandler;
+ (void) fetchTravelInfo:(void (^)(PATravelInfo * travelInfo)) completionHandler;

@end
