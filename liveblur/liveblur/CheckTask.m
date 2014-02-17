//
//  CheckTask.m
//  asdf
//
//  Created by zsjkulong on 14-1-17.
//  Copyright (c) 2014年 zsjkulong. All rights reserved.
//

#import "CheckTask.h"

#define APPNAME (@"FMCLOCK")
@implementation CheckTask



@synthesize nstimer;
@synthesize clockList;
@synthesize isChangeClockList;
@synthesize userDefaults;
@synthesize zviewController;
@synthesize application;
@synthesize isStopShake;
@synthesize count;
- (id)init {
    self = [super init];
    
    nstimer = [NSTimer scheduledTimerWithTimeInterval:40 target:self selector:@selector(checkClock) userInfo:nil repeats:YES];
    
    
    
    return self;
}

-(void) getUserDefault{
    userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [userDefaults objectForKey:@"clockList"];
    
    if(data){
        NSArray *array;
        @try{
            array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        } @catch (NSException *exp){
            [userDefaults removeObjectForKey:@"clockList"];
            clockList = nil;
            return;
        }
        clockList = array;
    }else {
        clockList = nil;
    }
}

-(void) startLocalNotification:(NSString *) time channelName:(NSString *) channelName{
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:1];
    if(localNotification!=nil){
        localNotification.fireDate = date;
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        localNotification.repeatInterval = kCFCalendarUnitDay;
        NSString *alertBody =[NSString stringWithFormat:@"现在是%@,正在为您播放%@FM",time,channelName];
        localNotification.alertBody = alertBody;
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"FMCLOCK" forKey:@"name"];
        localNotification.userInfo = userInfo;
        UIApplication *app = [UIApplication sharedApplication];
        [app scheduleLocalNotification:localNotification];
    }
}

-(void) checkClock{
    [self getUserDefault];
    
    
    NSDateFormatter *nsdf2=[[NSDateFormatter alloc] init];
    
    [nsdf2 setDateStyle:NSDateFormatterShortStyle];
    
    [nsdf2 setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    
    NSDate *now = [NSDate date];
    NSString *t=[nsdf2 stringFromDate:now];
    
    NSLog(@"checkClock%@",t);
    
    if(clockList!=nil){
        for (ClockDetail *clock in clockList) {
            if([self checkhourMin:clock]){
                //                NSLog(@"%@",[zviewController.index2channelid objectForKey:clock.channelIndex]);
                if([clock.isChange isEqualToString:@"1"]){
                    
//                    NSLog(@"is enter this?");
                    
                    
                    if([clock.isShakeOrLight isEqualToString:@"01"] || [clock.isShakeOrLight isEqualToString:@"11"]){
                        [self startLocalNotification:clock.time channelName:clock.channelName];
                    }
                    
                    if([clock.isShakeOrLight isEqualToString:@"10"] || [clock.isShakeOrLight isEqualToString:@"11"]){
                        [self shake];
                    }
                    
                    [zviewController taskChangeSong: [zviewController.index2channelid objectForKey:clock.channelIndex]];
                    clock.isChange = @"0";
                    isChangeClockList = YES;
                    [userDefaults setObject:[zviewController.index2channelid objectForKey:clock.channelIndex] forKey:@"channelid"];
                    [userDefaults synchronize];
                    
                    NSMutableIndexSet *set = [NSMutableIndexSet indexSetWithIndex:clock.channelIndex.integerValue];
                    zviewController.blrView.selectedIndices =set;
                    
                    self.toForFlag = NO;
                }
            }
        }
    }
    if(isChangeClockList){
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:clockList];
        [userDefaults removeObjectForKey:@"clockList"];
        [userDefaults setObject:data forKey:@"clockList"];
        [userDefaults synchronize];
        isChangeClockList = NO;
    }
    
}

-(void) shake{
    
//    for (int i = 0; i<3; i++) {
    
    NSTimer *timer =[NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(shakeHandler:) userInfo:nil repeats:YES];
    [timer fire];
       
//    }
}

-(void) shakeHandler:(NSTimer *)nsTimer{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    count++;
    if(self.count>10){
        [nsTimer invalidate];
        self.count = 0;
    }
    
}

-(BOOL) checkhourMin:(ClockDetail *) clock {
    
    NSDate *now = [[NSDate alloc] init];
    
    NSCalendar* theCalendar = [NSCalendar currentCalendar];
    
    unsigned theUnitFlags = NSWeekdayCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    NSDateComponents* compsForDate = [theCalendar components:theUnitFlags fromDate:now];
    
    NSInteger *weekday = compsForDate.weekday-1;
    
    NSString *hour = @"";
    NSString *min = @"";
    if(compsForDate.hour<10){
        hour = [NSString stringWithFormat:@"0%d",compsForDate.hour];
    } else {
        hour = [NSString stringWithFormat:@"%d",compsForDate.hour];
    }
    
    if (compsForDate.minute<10) {
        min = [NSString stringWithFormat:@"0%d",compsForDate.minute];
    } else {
        min = [NSString stringWithFormat:@"%d",compsForDate.minute];
    }
    
    
    NSString *time = [NSString stringWithFormat:@"%@:%@",hour,min];
//    NSLog(@"%@",time);
    
    if([clock.weekDay containsObject:[NSString stringWithFormat:@"%d",weekday]]){
        if ([clock.time isEqualToString:time] && [clock.isEnable isEqualToString:@"1"]) {
            if([clock.isloop isEqualToString:@"0"]){
                clock.isEnable = @"0";
//                clock.isChange = @"1";
                isChangeClockList = YES;
            }
            
            return YES;
        } else {
            if([clock.isChange isEqualToString:@"0"]){
                clock.isChange = @"1";
                isChangeClockList = YES;
            }
            return NO;
        }
    } else {
        return NO;
    }
    
}


-(void) stopTimer{
    [nstimer invalidate];
}

-(BOOL) checkTimer{
    return [nstimer isValid];
}

-(void) startTimer{
    [nstimer fire];
}

@end
