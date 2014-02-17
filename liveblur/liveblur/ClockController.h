//
//  clockController.h
//  asdf
//
//  Created by zsjkulong on 14-1-4.
//  Copyright (c) 2014年 zsjkulong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SetClockViewController.h"
#import "ClockDetail.h"
//#import "NSException.h"
@interface ClockController : UITableViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic ,strong) NSArray *channels;
@property (nonatomic ,strong) NSArray *channelBeans;
@property (strong, nonatomic) IBOutlet UIView *tintView;
@property (nonatomic ,weak) SetClockViewController *controller;
- (IBAction)back:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *clockTableView;

- (IBAction)add:(id)sender;
@end
