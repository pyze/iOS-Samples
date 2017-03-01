
#import "AppDelegate.h"
#import "PADataManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

#pragma mark - Application life cycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [DATA_MANAGER fetchLoginInfo];
    [self customiseTabbarController];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Utility method

- (void) customiseTabbarController {
    
    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
    UITabBar *tabBar = tabBarController.tabBar;

    
    UITabBarItem *tabBarItem = [tabBar.items objectAtIndex:0];
    [tabBarItem setTitle: @"Flights"];
    [tabBarItem setTitlePositionAdjustment:UIOffsetMake(0.0, -10.0)];
    
    tabBarItem = [tabBar.items objectAtIndex:1];
    [tabBarItem setTitle: @"Hotels"];
    [tabBarItem setTitlePositionAdjustment:UIOffsetMake(0.0, -10.0)];
    
    tabBarItem = [tabBar.items objectAtIndex:2];
    [tabBarItem setTitle: @"Cars"];
    [tabBarItem setTitlePositionAdjustment:UIOffsetMake(0.0, -10.0)];
    
    tabBarItem = [tabBar.items objectAtIndex:3];
    [tabBarItem setTitle: @"More"];
    [tabBarItem setTitlePositionAdjustment:UIOffsetMake(0.0, -10.0)];
    
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIColor blackColor], NSForegroundColorAttributeName,
                                                       [UIFont boldSystemFontOfSize:14], NSFontAttributeName,
                                                       nil] forState:UIControlStateNormal];
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIColor whiteColor], NSForegroundColorAttributeName,
                                                       [UIFont boldSystemFontOfSize:14], NSFontAttributeName,
                                                       nil] forState:UIControlStateSelected];
    
}


@end
