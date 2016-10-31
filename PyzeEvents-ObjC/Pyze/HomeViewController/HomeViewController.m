//
//  HomeViewController.m
//  Pyze
//
//  Created by Ramachandra Naragund on 09/10/15.
//  Copyright © 2015 Pyze Technologies Pvt Ltd. All rights reserved.
//

#import "HomeViewController.h"

#import <CoreLocation/CoreLocation.h>

#import <Pyze/Pyze.h>

@interface HomeViewController () <UIPopoverPresentationControllerDelegate,PyzeInAppMessageHandlerDelegate,CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *eventsButton;
@property (weak, nonatomic) IBOutlet UIButton *showInAppButton;
@property (nonatomic,strong) CLLocationManager * locationManager;
@property (weak, nonatomic) IBOutlet UIButton *locationsBtn;


- (IBAction)showInAppMessage:(UIButton *)sender;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIColor *ios7BlueColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
//
    self.eventsButton.layer.borderColor = ios7BlueColor.CGColor;
    self.showInAppButton.layer.borderColor = ios7BlueColor.CGColor;
    self.locationsBtn.layer.borderColor = ios7BlueColor.CGColor;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
 
    [Pyze addBadge:self.showInAppButton];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (IBAction)showInAppMessage:(UIButton *)sender
{
    [Pyze showInAppNotificationUI:self
               forDisplayMessages:PyzeInAppTypeAll
        msgNavBarButtonsTextColor:[UIColor whiteColor]
          msgNavBarButtonsBgColor:[UIColor grayColor]
                 msgNavBarBgColor:[UIColor clearColor]
        msgNavBarCounterTextColor:[UIColor blueColor]];
}

-(void) inAppMessageButtonHandlerWithIndex:(NSInteger) buttonIndex
                               buttonTitle:(NSString *) title
                       containingURLString:(NSString *) urlString
                        withDeepLinkStatus:(PyzeDeepLinkStatus) status;

{
    NSLog(@"Button Index = %d, button title = %@ and urlInfo = %@",(int) buttonIndex, title, urlString);
}
- (IBAction)enableLocations:(id)sender
{
    if (self.locationManager == nil) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.distanceFilter = kCLDistanceFilterNone;
        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [self.locationManager requestWhenInUseAuthorization];
        }
        [self.locationManager startUpdatingLocation];
        
        [self performSelector:@selector(stopUpdatingLocationWithMessage:)
                   withObject:@"Timed Out"
                   afterDelay:15];
    }
}


- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation * location = [locations lastObject];
    NSLog(@"%@",[NSString stringWithFormat:@"%.4f,%.4f,%@",fabs(location.coordinate.latitude), fabs(location.coordinate.longitude), [NSDate date]] );
}

- (void)stopUpdatingLocationWithMessage:(NSString *)state {
    //    self.stateString = state;
    [self.locationManager stopUpdatingLocation];
    self.locationManager.delegate = nil;
}


@end
