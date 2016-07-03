//
//  ViewController.m
//  StopWatchBeta
//
//  Created by KONSTANTIN KUSAINOV on 02/07/16.
//  Copyright © 2016 Kos9Kus. All rights reserved.
//

#import "ViewController.h"

@import KKStopManagerSDK;

@interface ViewController ()<KKStopWatchManagerDelegate>

@property (nonatomic, strong) KKStopWatchManager *timerManager;
@property (nonatomic, strong) IBOutlet UILabel *labelTimer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.timerManager = [KKStopWatchManager createNewStopWatchManager:self];
    [self.timerManager commitStopWatchAction:KKStopWatchManagerActionTypeReset];
}

- (IBAction)didChangedSegmentControll:(UISegmentedControl *)sender {
    [self.timerManager commitStopWatchAction:sender.selectedSegmentIndex];
}

#pragma mark -

- (void)didTickTimer:(KKStopWatchManager *)stopWatchManager {
    if (self.timerManager == stopWatchManager) {
        self.labelTimer.text = stopWatchManager.currentTime;
    }
}

@end
