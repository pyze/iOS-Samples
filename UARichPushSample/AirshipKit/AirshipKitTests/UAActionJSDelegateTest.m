/* Copyright 2017 Urban Airship and Contributors */

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "UAActionRegistry.h"
#import "UAActionJSDelegate.h"
#import "NSJSONSerialization+UAAdditions.h"
#import "UAWebViewCallData.h"
#import "UAirship.h"
#import "UARichContentWindow.h"
#import "UAConfig.h"

@interface UAActionJSDelegateTest : XCTestCase
@property (nonatomic, strong) UAActionJSDelegate *jsDelegate;
@property (nonatomic, strong) UAActionRegistry *registry;
@property (nonatomic, strong) id mockAirship;
@property (nonatomic, strong) id mockConfig;
@property (nonatomic, strong) JSContext *jsContext;
@property (nonatomic, copy) NSString *nativeBridge;
@property (nonatomic, strong) id mockUIWebView;
@property (nonatomic, strong) id mockRichContentWindow;
@property (nonatomic, strong) id mockWKWebViewDelegate;
@property (nonatomic, assign) BOOL useWKWebView;
@end

@implementation UAActionJSDelegateTest

- (void)setUp {
    [super setUp];
    self.jsDelegate = [[UAActionJSDelegate alloc] init];
    self.registry = [UAActionRegistry defaultRegistry];

    // Mock Airship
    self.mockAirship = [OCMockObject niceMockForClass:[UAirship class]];
    [[[self.mockAirship stub] andReturn:self.mockAirship] shared];
    [[[self.mockAirship stub] andReturn:self.registry] actionRegistry];

    self.jsContext = [[JSContext alloc] initWithVirtualMachine:[[JSVirtualMachine alloc] init]];

    // UAirship is only used for storage here, since it's normally injected when setting up a UIWebView
    [self.jsContext evaluateScript:@"UAirship = {}"];

    self.mockUIWebView = [OCMockObject niceMockForClass:[UIWebView class]];
    self.mockRichContentWindow = [OCMockObject niceMockForProtocol:@protocol(UARichContentWindow)];
    [[[self.mockUIWebView stub] andReturn:self.mockRichContentWindow] delegate];
    
    self.mockWKWebViewDelegate = [OCMockObject niceMockForProtocol:@protocol(UAWKWebViewDelegate)];
    
    // Mock Config & useWKWebView
    self.useWKWebView = NO;
    self.mockConfig = [OCMockObject niceMockForClass:[UAConfig class]];
    [[[self.mockConfig stub] andDo:^(NSInvocation *invocation) {
        BOOL useWKWebView = self.useWKWebView;
        [invocation setReturnValue:&useWKWebView];
    }] useWKWebView];
    [[[self.mockAirship stub] andReturn:self.mockConfig] config];
}

- (void)tearDown {
    [self.mockAirship stopMocking];
    [self.mockWKWebViewDelegate stopMocking];
    [self.mockUIWebView stopMocking];
    [self.mockConfig stopMocking];
    [self.mockRichContentWindow stopMocking];
    [super tearDown];
}

- (void)performWebViewCallWithURL:(NSURL *)url completionHandler:(void (^)(NSString *))handler {
    UAWebViewCallData *callData = nil;
    if (self.useWKWebView) {
        callData = [UAWebViewCallData callDataForURL:url delegate:self.mockWKWebViewDelegate];
    } else {
        callData = [UAWebViewCallData callDataForURL:url webView:self.mockUIWebView];
    }
    [self.jsDelegate callWithData:callData withCompletionHandler:handler];
}

/**
 * Helper method for verifying the correctness of JS delegate
 * calls and resulting callbacks
 */
- (void)verifyWebViewCallWithURL:(NSURL *)url
                  expectingError:(BOOL)expectingError
                  expectedResult:(id)expectedResult
                      callbackID:(NSString *)callbackID {
    __block id resultValue;
    __block NSDictionary *errorValue;
    __block BOOL finished = NO;
    __block NSString *cbID;

    // JavaScriptCore bridges JS nulls as NSNull
    if (!expectedResult) {
        expectedResult = [NSNull null];
    }

    // Function invoked by the runAction callback, for verification
    self.jsContext[@"UAirship"][@"finishAction"] = ^(NSDictionary *error, id result, NSString *callbackID){
        finished = YES;
        resultValue = result;
        errorValue = error;
        cbID = callbackID;
    };

    // Call the JS Delegate with the data. The resulting script in the completion handler should be
    // some form of UAirship.finishAction, which we verify below
    [self performWebViewCallWithURL:url completionHandler:^(NSString *script){
        // if a callback ID was passed, evaluate the resulting script and compare actual and expected
        // results/errors
        if (callbackID) {
            [self.jsContext evaluateScript:script];
            if (expectingError) {
                XCTAssertNotNil(errorValue, @"The webview call should have resulted in an error");
                // If there's an error, it should at least have message
                XCTAssertNotNil(errorValue[@"message"]);
            }
            XCTAssertEqualObjects(expectedResult, resultValue, @"The result should match the expected result");
            XCTAssertTrue(finished, @"UAirship.finishAction should have been called");
            XCTAssertEqualObjects(callbackID, cbID, @"The callback ID should match the expected callback ID");
        }
    }];
}

