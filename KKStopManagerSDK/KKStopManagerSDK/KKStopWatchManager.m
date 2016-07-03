//
//  KKStopWatchManager.m
//  KKStopWatchManagerLib
//
//  Created by KONSTANTIN KUSAINOV on 02/07/16.
//  Copyright © 2016 Kos9Kus. All rights reserved.
//

#import "KKStopWatchManager.h"
#import "KKWeakTimer.h"

@interface KKStopWatchManager ()<KKWeakTimerProtocol>

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *pauseDate;

@property (nonatomic) NSTimeInterval startEndInterval;

@property (nonatomic, weak) id<KKStopWatchManagerDelegate>delegate;

@end

@implementation KKStopWatchManager

+ (instancetype)createNewStopWatchManager:(id<KKStopWatchManagerDelegate>)delegate {
    return [[KKStopWatchManager alloc] initWithDelegate:delegate];
}

- (instancetype)initWithDelegate:(id<KKStopWatchManagerDelegate>)delegate {
    self = [super init];
    if (self) {
        self.delegate = delegate;
    }
    return self;
}

- (void)dealloc {
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark - Setter

- (void)setCurrentTime:(NSString *)currentTime {
    _currentTime = currentTime;
    if([self.delegate respondsToSelector:@selector(didTickTimer:)]) {
        [self.delegate didTickTimer:self];
    }
}

- (void)setStartEndInterval:(NSTimeInterval)startEndInterval {
    _startEndInterval = startEndInterval;
    self.currentTime = [self formatToStringFromTimeInterval:self.startEndInterval];
}

#pragma mark - Public

- (void)commitStopWatchAction:(KKStopWatchManagerActionType)actionType {
    switch (actionType) {
        case KKStopWatchManagerActionTypeStart: {
            [self cleanUp];
            [self start];
        }
            break;
        case KKStopWatchManagerActionTypePause: {
            [self pause];
        }
            break;
        case KKStopWatchManagerActionTypeResume: {
            [self resume];
        }
            break;
        case KKStopWatchManagerActionTypeReset:
            [self cleanUp];
            break;
    }
}

#pragma mark - Private

- (void)start {
    self.timer = [KKWeakTimer createNewWeakNSTimer:self];
    self.startDate = [NSDate date];
}

- (void)pause {
    [self.timer invalidate];
    self.pauseDate = [NSDate date];
    self.currentTime = [self addPostfixToDateString:self.currentTime withTimeInterval:self.startEndInterval];
}

- (void)resume {
    if (self.pauseDate && self.startDate) {
        [self.timer invalidate];
        NSTimeInterval timePauseContinue = [self.pauseDate timeIntervalSinceDate:self.startDate];
        self.startDate = [NSDate dateWithTimeIntervalSinceNow:(-1) * timePauseContinue];
        self.timer = [KKWeakTimer createNewWeakNSTimer:self];
        [self.timer fire];
    }
    self.pauseDate = nil;
}

#pragma mark -

- (void)cleanUp {
    self.startEndInterval = 0;
    [self.timer invalidate];
    self.pauseDate = nil;
    self.startDate = nil;
}

- (void)updateTimerInterval {
    NSDate *currentDate = [NSDate date];
    self.startEndInterval = [currentDate timeIntervalSinceDate:self.startDate];
}

- (NSString*)addPostfixToDateString:(NSString*)dateString withTimeInterval:(NSTimeInterval)interval {
    float timeFLoat =  interval - (int)interval;
    int intFloat = timeFLoat * 1000;
    
    return intFloat > 0 ? [NSString stringWithFormat:@"%@.%i", dateString ? dateString : @"", intFloat] : [NSString stringWithFormat:@"%@", dateString ? dateString : @"0:00:00.000"];
}

- (NSString*)formatToStringFromTimeInterval:(NSTimeInterval)interval {
    NSDateComponentsFormatter *componentFormatter = [[NSDateComponentsFormatter alloc] init];
    componentFormatter.unitsStyle = NSDateComponentsFormatterUnitsStylePositional;
    componentFormatter.allowedUnits = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    componentFormatter.zeroFormattingBehavior = NSDateComponentsFormatterZeroFormattingBehaviorPad;
    
    return [componentFormatter stringFromTimeInterval:interval];
}

#pragma mark - KKWeakTimerProtocol

- (void)didFireTimer:(NSTimer*)timer {
    if (self.timer == timer) {
        [self updateTimerInterval];
    }
}

@end

