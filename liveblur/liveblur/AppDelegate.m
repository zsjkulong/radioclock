//
//  AppDelegate.m
//  liveblur
//
//  Created by zsjkulong on 13-11-27.
//  Copyright (c) 2013年 zsjkulong. All rights reserved.
//

#import "AppDelegate.h"


@implementation AppDelegate


@synthesize repeatCount;
@synthesize jsonTools;
@synthesize flag;
@synthesize userDefaults;
@synthesize clockList;

CheckTask *checkTask;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    application = [UIApplication sharedApplication];
    checkTask = [[CheckTask alloc] init];
    checkTask.zviewController =(MyViewController *)self.window.rootViewController;
    checkTask.application = application;
    [checkTask startTimer];
    self.jsonTools = [[JSONTools alloc]init];
    [self isConnectTointernet:@"http://douban.fm/j/app/radio/channels"];
    self.myViewController = ((MyViewController *)self.window.rootViewController);
    self.myViewController.jsonTools = self.jsonTools;
    
    [self getUserDefault];
    
    [application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    
    NSLog(@"%@",[self.userDefaults objectForKey:@"Terminate"]);
    
   
    
    // Override point for customization after application launch.
    return YES;
}


- (void) application:(UIApplication *)application
  performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
//    NSLog(@"performFetchWithCompletionHandler");
//    if(self.myViewController.audioPlayer.playbackState == MPMoviePlaybackStatePlaying  && application.applicationState == UIApplicationStateBackground ){
//        if(checkTask.toForFlag==NO)
//            [self.myViewController.audioPlayer pause];
//    }
//
//    if(application.applicationState==UIApplicationStateBackground){
//        
//        NSLog(@"%f",[[UIApplication sharedApplication] backgroundTimeRemaining]);
//        
//        if([[UIApplication sharedApplication] backgroundTimeRemaining]<=30.0f && [[UIApplication sharedApplication] backgroundTimeRemaining]>=27.0f){
//            NSLog(@"启动任务");
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
//                
//                [[NSRunLoop currentRunLoop] run];
//                [checkTask startTimer];
//            });
//            
//            self.backFetchFlag = YES;
////            [checkTask startTimer];
//            
////            [self startTrackingBg];
//        }
//    } else if(application.applicationState==UIApplicationStateInactive){
//        NSLog(@"%@",@"UIApplicationStateInactive");
//        [self runBackgroundTask:40];
//    } else {
//         NSLog(@"%@",@"UIApplicationStateActive");
//    }
    
    
//    [self runBackgroundTask:40];
    
    completionHandler(UIBackgroundFetchResultNewData);
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    
    NSLog(@"resignActive");
    
//    if(self.myViewController.audioPlayer.playbackState == MPMoviePlaybackStatePlaying){
//        [self.myViewController.audioPlayer pause];
//    }
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}



- (void)applicationDidEnterBackground:(UIApplication *)application
{
    if ( [UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
        NSLog(@"start backgroun tracking from appdelegate");
        self.repeatCount = 0;
        
        
        [checkTask stopTimer];
    }
    [self runBackgroundTask:40];
}

-(void)runBackgroundTask: (int) time{
    
    UIApplication *app = [UIApplication sharedApplication];
    
    //check if application is in background mode
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
        
//        [checkTask stopTimer];
        
        NSLog(@"enter background");
        //create UIBackgroundTaskIdentifier and create tackground task, which starts after time
        __block UIBackgroundTaskIdentifier bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        
            
            [app endBackgroundTask:bgTask];
            
            bgTask = UIBackgroundTaskInvalid;
        }];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
//            if(self.t==nil){
                NSTimer *t = [NSTimer scheduledTimerWithTimeInterval:time target:self selector:@selector(startTrackingBg) userInfo:nil repeats:NO];
//            [t fire];
                [[NSRunLoop currentRunLoop] addTimer:t forMode:NSDefaultRunLoopMode];
                [[NSRunLoop currentRunLoop] run];
//            [NSRunLoop currentRunLoop];
//            }
        });
    }
}