/**
 * Test running actions with a callback
 */
- (void)testRunActionCB {

    UAAction *test = [UAAction actionWithBlock:^(UAActionArguments *args, UAActionCompletionHandler handler) {
        handler([UAActionResult resultWithValue:args.value]);
    }];

    [self.registry registerAction:test name:@"test_action"];

    UAAction *unserializable = [UAAction actionWithBlock:^(UAActionArguments *args, UAActionCompletionHandler handler) {
        handler([UAActionResult resultWithValue:self]);
    }];

    [self.registry registerAction:unserializable name:@"unserializable"];

    NSURL *url = [NSURL URLWithString:@"uairship://run-action-cb/test_action/%22hi%22/callback-ID-1"];

    [self verifyWebViewCallWithURL:url expectingError:NO expectedResult:@"hi" callbackID:@"callback-ID-1"];

    //this produces an unserializable result, which should be converted into a string description
    url = [NSURL URLWithString:@"uairship://run-action-cb/unserializable/%22hi%22/callback-ID-2"];

    [self verifyWebViewCallWithURL:url expectingError:NO expectedResult:self.description callbackID:@"callback-ID-2"];
}

/**
 * Test running an action with a callback with invalid number of arguments.
 */
- (void)testRunActionCBInvalidArgs {
    // Invalid action argument value because it is missing arguments
    NSURL *url = [NSURL URLWithString:@"uairship://run-action-cb/junk"];

    [self verifyWebViewCallWithURL:url expectingError:NO expectedResult:nil callbackID:nil];
}

/**
 * Test running an action with a callback, when specifying a non-existent action
 */
- (void)testRunActionCBInvalidAction {
    // This action doesn't exist, so should result in an error
    NSURL *url = [NSURL URLWithString:@"uairship://run-action-cb/bogus_action/%22hi%22/callback-ID-1"];

    [self verifyWebViewCallWithURL:url expectingError:YES expectedResult:nil callbackID:@"callback-ID-1"];
}

/**
 * Test running an action with a callback and no arguments
 */
- (void)testRunActionCBEmptyArgs {
    UAAction *test = [UAAction actionWithBlock:^(UAActionArguments *args, UAActionCompletionHandler handler) {
        XCTAssertNil(args.value);
        handler([UAActionResult resultWithValue:@"howdy"]);
    }];

    [self.registry registerAction:test name:@"test_action"];

    NSURL *url = [NSURL URLWithString:@"uairship://run-action-cb/test_action/null/callback-ID-1"];

    [self verifyWebViewCallWithURL:url expectingError:NO expectedResult:@"howdy" callbackID:@"callback-ID-1"];
}


/**
 * Test the run-actions variant
 */
- (void)testRunActions {
    __block BOOL ran = NO;
    __block BOOL alsoRan = NO;
    __block NSString *result;

    UAAction *test = [UAAction actionWithBlock:^(UAActionArguments *args, UAActionCompletionHandler handler) {
        ran = YES;
        handler([UAActionResult resultWithValue:@"howdy"]);
    }];

    UAAction *alsoTest = [UAAction actionWithBlock:^(UAActionArguments *args, UAActionCompletionHandler handler) {
        alsoRan = YES;
        handler([UAActionResult resultWithValue:@"yeah!"]);
    }];

    [self.registry registerAction:test name:@"test_action"];
    [self.registry registerAction:alsoTest name:@"also_test_action"];

    NSURL *url = [NSURL URLWithString:@"uairship://run-actions?test_action=%22hi%22&also_test_action"];

    [self performWebViewCallWithURL:url completionHandler:^(NSString *script) {
        result = script;
    }];

    XCTAssertNil(result, @"run-basic-actions should not produce a script result");
    XCTAssertTrue(ran, @"the action should have run");
    XCTAssertTrue(alsoRan, @"the other action should have run");
}

/**
 * Test encoding a non-existent action name in the run-actions variant
 */
- (void)testRunActionsInvalidAction {
    __block NSString *result;

    NSURL *url = [NSURL URLWithString:@"uairship://run-actions?bogus_action=%22hi$22"];

    [self performWebViewCallWithURL:url completionHandler:^(NSString *script) {
        result = script;
    }];

    XCTAssertNil(result, @"run-actions should not produce a script result");
}

/**
 * Test encoding invalid arguments in the run-actions variant
 */
