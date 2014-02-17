//
//  CheckTask.h
//  asdf
//
//  Created by zsjkulong on 14-1-17.
//  Copyright (c) 2014年 zsjkulong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ClockDetail.h"
#import "MyViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolBox/AudioServices.h>
@interface CheckTask : NSObject

@property (nonatomic,strong) NSTimer *nstimer;
@property (nonatomic,weak) MyViewController *zviewController;
@property (nonatomic,strong) NSUserDefaults *userDefaults;
@property (nonatomic,strong) NSArray *clockList;
@property BOOL isChangeClockList;
@property UIApplication *application;
@property BOOL isStopShake;
@property NSInteger count;
@property BOOL toForFlag;
-(void)getUserDefault;
-(void) checkClock;
-(void) stopTimer;
-(void) startTimer;
-(BOOL) checkTimer;

@end