-(void)startTrackingBg{
    //write background time remaining
    NSLog(@"backgroundTimeRemaining: %.0f", [[UIApplication sharedApplication] backgroundTimeRemaining]);
    
//    NSDate *now = [NSDate date];
    
//    NSLog(@"")
    
    NSLog(@"%ld",(long)self.myViewController.audioPlayer.playbackState);
    
    if(self.myViewController.audioPlayer.playbackState==MPMoviePlaybackStatePaused){
        NSLog(@"暂停");
    }
    if(self.myViewController.audioPlayer.playbackState==MPMoviePlaybackStateInterrupted){
        NSLog(@"终止");
    }
    
    if(self.myViewController.audioPlayer.playbackState==MPMoviePlaybackStateStopped){
        NSLog(@"停止");
    }
    
    if(self.myViewController.audioPlayer.playbackState==MPMoviePlaybackStatePlaying){
        NSLog(@"播放");
    }
    
    
    if(([[UIApplication sharedApplication] backgroundTimeRemaining]<=50.0f && self.myViewController.audioPlayer.playbackState==MPMoviePlaybackStatePaused) || ([[UIApplication sharedApplication] backgroundTimeRemaining]<=50.0f && self.myViewController.audioPlayer.playbackState==MPMoviePlaybackStateStopped) || ([[UIApplication sharedApplication] backgroundTimeRemaining]<=50.0f && self.myViewController.audioPlayer.playbackState==MPMoviePlaybackStateInterrupted)){
        repeatCount ++;
        
        
        NSLog(@"enter 50 process");
        
        if(repeatCount >=10 || self.myViewController.audioPlayer.playbackState==MPMoviePlaybackStateStopped){
            NSString *path=[[NSBundle mainBundle] pathForResource:@"no" ofType:@"mp3"];
//            NSURL *URL = [[NSURL alloc] initFileURLWithPath:path];
            [self.myViewController createNOMPplayer:path];
//            NSLog(@"停止");
        }
        
        repeatCount = 0;
        checkTask.toForFlag = YES;
        
        [self.myViewController.audioPlayer play];
        [self.myViewController.audioPlayer pause];

    }
    
    //set default time
    int time = 40;
    
//    [checkTask getUserDefault];
    [checkTask checkClock];

    
    
    if(self.myViewController.audioPlayer.playbackState==MPMoviePlaybackStatePaused){
        NSLog(@"暂停");
    }
    if(self.myViewController.audioPlayer.playbackState==MPMoviePlaybackStateInterrupted){
        NSLog(@"终止");
    }
    
    if(self.myViewController.audioPlayer.playbackState==MPMoviePlaybackStateStopped){
        NSLog(@"停止");
    }
    
    if(self.myViewController.audioPlayer.playbackState==MPMoviePlaybackStatePlaying){
        NSLog(@"播放");
    }
    
    
    [self runBackgroundTask:time];
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


- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
    if(checkTask.toForFlag){
    
        [self.myViewController backgroupChangeSong:self.myViewController.channelid];
    
        checkTask.toForFlag = NO;
    }
    [checkTask startTimer];
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
    NSLog(@"BecomeActive");
//    NSLog(@"asdf1%@",self.myViewController.status);
//    if([self.myViewController.status isEqualToString:@"interrupted"]){
//        [self.myViewController.audioPlayer play];
//    }
    
}


