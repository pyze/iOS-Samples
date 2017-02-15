
#import <Foundation/Foundation.h>
#import <Pyze/Pyze.h>

#pragma mark - InAppTemplateData

@interface InAppTemplateData : NSObject

@property (nonatomic, strong) NSString * imageURL;
@property (nonatomic, assign) NSInteger imageWidth;
@property (nonatomic, assign) NSInteger imageHeight;
@property (nonatomic, strong) NSString *optionalBase64Image;
@property (nonatomic, strong) NSString *titleColorHex;
@property (nonatomic, strong) NSString *msgColor;
@property (nonatomic, strong) NSArray *buttons;
@property (nonatomic, strong) NSString *templateID;
@property (nonatomic, strong) NSString *canvasBgColor;
@property (nonatomic, assign) BOOL textOverlapsImage;

-(instancetype) initWithDictionary : (NSDictionary *) inDictionary loadDefaults:(BOOL) load;

@end

#pragma mark - InAppModel

@interface InAppModel : NSObject

@property (nonatomic, strong) NSString *msg;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *templateID;
@property (nonatomic, strong) InAppTemplateData *templateData;

-(instancetype) initWithDictionary : (NSDictionary *) inDictionary loadDefaults:(BOOL) load;

@end

#pragma mark - InAppMessageManager

@interface InAppMessageManager : NSObject

@property (assign, nonatomic) PyzeInAppMessageType activeInAppMessageType;
@property (assign, nonatomic) NSInteger messageActiveIndex;
@property (assign, nonatomic) NSInteger inAppMessageCount;

+ (instancetype) sharedManager;
- (void) countNewUnFetched:(void (^)(NSInteger))completionHandler;
- (void) updateIndex:(BOOL)isIncrement;
- (BOOL) isLastMessage;
- (void) nextMessage:(void (^)(InAppModel * messageObj)) completionHandler;
- (void) previousMessage:(void (^)(InAppModel * messageObj))completionHandler;
- (void) fetchHeadersForType:(PyzeInAppMessageType)type completionHandler:(void (^)(void))handler;

@end
