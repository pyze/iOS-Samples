/* Copyright 2017 Urban Airship and Contributors */

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "UAURLRequestOperation+Internal.h"

@interface UAURLRequestOperationTest : XCTestCase
@property (nonatomic, strong) id mockRequest;
@property (nonatomic, strong) id mockSession;
@end

@implementation UAURLRequestOperationTest

- (void)setUp {
    [super setUp];
    self.mockRequest = [OCMockObject niceMockForClass:[NSURLRequest class]];
    self.mockSession = [OCMockObject niceMockForClass:[NSURLSession class]];

}

- (void)tearDown {
    [self.mockRequest stopMocking];
    [self.mockSession stopMocking];

    [super tearDown];
}


- (void)testDefaults {
    UAURLRequestOperation *operation = [UAURLRequestOperation operationWithRequest:self.mockRequest
                                                                           session:self.mockSession
                                                                 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {}];

    XCTAssertEqual(operation.isAsynchronous, YES);
    XCTAssertEqual(operation.isExecuting, NO);
    XCTAssertEqual(operation.isCancelled, NO);
    XCTAssertEqual(operation.isFinished, NO);
}

- (void)testOperation {
    NSData *testData = [NSData data];
    NSURLResponse *testResponse = [[NSURLResponse alloc] init];
    NSError *testError = [NSError errorWithDomain:@"domain" code:100 userInfo:nil];

    __block BOOL operationFinished = NO;

    UAURLRequestOperation *operation = [UAURLRequestOperation operationWithRequest:self.mockRequest
                                                                           session:self.mockSession
                                                                 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                                     XCTAssertEqual(testData, data);
                                                                     XCTAssertEqual(testResponse, response);
                                                                     XCTAssertEqual(testError, error);
                                                                     operationFinished = YES;
                                                                 }];


    XCTestExpectation *operationPerformedRequest = [self expectationWithDescription:@"operation performed request"];

    // Expect a call and capture the callback and fulfill the test expectation
    __block void (^completionHandler)(NSData *, NSURLResponse *, NSError *) = nil;
    [[[self.mockSession expect] andDo:^(NSInvocation *invocation) {
        void *arg;
        [invocation getArgument:&arg atIndex:3];
        completionHandler = (__bridge void (^)(NSData *, NSURLResponse *, NSError *))arg;
        [operationPerformedRequest fulfill];
    }] dataTaskWithRequest:self.mockRequest completionHandler:OCMOCK_ANY];

    // Start the operation
    [operation start];

    // Should be in flight
    XCTAssertEqual(operation.isExecuting, YES);
    XCTAssertEqual(operation.isFinished, NO);
    XCTAssertEqual(operationFinished, NO);

    // Wait for the operation to call the request
    [self waitForExpectationsWithTimeout:1 handler:nil];
    [self.mockRequest verify];

    // Call the completion handler
    completionHandler(testData, testResponse, testError);

    // Operation should be finished
    XCTAssertEqual(operation.isExecuting, NO);
    XCTAssertEqual(operation.isFinished, YES);
    XCTAssertEqual(operationFinished, YES);
}

- (void)testPreemptiveCancel {
    UAURLRequestOperation *operation = [UAURLRequestOperation operationWithRequest:self.mockRequest
                                                                           session:self.mockSession
                                                                 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {}];

    [operation cancel];
    XCTAssertEqual(operation.isCancelled, YES);

    [operation start];
    XCTAssertEqual(operation.isExecuting, NO);
    XCTAssertEqual(operation.isFinished, YES);
}


@end
