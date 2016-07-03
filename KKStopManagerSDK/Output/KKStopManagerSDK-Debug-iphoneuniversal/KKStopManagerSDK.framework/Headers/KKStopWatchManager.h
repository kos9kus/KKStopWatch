//
//  KKStopWatchManager.h
//  KKStopWatchManagerLib
//
//  Created by KONSTANTIN KUSAINOV on 02/07/16.
//  Copyright © 2016 Kos9Kus. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KKStopWatchManager;

typedef NS_ENUM(NSUInteger, KKStopWatchManagerActionType) {
    KKStopWatchManagerActionTypeStart,
    KKStopWatchManagerActionTypePause,
    KKStopWatchManagerActionTypeResume,
    KKStopWatchManagerActionTypeReset
};

@protocol KKStopWatchManagerDelegate <NSObject>

- (void)didTickTimer:(KKStopWatchManager*)stopWatchManager;

@end

@interface KKStopWatchManager : NSObject

@property (nonatomic, strong, readonly) NSString *currentTime;

+ (instancetype)createNewStopWatchManager:(id<KKStopWatchManagerDelegate>)delegate;

- (void)commitStopWatchAction:(KKStopWatchManagerActionType)actionType;

@end
