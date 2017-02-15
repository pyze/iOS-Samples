
#import "InAppMessageInterfaceController.h"
#import "InAppMessageManager.h"

@interface InAppMessageInterfaceController ()

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceImage *imageView;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *titleLabel;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *contentLabel;

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceButton *option1;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceButton *option2;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceButton *option3;

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceButton *showNextButton;

@property (assign, nonatomic) BOOL isShowNextTapped;
@property (strong, nonatomic) NSArray *buttonArray;

@end

@implementation InAppMessageInterfaceController

#pragma mark - View life cycle

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    [self fetchMessage];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

-(void)didAppear {
    [super didAppear];
    self.isShowNextTapped = NO;
    
    BOOL shouldHideNext = ([[InAppMessageManager sharedManager] isLastMessage]);
    [self.showNextButton setHidden:shouldHideNext];
}

-(void)willDisappear {
    [super willDisappear];
    if (self.isShowNextTapped == NO) {
        [[InAppMessageManager sharedManager] updateIndex:NO];
    }
}

#pragma mark - Private methods

- (void) fetchMessage {
    
    [[InAppMessageManager sharedManager] nextMessage:^(InAppModel *messageObj) {
       
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.titleLabel setText:messageObj.title];
            [self.contentLabel setText:messageObj.msg];
            [self configureButtons];
            
        });
        
    }];
}

- (void) configureButtons {
    switch (self.buttonArray.count) {
            
        case 0: {
            [self.option1 setHidden:YES];
            [self.option2 setHidden:YES];
            [self.option3 setHidden:YES];
        }
            break;
            
        case 1: {
            [self.option1 setHidden:NO];
            
            NSArray *button1 = self.buttonArray[0];
            NSString *title1 = (button1[0] != nil) ? button1[0] : @"";
            [self.option1 setTitle:title1];
        }
            break;
            
        case 2: {
            [self.option1 setHidden:NO];
            [self.option2 setHidden:NO];
            
            NSArray *button1 = self.buttonArray[0];
            NSString *title1 = (button1[0] != nil) ? button1[0] : @"";
            [self.option1 setTitle:title1];
            
            NSArray *button2 = self.buttonArray[1];
            NSString *title2 = (button2[0] != nil) ? button2[0] : @"";
            [self.option2 setTitle:title2];
        }
            break;
            
        case 3: {
            [self.option1 setHidden:NO];
            [self.option2 setHidden:NO];
            [self.option3 setHidden:NO];
            
            
            NSArray *button1 = self.buttonArray[0];
            NSString *title1 = (button1[0] != nil) ? button1[0] : @"";
            [self.option1 setTitle:title1];
            
            NSArray *button2 = self.buttonArray[1];
            NSString *title2 = (button2[0] != nil) ? button2[0] : @"";
            [self.option2 setTitle:title2];
            
            NSArray *button3 = self.buttonArray[2];
            NSString *title3 = (button3[0] != nil) ? button3[0] : @"";
            [self.option3 setTitle:title3];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - Action methods

- (IBAction)didTapOption1 {
    
    if (self.buttonArray.count >= 1) {
        NSArray *button = self.buttonArray[0];
        NSLog(@"%@ SELECTED", button[0]);
    }
}

- (IBAction)didTapOption2 {
    if (self.buttonArray.count >= 2) {
        NSArray *button = self.buttonArray[1];
        NSLog(@"%@ SELECTED", button[0]);
    }
}

- (IBAction)didTapOption3 {
    if (self.buttonArray.count >= 2) {
        NSArray *button = self.buttonArray[2];
        NSLog(@"%@ SELECTED", button[0]);
    }
}

- (IBAction)didTapShowNext {
    self.isShowNextTapped = YES;
    [self pushControllerWithName:@"InAppMessageUIController" context:nil];
}

- (IBAction)didTapCloseInApp {
    [self popToRootController];
}


@end


@implementation WKInterfaceImage(PyzeExtension)

- (void) setImageWithURL:(NSString *)imageURLString {
    
    NSURL *imageurl = [NSURL URLWithString:imageURLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:imageurl];
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request
                                                                 completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                                     if (error == nil) {
                                                                         if (data) {
                                                                             UIImage *image = [UIImage imageWithData:data];
                                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                                 [self setImage:image];
                                                                             });
                                                                         }
                                                                     }
    }];
    
    [task resume];
}


@end

