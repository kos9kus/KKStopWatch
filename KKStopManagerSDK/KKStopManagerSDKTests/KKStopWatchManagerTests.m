//
//  KKStopWatchManagerTests.m
//  StopWatchBeta
//
//  Created by KONSTANTIN KUSAINOV on 02/07/16.
//  Copyright © 2016 Kos9Kus. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "KKWeakTimer.h"
#import "KKStopWatchManager.h"

@interface KKStopWatchManager (KKWeakTimerTests)

@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic) NSTimeInterval startEndInterval;
@property (nonatomic, strong) NSString *currentTime;
@property (nonatomic, strong) NSDate *pauseDate;

- (NSString*)formatToStringFromTimeInterval:(NSTimeInterval)interval;
- (NSString*)addPostfixToDateString:(NSString*)dateString withTimeInterval:(NSTimeInterval)interval;

@end

@interface KKStopWatchManagerTests : XCTestCase <KKStopWatchManagerDelegate> {
    KKStopWatchManager *sw;
    XCTestExpectation *expectTest;
}

@end

@implementation KKStopWatchManagerTests

- (void)setUp {
    [super setUp];
    //    expectTest = [self expectationWithDescription:@"KKStopWatchManagerTests"];
    sw = [KKStopWatchManager createNewStopWatchManager:self];
}

- (void)testToFormatToString {
    NSString *stringTime = [sw formatToStringFromTimeInterval:7265.977627];
    XCTAssert([@"2:01:05" isEqualToString:stringTime]);
}

- (void)testToFormatToStringWithZeroSec {
    NSString *stringTime = [sw formatToStringFromTimeInterval:0];
    XCTAssert([@"0:00:00" isEqualToString:stringTime]);
}

- (void)testAddPostfixMillisec {
    NSString *stringTime = [sw formatToStringFromTimeInterval:7265.977627];
    NSString *outString = [sw addPostfixToDateString:stringTime withTimeInterval:7265.977627];
    XCTAssert([@"2:01:05.977" isEqualToString:outString]);
}

- (void)testAddPostfixWithZeroMillisec {
    NSString *stringTime = [sw formatToStringFromTimeInterval:0.000];
    NSString *outString = [sw addPostfixToDateString:stringTime withTimeInterval:0.00];
    XCTAssert([@"0:00:00" isEqualToString:outString]);
}

- (void)testPauseAction {
    sw.startDate = [NSDate dateWithTimeIntervalSinceNow:(-1) * 125];
    sw.startEndInterval = [[NSDate date] timeIntervalSinceDate:sw.startDate];
    [sw commitStopWatchAction:KKStopWatchManagerActionTypePause];
    NSLog(@"sw.currentTime");
    XCTAssert([@"0:02:05" isEqualToString:sw.currentTime]);
}

- (void)testResumeAction {
    expectTest = [self expectationWithDescription:@"KKStopWatchManagerTests"];
    
    sw.startDate = [NSDate dateWithTimeIntervalSinceNow:(-1) * 125];
    [sw commitStopWatchAction:KKStopWatchManagerActionTypePause];
    sleep(2);
    [sw commitStopWatchAction:KKStopWatchManagerActionTypeResume];
    [self waitForExpectationsWithTimeout:10 handler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", error);
        }
    }];
    
    sw = nil;
}


#pragma mark - KKStopWatchManagerDelegate

- (void)didTickTimer:(KKStopWatchManager *)stopWatchManager {
    if ([stopWatchManager.currentTime isEqualToString:@"0:02:08"]) {
        [expectTest fulfill];
    }
    NSLog(@"Tick Timer: %@", stopWatchManager.currentTime);
}


@end
