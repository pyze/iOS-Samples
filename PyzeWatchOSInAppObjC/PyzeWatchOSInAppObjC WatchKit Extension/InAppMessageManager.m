
#import "InAppMessageManager.h"


#pragma mark - Class InAppMessageManager

static InAppMessageManager * sharedInstance;

@interface InAppMessageManager ()

@property (strong, nonatomic) NSMutableArray *headers;
@property (assign, nonatomic) BOOL isRequested;

@end


@implementation InAppMessageManager

+ (instancetype) sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[InAppMessageManager alloc] init];
    });
    return sharedInstance;
}

#pragma mark - Setters

-(void)setMessageActiveIndex:(NSInteger)messageActiveIndex {
    _messageActiveIndex = (messageActiveIndex < self.headers.count && messageActiveIndex > 0) ? messageActiveIndex : _messageActiveIndex;
}

#pragma mark - Public methods

- (void) countNewUnFetched:(void (^)(NSInteger))completionHandler {
    [Pyze countNewUnFetched:^(NSInteger count) {
        completionHandler(count);
    }];
}

- (void) updateIndex:(BOOL)shouldIncrement {
    self.messageActiveIndex = (shouldIncrement == NO) ? self.messageActiveIndex - 1 : self.messageActiveIndex + 1;
}

- (BOOL) isLastMessage {
    BOOL isLast = (self.messageActiveIndex == (self.inAppMessageCount - 1)) ?  YES : NO;
    return  isLast;
}

- (void) nextMessage:(void (^)(InAppModel*))completionHandler {
    [self updateIndex:YES];
    [self fetchMessage:^(InAppModel *messageObj) {
        completionHandler(messageObj);
    }];
}

- (void) previousMessage:(void (^)(InAppModel*))completionHandler {
    [self updateIndex:NO];
    [self fetchMessage:^(InAppModel *messageObj) {
        completionHandler(messageObj);
    }];
}

- (void) fetchHeadersForType:(PyzeInAppMessageType)type completionHandler:(void (^)(void))handler {
    
    /* Resetting content */
    self.messageActiveIndex = -1;
    self.activeInAppMessageType = type;
    [self.headers removeAllObjects];
    /* Resetting content */
    
    
    if (self.isRequested == NO) {
        
        self.isRequested = YES;
        
        [Pyze getMessageHeadersForType:type withCompletionHandler:^(NSArray *messageHeaders) {
            if (messageHeaders) {
                for (NSDictionary *header in messageHeaders) {
                    [self.headers addObject:header];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    handler();
                });
                
            }
        }];
        
        
    }
    
}

#pragma mark - Private methods

- (void) fetchMessage:(void (^)(InAppModel * messageObj))completionHandler {
    NSDictionary *headerDict = [self messageHeader];
    [Pyze getMessageBodyWithCampaignID:headerDict[@"cid"]
                          andMessageID:headerDict[@"mid"]
                 withCompletionHandler:^(NSDictionary *messageBody) {
                     
        if (messageBody) {
            NSDictionary *payload = messageBody[@"payload"];
            if (payload) {
                InAppModel *inAppObj = [[InAppModel alloc] initWithDictionary:payload loadDefaults:NO];
                completionHandler(inAppObj);
            }
        }
    }];
}

- (NSDictionary *) messageHeader{
    return self.headers[self.messageActiveIndex];
}

@end


#pragma mark - Class InAppModel

@implementation InAppModel


-(instancetype) initWithDictionary : (NSDictionary *) inDictionary loadDefaults:(BOOL) load{
    
    self = [super init];
    if (self) {
        if (inDictionary && inDictionary.count) {
            self.msg = inDictionary[@"msg"];
            self.title = inDictionary[@"title"];
            self.templateID = inDictionary[@"templateId"];
            BOOL result = NO;
            if ([self.templateID isEqualToString:@"p_temp_1"])
                result = YES;
            if (inDictionary[@"templateData"]) {
                NSData * data = [inDictionary[@"templateData"] dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary * dicionary = [NSJSONSerialization JSONObjectWithData:data
                                                                           options:0
                                                                             error:nil];
                self.templateData = [[InAppTemplateData alloc] initWithDictionary:dicionary loadDefaults:load];
                self.templateData.textOverlapsImage = result;
            }
        }
    }
    return self;
}


@end



#pragma mark - Class InAppTemplateData

@implementation InAppTemplateData

-(instancetype) initWithDictionary : (NSDictionary *) inDictionary loadDefaults:(BOOL) load{
    
    self = [super init];
    if (self) {
        if (inDictionary && inDictionary.count)
        {
            self.imageURL = inDictionary[@"imageSourceURL"];
            self.optionalBase64Image = inDictionary[@"optionalBase64Image"];
            self.titleColorHex = inDictionary[@"titleColor"];
            self.msgColor = inDictionary[@"msgColor"];
            self.imageWidth = [inDictionary[@"imageWidth"] integerValue];
            self.imageHeight = [inDictionary[@"imageHeight"] integerValue];
            self.buttons = [NSArray arrayWithArray:inDictionary[@"buttons"]];
            self.canvasBgColor = inDictionary[@"canvas_bgColor"];
        }
    }
    return self;
}

@end