-(void) startClockNoti{
    
    NSDateFormatter *nsdf2=[[NSDateFormatter alloc] init];
    
    [nsdf2 setDateStyle:NSDateFormatterShortStyle];
    
    [nsdf2 setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    
    NSDate *now = [NSDate date];
//    NSString *t=[nsdf2 stringFromDate:now];
    
    NSCalendar* theCalendar = [NSCalendar currentCalendar];
    
    unsigned theUnitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekdayCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    NSString *t=[nsdf2 stringFromDate:now];
    NSLog(@"t2start:%@",t);
    
    NSDate *lastDate = nil;
    ClockDetail *clockDetail = nil;
//    NSString *time = nil;
    NSDateComponents* compsForDate = [theCalendar components:theUnitFlags fromDate:now];
    
    
   
    BOOL flag = YES;
    
    for (int i =0; i<7 && flag; i++) {
//        compsForDate.day = i;
        NSInteger *weekDay = [compsForDate weekday]-1;
        compsForDate.weekday = weekDay+i;
        NSString *weekStr = [NSString stringWithFormat:@"%d",weekDay];
        for (ClockDetail *detail in self.clockList) {
            if([detail.weekDay containsObject:weekStr]){
                NSArray *array = [detail.time componentsSeparatedByString:@":"];
                NSString *hour = [array objectAtIndex:0];
                NSString *min = [array objectAtIndex:1];
                [compsForDate setHour: hour.intValue];
                [compsForDate setMinute: min.intValue];
                NSDate *iPhoneReleaseDate = [[NSCalendar currentCalendar]dateFromComponents:compsForDate];
                NSString *t2=[nsdf2 stringFromDate:iPhoneReleaseDate];
                NSLog(@"t2over:%@",t2);
//                [currentDate compare:earlierDate]==NSOrderedDescending
                if([iPhoneReleaseDate compare:now]==NSOrderedDescending){
                    NSDate *d = [lastDate laterDate: iPhoneReleaseDate];
                    NSString *t2=[nsdf2 stringFromDate:d];
                    NSLog(@"t2over:%@",t2);

                    if(lastDate ==nil || [lastDate compare:iPhoneReleaseDate ]==NSOrderedDescending){
                        lastDate =iPhoneReleaseDate;
                        clockDetail =detail;
//                        channelName = detail.channelName;
//                        time = detail.time;
                    }
                    flag = NO;
                    
                }
                
            }
        }
    }
    
    NSString *t2=[nsdf2 stringFromDate:lastDate];
    
    NSLog(@"t2:%@",t2);
    NSLog(@"channelName:%@",clockDetail.channelName);
    [self startLocalNotification:lastDate ClockDetail:clockDetail];
}

-(void) startLocalNotification:(NSDate *) date ClockDetail:(ClockDetail*)ClockDetail {
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    
//    NSDate
    
//    NSDate *date = [NSDate date];
    if(localNotification!=nil){
        localNotification.fireDate = date;
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        localNotification.repeatInterval = kCFCalendarUnitDay;
        NSString *alertBody =[NSString stringWithFormat:@"现在是%@,正在为您播放%@FM",ClockDetail.time,ClockDetail.channelName];
        localNotification.alertBody = alertBody;
        NSString *asdf = @"FMCLOCK" ;
        asdf = [asdf stringByAppendingFormat:@"%@_%@",asdf,ClockDetail.uid];
        
        
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:asdf forKey:@"name"];
        localNotification.userInfo = userInfo;
        UIApplication *app = [UIApplication sharedApplication];
        NSArray *array = [app scheduledLocalNotifications];
        for (UILocalNotification *tempLocalNotification in array) {
            NSString *name = [tempLocalNotification.userInfo objectForKey:@"name"];
            if([name isEqualToString:asdf]){
                return;
            }
        }
        [app scheduleLocalNotification:localNotification];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    
//    [self getUserDefault];
//    
    NSDateFormatter *nsdf2=[[NSDateFormatter alloc] init];
//
    [nsdf2 setDateStyle:NSDateFormatterShortStyle];
    
    [nsdf2 setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    NSString *t2=[nsdf2 stringFromDate:[NSDate date]];

//    [self startClockNoti];
    
    [self.userDefaults setObject:t2 forKey:@"Terminate"];
    [self.userDefaults synchronize];
//    self.myViewController.testLable.text = 
    
//    NSLog(@"terminate%@",t2);
    
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification*)notification{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:notification.alertBody delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
    
//    [self.myViewController initAll];
//    [checkTask startTimer];
    NSArray *localArray = [application scheduledLocalNotifications];
    
    if(localArray !=nil){
        for (UILocalNotification *noti in localArray) {
            NSDictionary *dict = noti.userInfo;
            if(dict!=nil){
                NSString *name = [dict objectForKey:@"name"];
                if([name hasPrefix:@"FMCLOCK"]){
//                    [self.myViewController initAll];
                    [application cancelLocalNotification:noti];
                    
//                    [checkTask startTimer];
//                    self.myViewController taskChangeSong:<#(NSString *)#>
//                    NSLog(@"remove LocalNotification");
                }
            }
        }
    }
    
}

-(void) checkFlag{
    if(self.flag ==NO){
        NSLog(@"change flag value");
        self.flag = YES;
    }
}

-(void) isConnectTointernet:(NSString *) URL{
    
    self.jsonTools.url = [[NSURL alloc] initWithString:URL];
    
    self.jsonTools.isConnect = 0;
   
    NSTimer *nsTimer = [NSTimer scheduledTimerWithTimeInterval:10.0f target:self selector:@selector(checkFlag) userInfo:nil repeats:YES];
    [nsTimer fire];
//    NSLog(@"set isConnect:");
    self.manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:URL]];
    self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSOperationQueue *operationQueue = self.manager.operationQueue;
    [self.manager.reachabilityManager startMonitoring];
    [self.manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        switch (status) {
                
            case AFNetworkReachabilityStatusNotReachable:
                // we need to notify a delegete when internet conexion is lost.
                // [delegate internetConexionLost];
                NSLog(@"No Internet Conexion");
                
                if(flag==YES){
//                    [self.myViewController alertView];
                    flag = NO;
                }
                self.jsonTools.isConnect = -1;
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"WIFI");
                self.jsonTools.isConnect = 1;
                if(flag==YES  && self.myViewController.audioPlayer.playbackState ==MPMoviePlaybackStateStopped){
                    [self.myViewController initAll];
                    flag = NO;
                }
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"3G");
//                BOOL flag;
                self.jsonTools.isConnect = 2;
                if(flag==YES && self.myViewController.audioPlayer.playbackState == MPMoviePlaybackStateStopped){
                    [self.myViewController initAll];
                    flag = NO;
                }
                break;
            default:
                NSLog(@"Unkown network status");
                [operationQueue setSuspended:YES];
                self.jsonTools.isConnect = -1;
                break;
        }}];
    
    
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application{
    [self.userDefaults setObject:@"内存告警" forKey:@"gaojing"];
    [self.userDefaults synchronize];
}

@end
