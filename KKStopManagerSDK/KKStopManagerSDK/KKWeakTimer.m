//
//  KKWeakTimer.m
//  KKStopWatchManagerLib
//
//  Created by KONSTANTIN KUSAINOV on 02/07/16.
//  Copyright © 2016 Kos9Kus. All rights reserved.
//

#import "KKWeakTimer.h"

@interface KKWeakTimer ()

@property (nonatomic, weak) id<KKWeakTimerProtocol> target;

@end

@implementation KKWeakTimer

+ (NSTimer*)createNewWeakNSTimer:(id<KKWeakTimerProtocol>)target {
    KKWeakTimer *weakTimer = [[KKWeakTimer alloc] initWithTarget:target];
    return [NSTimer scheduledTimerWithTimeInterval:1 target:weakTimer selector:@selector(implementTimerSelector:) userInfo:nil repeats:YES];
}

- (instancetype)initWithTarget:(id<KKWeakTimerProtocol>)target {
    self = [super init];
    if (self) {
        self.target = target;
    }
    return self;
}

- (void)implementTimerSelector:(NSTimer*)timer {
    if (self.target) {
        if ([self.target respondsToSelector:@selector(didFireTimer:)]) {
            [self.target didFireTimer:timer];
        }
    } else {
        [timer invalidate];
    }
}

@end
