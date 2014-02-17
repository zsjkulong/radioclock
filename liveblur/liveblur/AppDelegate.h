//
//  AppDelegate.h
//  liveblur
//
//  Created by zsjkulong on 13-11-27.
//  Copyright (c) 2013年 zsjkulong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyViewController.h"
#import <MediaPlayer/MPMoviePlayerViewController.h>
#import "CheckTask.h"
#import "AFHTTPRequestOperationManager.h"
//#import "AFHTTPClient.h"
#import "JSONTools.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (nonatomic,strong) AFHTTPRequestOperationManager *manager;
@property (nonatomic,weak) MyViewController *myViewController;
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,strong) JSONTools *jsonTools;
@property (nonatomic,strong) NSUserDefaults *userDefaults;
@property (nonatomic,strong) NSArray *clockList;
@property (nonatomic,strong) NSTimer *t;
@property BOOL backFetchFlag;
@property BOOL runFlag;
@property NSInteger count;
@property BOOL flag;
@property NSInteger repeatCount;
@end
