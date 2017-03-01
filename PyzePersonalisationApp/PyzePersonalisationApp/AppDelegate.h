
#import <UIKit/UIKit.h>

#define MAIN_NAVIGATION_CONTROLLER ((AppDelegate *)[[UIApplication sharedApplication] delegate]).rootNavigationController
#define APP_DELEGATE (AppDelegate *)[[UIApplication sharedApplication] delegate]

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *rootNavigationController;
@end

