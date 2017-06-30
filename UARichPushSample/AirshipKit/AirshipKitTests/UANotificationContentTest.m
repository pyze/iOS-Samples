/* Copyright 2017 Urban Airship and Contributors */

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "UANotificationContent.h"
#import <UserNotifications/UserNotifications.h>

@interface UANotificationContentTest : XCTestCase

@property (nonatomic, strong) id mockedUNNotification;
@property (nonatomic, strong) NSDictionary *notification;
@property (nonatomic, strong) NSDictionary *notificationWithBody;
@property (nonatomic, strong) NSString *testKey;
@property (nonatomic, strong) NSString *testValue;

@end

@implementation UANotificationContentTest

- (void)setUp {
    [super setUp];

    self.mockedUNNotification = [OCMockObject niceMockForClass:[UNNotification class]];

    self.testKey = nil;
    self.testValue = nil;
    self.notification = @{
                          @"aps": @{
                                  @"alert": @"alert",
                                  @"badge": @2,
                                  @"sound": @"cat",
                                  @"category": @"category",
                                  @"content-available": @1
                                  }
                          };

    self.notificationWithBody = @{
                                  @"aps": @{
                                          @"alert": @{
                                                  @"title": @"alertTitle",
                                                  @"body": @"alertBody",
                                                  @"loc-key": @"localizationKey",
                                                  @"action-loc-key": @"actionLocalizationKey",
                                                  @"loc-args":@"localizationArguments",
                                                  @"title-loc-key": @"titleLocalizationKey",
                                                  @"title-loc-args": @"titleLocalizationArguments",
                                                  @"launch-image":@"launchImage"
                                                  },
                                          @"badge": @2,
                                          @"sound": @"cat",
                                          @"category": @"category",
                                          @"content-available": @1
                                          },
                                  };
}

- (void)tearDown {

    [self.mockedUNNotification stopMocking];

    [super tearDown];
}

// Tests UNNotification is properly initialized when a UANotificationContent instance is created from a UNNotification
-(void)testNotificationContentFromUNNotification {

    UANotificationContent *notificationContent = [UANotificationContent notificationWithUNNotification:self.mockedUNNotification];

    XCTAssertEqualObjects(notificationContent.notification, self.mockedUNNotification);
}

// Tests notification content creation when the input notification dictionary does not include an alert body
-(void)testNotificationContentFromNotificationDictionary {
    UANotificationContent *notification = [UANotificationContent notificationWithNotificationInfo:self.notification];

    // Alert Body
    XCTAssertTrue([notification.alertBody isEqualToString:self.notification[@"aps"][@"alert"]]);

    // Badge
    XCTAssertTrue([notification.badge isEqualToNumber:self.notificationWithBody[@"aps"][@"badge"]]);

    // Sound
    XCTAssertTrue([notification.sound isEqualToString:self.notificationWithBody[@"aps"][@"sound"]]);

    // Category
    XCTAssertTrue([notification.categoryIdentifier isEqualToString:self.notificationWithBody[@"aps"][@"category"]]);

    // Raw Notification
    XCTAssertTrue([notification.notificationInfo isEqualToDictionary:self.notification]);
}

// Tests notification content creation when the input notification dictionary includes an alert body
-(void)testNotificationContentFromNotificationDictionaryWithAlertBody {
    UANotificationContent *notification = [UANotificationContent notificationWithNotificationInfo:self.notificationWithBody];

    // Alert Title
    XCTAssertTrue([notification.alertTitle isEqualToString:self.notificationWithBody[@"aps"][@"alert"][@"title"]]);

    // Alert Body
    XCTAssertTrue([notification.alertBody isEqualToString:self.notificationWithBody[@"aps"][@"alert"][@"body"]]);

    // Badge
    XCTAssertTrue(notification.badge == self.notificationWithBody[@"aps"][@"badge"]);

    // Sound
    XCTAssertTrue([notification.sound isEqualToString:self.notificationWithBody[@"aps"][@"sound"]]);

    // Category
    XCTAssertTrue([notification.categoryIdentifier isEqualToString:self.notificationWithBody[@"aps"][@"category"]]);

    // Localization Keys
    XCTAssertTrue([notification.localizationKeys[@"loc-key"] isEqualToString:self.notificationWithBody[@"aps"][@"alert"][@"loc-key"]]);
    XCTAssertTrue([notification.localizationKeys[@"action-loc-key"] isEqualToString:self.notificationWithBody[@"aps"][@"alert"][@"action-loc-key"]]);
    XCTAssertTrue([notification.localizationKeys[@"title-loc-key"] isEqualToString:self.notificationWithBody[@"aps"][@"alert"][@"title-loc-key"]]);
    XCTAssertTrue([notification.localizationKeys[@"title-loc-args"] isEqualToString:self.notificationWithBody[@"aps"][@"alert"][@"title-loc-args"]]);

    // Launch Image
    XCTAssertTrue([notification.launchImage isEqualToString:self.notificationWithBody[@"aps"][@"alert"][@"launch-image"]]);

    // Raw Notification
    XCTAssertTrue([notification.notificationInfo isEqualToDictionary:self.notificationWithBody]);
}

@end
