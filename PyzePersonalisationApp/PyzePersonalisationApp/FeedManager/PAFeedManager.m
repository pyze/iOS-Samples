
#import "PAFeedManager.h"
#import "PALoginInfo.h"

#define k_FiletypeJSON @"json"

#define k_PersonalisationAppLoginDetails @"LoginDetails"
#define k_PyzeBlogContent @"PyzeBlogContent"
#define k_PyzeBlogContent @"PyzeBlogContent"
#define k_PyzeTravelContent @"PyzeTravel"


@implementation PAFeedManager

#pragma mark - Public methods

+ (void) fetchUserDetailsForId:(NSString *)userId
             completionHandler:(void (^)(PAUser * user)) completionHandler {
    
    NSDictionary *json = [PAFeedManager jsonObjectFromFile:userId];
    __block PAUser *user = nil;
    
    if ([json isKindOfClass:[NSDictionary class]]) {
        user = [[PAUser alloc] initWithDictionary:json];
    }
    completionHandler(user);
    
}

+ (void) fetchLoginInfo:(void (^)(NSMutableArray * loginInfo)) completionHandler {
    
    NSDictionary *json = [PAFeedManager jsonObjectFromFile:k_PersonalisationAppLoginDetails];
    __block NSMutableArray *userInfoArray = [NSMutableArray array];
    
    if ([json isKindOfClass:[NSDictionary class]]) {
        
        NSArray *userList = json[@"login"];
        if (userList && userList.count) {
            
            for (NSDictionary *loginDict in userList) {
                PALoginInfo *loginInfo = [[PALoginInfo alloc] initWithDictionary:loginDict];
                [userInfoArray addObject:loginInfo];
            }
        }
    }
    completionHandler(userInfoArray);
}


#pragma mark - Private utility methods

+ (NSDictionary *) jsonObjectFromFile:(NSString *)fielName {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fielName ofType:k_FiletypeJSON];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    return json;
}

#pragma mark - Unused

+ (void) fetchBlogContentForId:(NSString *)blogId handler:(void (^)(NSString * blogList)) completionHandler {
    
    NSDictionary *json = [PAFeedManager jsonObjectFromFile:k_PyzeBlogContent];
    __block NSString *content = @"";
    
    if ([json isKindOfClass:[NSDictionary class]]) {
        content = json[blogId];
    }
    completionHandler(content);
    
}

+ (void) fetchTravelInfo:(void (^)(PATravelInfo * travelInfo)) completionHandler {
    
    NSDictionary *json = [PAFeedManager jsonObjectFromFile:k_PyzeTravelContent];
    __block PATravelInfo *travelinfo = nil;
    
    if ([json isKindOfClass:[NSDictionary class]]) {
        travelinfo = [[PATravelInfo alloc] initWithDictionary:json];
    }
    completionHandler(travelinfo);
    
}

@end
