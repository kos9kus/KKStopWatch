//
//  KKWeakTimer.h
//  KKStopWatchManagerLib
//
//  Created by KONSTANTIN KUSAINOV on 02/07/16.
//  Copyright © 2016 Kos9Kus. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol KKWeakTimerProtocol <NSObject>

- (void)didFireTimer:(NSTimer*)timer;

@end

@interface KKWeakTimer : NSObject

+ (NSTimer*)createNewWeakNSTimer:(id<KKWeakTimerProtocol>)target;

@end
