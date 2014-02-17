//
//  SetClockViewController.h
//  asdf
//
//  Created by zsjkulong on 13-12-25.
//  Copyright (c) 2013年 zsjkulong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EFCircularSlider.h"
#import "ClockDetail.h"
#import <AudioToolbox/AudioToolbox.h>
#import <CoreFoundation/CoreFoundation.h>

@interface SetClockViewController : UIViewController <UIPickerViewDelegate,UIPickerViewDataSource>

@property (strong, nonatomic) EFCircularSlider *circularSlider;
- (IBAction)backAction:(id)sender;
- (IBAction)saveAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIPickerView *timePicker;
@property (strong, nonatomic) IBOutlet UINavigationItem *mynavigationItem;
@property (strong, nonatomic) IBOutlet UIView *buttonView;
@property (strong, nonatomic) IBOutlet UISwitch *reSwitch;
- (IBAction)shakeAction:(id)sender;
- (IBAction)lightAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIPickerView *musicPick;
@property (strong, nonatomic) IBOutlet UIView *weekView;
@property (strong, nonatomic) IBOutlet UIButton *sunday;
@property (strong, nonatomic) IBOutlet UIButton *monday;
@property (strong, nonatomic) IBOutlet UIButton *tuesday;
@property (strong, nonatomic) IBOutlet UIButton *wednesday;
@property (strong, nonatomic) IBOutlet UIButton *friday;
@property (strong, nonatomic) IBOutlet UIButton *saturday;
@property (strong, nonatomic) IBOutlet UIButton *thursday;

- (IBAction)dayAction:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *shakeLabel;
@property (strong, nonatomic) IBOutlet UILabel *lightLabel;

@property (strong, nonatomic) IBOutlet UISwitch *timesSwitch;
@property (strong, nonatomic) IBOutlet UIButton *shockAction;
@property (strong, nonatomic) IBOutlet UIButton *ligthAction;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) NSArray *channels;
@property (strong, nonatomic) NSArray *channelBeans;
@property (strong, nonatomic) ClockDetail *clockDetail;
@property (strong, nonatomic) IBOutlet UIButton *shakeButton;
@property (strong, nonatomic) IBOutlet UIButton *lightButton;

@end