- (void)testRunActionsInvalidArgs {
    __block NSString *result;
    __block BOOL ran = NO;

    UAAction *test = [UAAction actionWithBlock:^(UAActionArguments *args, UAActionCompletionHandler handler) {
        ran = YES;
        handler([UAActionResult resultWithValue:@"howdy"]);
    }];

    [self.registry registerAction:test name:@"test_action"];

    NSURL *url = [NSURL URLWithString:@"uairship://run-actions?test_action=blah"];

    [self performWebViewCallWithURL:url completionHandler:^(NSString *script) {
        result = script;
    }];

    XCTAssertFalse(ran, @"no action should have run");
    XCTAssertNil(result, @"run-basic-actions should not produce a script result");
}

/**
 * Test encoding the same args multiple times in the run-actions variant
 */
- (void)testRunActionsMultipleArgs {
    __block int runCount = 0;
    __block NSString *result;

    UAAction *test = [UAAction actionWithBlock:^(UAActionArguments *args, UAActionCompletionHandler handler) {
        runCount ++;
        handler([UAActionResult resultWithValue:@"howdy"]);
    }];

    [self.registry registerAction:test name:@"test_action"];

    NSURL *url = [NSURL URLWithString:@"uairship://run-actions?test_action&test_action"];

    [self performWebViewCallWithURL:url completionHandler:^(NSString *script) {
        result = script;
    }];

    XCTAssertNil(result, @"run-actions should not produce a script result");
    XCTAssertEqual(runCount, 2, @"the action should have run 2 times");
}

/**
 * Test the run-basic-actions variant
 */
- (void)testRunBasicActions {
    __block BOOL ran = NO;
    __block BOOL alsoRan = NO;
    __block NSString *result;

    UAAction *test = [UAAction actionWithBlock:^(UAActionArguments *args, UAActionCompletionHandler handler) {
        ran = YES;
        handler([UAActionResult resultWithValue:@"howdy"]);
    }];

    UAAction *alsoTest = [UAAction actionWithBlock:^(UAActionArguments *args, UAActionCompletionHandler handler) {
        alsoRan = YES;
        handler([UAActionResult resultWithValue:@"yeah!"]);
    }];

    [self.registry registerAction:test name:@"test_action"];
    [self.registry registerAction:alsoTest name:@"also_test_action"];

    NSURL *url = [NSURL URLWithString:@"uairship://run-basic-actions?test_action=hi&also_test_action"];

    [self performWebViewCallWithURL:url completionHandler:^(NSString *script) {
        result = script;
    }];

    XCTAssertNil(result, @"run-basic-actions should not produce a script result");
    XCTAssertTrue(ran, @"the action should have run");
    XCTAssertTrue(alsoRan, @"the other action should have run");
}

/**
 * Test encoding multiple instances of the same argument in the run-basic-actions variant
 */
- (void)testRunBasicActionsMultipleArgs {
     __block int runCount = 0;
    __block NSString *result;

    UAAction *test = [UAAction actionWithBlock:^(UAActionArguments *args, UAActionCompletionHandler handler) {
        runCount ++;
        handler([UAActionResult resultWithValue:@"howdy"]);
    }];

    [self.registry registerAction:test name:@"test_action"];

    NSURL *url = [NSURL URLWithString:@"uairship://run-basic-actions?test_action&test_action"];

    [self performWebViewCallWithURL:url completionHandler:^(NSString *script) {
        result = script;
    }];

    XCTAssertNil(result, @"run-basic-actions should not produce a script result");
    XCTAssertEqual(runCount, 2, @"the action should have run 2 times");
}

/**
 * Test encoding a non-existent action in the run-basic-actions variant
 */
- (void)testRunInvalidAction {
    __block NSString *result;

    NSURL *url = [NSURL URLWithString:@"uairship://run-basic-actions?bogus_action=hi"];

    [self performWebViewCallWithURL:url completionHandler:^(NSString *script) {
        result = script;
    }];

    XCTAssertNil(result, @"run-basic-actions should not produce a script result");
}

/**
 * Test close method
 */

- (void)testCloseMethodWithUIWebView {
    self.useWKWebView = NO;
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
    [[self.mockRichContentWindow expect] closeWebView:self.mockUIWebView animated:YES];
#pragma GCC diagnostic pop
    
    NSURL *url = [NSURL URLWithString:@"uairship://close"];
    [self performWebViewCallWithURL:url completionHandler:nil];
    
    [self.mockRichContentWindow verify];
}

- (void)testCloseMethodWithWKWebView {
    self.useWKWebView = YES;
    [[self.mockWKWebViewDelegate expect] closeWindowAnimated:YES];
    
    NSURL *url = [NSURL URLWithString:@"uairship://close"];
    [self performWebViewCallWithURL:url completionHandler:nil];
    
    [self.mockWKWebViewDelegate verify];
}


@end
