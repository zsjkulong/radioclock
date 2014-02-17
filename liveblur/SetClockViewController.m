//
//  SetClockViewController.m
//  asdf
//
//  Created by zsjkulong on 13-12-25.
//  Copyright (c) 2013年 zsjkulong. All rights reserved.
//

#import "SetClockViewController.h"
#define darkBlue ([UIColor colorWithRed:0.0f green:0.49f blue:0.96f alpha:1.0f])

@interface SetClockViewController ()


@property NSArray *hours;
@property NSArray *mins;
@property UIColor *mainColor;
@property NSUserDefaults *defaults;
@property NSMutableArray *weekDays;
@property NSString *isShakeOrLight;
@property NSMutableArray *clockList;
@end

@implementation SetClockViewController



@synthesize circularSlider;
@synthesize clockList;
@synthesize shakeButton;
@synthesize lightButton;
@synthesize sunday;
@synthesize monday;
@synthesize tuesday;
@synthesize wednesday;
@synthesize friday;
@synthesize saturday;
@synthesize thursday;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) viewDidAppear:(BOOL)animated
{

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initData];
    self.defaults = [NSUserDefaults standardUserDefaults];
    [self initPickerValue];
    
}

-(void) initPickerValue{
    if(self.clockDetail!=nil){
        [self.timePicker selectRow:16384/2-8+self.clockDetail.hourIndex.intValue inComponent:0 animated:YES];
        [self.timePicker selectRow:16384/2-32+self.clockDetail.minIndex.intValue inComponent:1 animated:YES];
        NSLog(@"%d",(16384/2-4+self.clockDetail.channelIndex.intValue));
        [self.musicPick selectRow:(16384/2-12+self.clockDetail.channelIndex.intValue) inComponent:0 animated:YES];
        self.isShakeOrLight = self.clockDetail.isShakeOrLight;
        self.weekDays = self.clockDetail.weekDay;
        if([self.isShakeOrLight isEqualToString:@"10"]){
            [self.shakeButton setBackgroundImage:[UIImage imageNamed:@"抖动_check"] forState:UIControlStateNormal];
            self.shakeLabel.textColor = darkBlue;
            [self.lightButton setBackgroundImage:[UIImage imageNamed:@"亮光_uncheck"] forState:UIControlStateNormal];
        } else if([self.isShakeOrLight isEqualToString:@"00"]) {
            [self.shakeButton setBackgroundImage:[UIImage imageNamed:@"抖动_uncheck"] forState:UIControlStateNormal];
            [self.lightButton setBackgroundImage:[UIImage imageNamed:@"亮光_uncheck"] forState:UIControlStateNormal];
        } else if([self.isShakeOrLight isEqualToString:@"01"]) {
            [self.shakeButton setBackgroundImage:[UIImage imageNamed:@"抖动_uncheck"] forState:UIControlStateNormal];
            [self.lightButton setBackgroundImage:[UIImage imageNamed:@"亮光_check"] forState:UIControlStateNormal];
            self.lightLabel.textColor = darkBlue;
        } else if([self.isShakeOrLight isEqualToString:@"11"]) {
            [self.shakeButton setBackgroundImage:[UIImage imageNamed:@"抖动_check"] forState:UIControlStateNormal];
            self.lightLabel.textColor = darkBlue;
            [self.lightButton setBackgroundImage:[UIImage imageNamed:@"亮光_check"] forState:UIControlStateNormal];
            self.shakeLabel.textColor = darkBlue;
        }
        
        if([self.clockDetail.isloop isEqualToString:@"1"]){
            self.reSwitch.on = YES;
        }
        else
        {
            self.reSwitch.on = NO;
        }
        
        for (NSString *day in self.clockDetail.weekDay) {
            if([day isEqualToString:@"0"]){
                [self setBackImage:@"周日_check" button:self.sunday];
                [self.sunday setTag:[self.sunday tag]*10];
            } else if([day isEqualToString:@"1"]){
                [self setBackImage:@"周1_check" button:self.monday];
                [self.monday setTag:[self.monday tag]*10];
            } else if([day isEqualToString:@"2"]){
                [self setBackImage:@"周2_check" button:self.tuesday];
                [self.tuesday setTag:[self.tuesday tag]*10];
            } else if([day isEqualToString:@"3"]){
                [self setBackImage:@"周3_check" button:self.wednesday];
                [self.wednesday setTag:[self.wednesday tag]*10];
            } else if([day isEqualToString:@"4"]){
                [self setBackImage:@"周4_check" button:self.thursday];
                [self.thursday setTag:[self.thursday tag]*10];
            } else if([day isEqualToString:@"5"]){
                [self setBackImage:@"周5_check" button:self.friday];
                [self.friday setTag:[self.friday tag]*10];
            } else if([day isEqualToString:@"6"]){
                [self setBackImage:@"周6_check" button:self.saturday];
                [self.saturday setTag:[self.saturday tag]*10];
            }
        }
    } else {
        [self.timePicker selectRow:16384/2-8 inComponent:0 animated:NO];
        [self.timePicker selectRow:16384/2-32 inComponent:1 animated:NO];
        [self.musicPick selectRow:16384/2-12 inComponent:0 animated:NO];
        self.isShakeOrLight = @"00";
        [self setBackImage:@"周日_uncheck" button:self.sunday];
    }
}

-(void) sliderValueChangle{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)initData{
    self.timePicker.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.timePicker.delegate = self;
//    self.timePicker.frame = CGRectMake(0, 84, 320, 100);;
//    self
    self.musicPick.delegate = self;
    self.hours = [[NSArray alloc] initWithObjects:@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",nil];
    self.mins = [[NSArray alloc] initWithObjects:@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",@"40",@"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",@"50",@"51",@"52",@"53",@"54",@"55",@"56",@"57",@"58",@"59",nil];
}

- (IBAction)backAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^(){
        
    }];
}

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if([pickerView isDescendantOfView:self.timePicker]){
        return 2;
    } else {
        return 1;
    }
    
}
//
//// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if([pickerView isDescendantOfView:self.timePicker]){
        if(component == 3){
            return 1;
        } else if(component == 1){
            return 16384;
        } else{
            return 16384;
        }
    } else {
        return 16384;
    }
}

-(UIView *) pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    if([pickerView isDescendantOfView:self.timePicker]){
        CGRect rect = CGRectMake(0, 0, 50, 44);
        UIView *uiView = view;
        if(!uiView){
            uiView = [[UIView alloc] initWithFrame:rect];
            
            UILabel *lable = [[UILabel alloc] initWithFrame:uiView.frame];

            lable.textAlignment = UITextAlignmentCenter;

            lable.textColor = darkBlue;

            if(component==0)
                lable.text = [self.hours objectAtIndex:row % [self.hours count]];
            else if(component==1) {
                lable.text = [self.mins objectAtIndex:row % [self.mins count]];
            } else {
                lable.text = @"时间";
            }
            [uiView addSubview:lable];
        }
        
        return uiView;
    }
    else {
        UIView *uiView = view;

        if(!uiView){
            CGRect rect = CGRectMake(0, 0, 300, 44);

            uiView = [[UIView alloc] initWithFrame:rect];
            
            UILabel *lable = [[UILabel alloc] initWithFrame:rect];

            lable.textColor = darkBlue;
            lable.text = [self.channels objectAtIndex:row % [self.channels count]];
            lable.textAlignment = UITextAlignmentCenter;
            lable.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
            lable.backgroundColor = [UIColor clearColor];
            [uiView addSubview:lable];
        }
        
        return uiView;
    }
    
}

- (IBAction)saveAction:(id)sender {
    int hour = [self.timePicker selectedRowInComponent:0];
    int min = [self.timePicker selectedRowInComponent:1];
    NSString *strHour = @"";
    NSString *strMins = @"";
    strHour = [self.hours objectAtIndex:(hour%self.hours.count)];
    strMins = [self.mins objectAtIndex:(min%self.mins.count)];
    NSString *time = [NSString stringWithFormat:@"%@:%@",strHour,strMins];
    
    ClockDetail *detail = [[ClockDetail alloc ] init];
    detail.time = time;
    detail.hourIndex =[NSString stringWithFormat:@"%d",hour%self.hours.count ];
    detail.minIndex =[NSString stringWithFormat:@"%d",min%self.mins.count ];
    int channelsrow = [self.musicPick selectedRowInComponent:0];
    
    detail.channelName = [self.channels objectAtIndex:(channelsrow % self.channels.count)];
    detail.channelIndex = [NSString stringWithFormat:@"%d",(channelsrow % self.channels.count)];
    [self.weekDays sortUsingComparator:^NSComparisonResult(id obj1, id obj2){
        NSComparisonResult result = [obj1 compare:obj2];
        return result;
    }];
    
    detail.weekDay = self.weekDays;
    detail.isShakeOrLight = self.isShakeOrLight;
    detail.uid = [NSString stringWithFormat:@"%d", arc4random() % 10000];
    detail.isEnable = @"1";
    detail.isChange = @"1";
    if(self.reSwitch.isOn){
        detail.isloop = @"1";
    } else{
        detail.isloop = @"0";
    }
    
    if(self.clockDetail != nil){
        detail.uid = self.clockDetail.uid;
    }
    
    NSData *data = [self.defaults objectForKey:@"clockList"];
    self.clockList = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if(!self.clockList){
        self.clockList = [[NSMutableArray alloc]init];
    }
    
    BOOL *flag = NO;
    int index = 0;
    for (ClockDetail *detailTemp in self.clockList) {
        if([detailTemp.uid isEqualToString: detail.uid])
        {
            flag = YES;
            break;
        }
        index++;
    }
    if(flag){
        [self.clockList removeObjectAtIndex:index];
        [self.clockList addObject:detail];
    } else {
        [self.clockList addObject:detail];
    }
    
    
    data = [NSKeyedArchiver archivedDataWithRootObject:self.clockList];
    
    [self.defaults removeObjectForKey:@"clockList"];
    
    [self.defaults setObject:data forKey:@"clockList"];
    [self.defaults synchronize];
    
    [self dismissViewControllerAnimated:YES completion:^(){
        
    }];
}

-(void) setBackImage:(NSString *) imageName button:(UIButton *)button{
    [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

- (IBAction)dayAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    NSInteger tag  = [button tag];
    if(self.weekDays==nil){
        self.weekDays = [[NSMutableArray alloc] init];
    }
    switch (tag) {
        case 1:
            [self setBackImage:@"周日_check" button:button];
            [button setTag:[button tag]*10];
//            NSInteger d = [NSInteger alloc]
            [self.weekDays addObject:@"0"];
            break;
        case 2:
            [self setBackImage:@"周1_check" button:button];
            [button setTag:[button tag]*10];
            [self.weekDays addObject:@"1"];
            break;
        case 3:
            [self setBackImage:@"周2_check" button:button];
            [button setTag:[button tag]*10];
            [self.weekDays addObject:@"2"];
            break;
        case 4:
            [self setBackImage:@"周3_check" button:button];
            [button setTag:[button tag]*10];
            [self.weekDays addObject:@"3"];
            break;
        case 5:
            [self setBackImage:@"周4_check" button:button];
            [button setTag:[button tag]*10];
            [self.weekDays addObject:@"4"];
            break;
        case 6:
            [self setBackImage:@"周5_check" button:button];
            [button setTag:[button tag]*10];
            [self.weekDays addObject:@"5"];
            break;
        case 7:
            [self setBackImage:@"周6_check" button:button];
            [button setTag:[button tag]*10];
            [self.weekDays addObject:@"6"];
            break;
        case 10:
            [self setBackImage:@"周日_uncheck" button:button];
            [button setTag:[button tag]/10];
            [self.weekDays removeObject:@"0"];
            break;
        case 20:
            [self setBackImage:@"周1_uncheck" button:button];
            [button setTag:[button tag]/10];
            [self.weekDays removeObject:@"1"];
            break;
        case 30:
            [self setBackImage:@"周2_uncheck" button:button];
            [button setTag:[button tag]/10];
            [self.weekDays removeObject:@"2"];
            break;
        case 40:
            [self setBackImage:@"周3_uncheck" button:button];
            [button setTag:[button tag]/10];
            [self.weekDays removeObject:@"3"];
            break;
        case 50:
            [self setBackImage:@"周4_uncheck" button:button];
            [button setTag:[button tag]/10];
            [self.weekDays removeObject:@"4"];
            break;
        case 60:
            [self setBackImage:@"周5_uncheck" button:button];
            [button setTag:[button tag]/10];
            [self.weekDays removeObject:@"5"];
            break;
        case 70:
            [self setBackImage:@"周6_uncheck" button:button];
            [button setTag:[button tag]/10];
            [self.weekDays removeObject:@"6"];
            break;
        default:
            break;
    }
}


- (IBAction)shakeAction:(id)sender {
    if([self.isShakeOrLight isEqualToString:@"10"]){
        [self.shakeButton setBackgroundImage:[UIImage imageNamed:@"抖动_uncheck"] forState:UIControlStateNormal];
        self.shakeLabel.textColor = [UIColor grayColor];
        self.isShakeOrLight = @"00";
    } else if([self.isShakeOrLight isEqualToString:@"00"]) {
        [self.shakeButton setBackgroundImage:[UIImage imageNamed:@"抖动_check"] forState:UIControlStateNormal];
        self.shakeLabel.textColor = darkBlue;
        self.isShakeOrLight = @"10";
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    } else if([self.isShakeOrLight isEqualToString:@"11"]) {
        [self.shakeButton setBackgroundImage:[UIImage imageNamed:@"抖动_uncheck"] forState:UIControlStateNormal];
        self.shakeLabel.textColor = [UIColor grayColor];
        self.isShakeOrLight = @"01";
    } else if([self.isShakeOrLight isEqualToString:@"01"]) {
        [self.shakeButton setBackgroundImage:[UIImage imageNamed:@"抖动_check"] forState:UIControlStateNormal];
        self.shakeLabel.textColor = darkBlue;
        self.isShakeOrLight = @"11";
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
    
}

- (IBAction)lightAction:(id)sender {
    
    if([self.isShakeOrLight isEqualToString:@"01"]){
        [self.lightButton setBackgroundImage:[UIImage imageNamed:@"亮光_uncheck"] forState:UIControlStateNormal];
        self.isShakeOrLight = @"00";
        self.lightLabel.textColor = [UIColor grayColor];
    } else if([self.isShakeOrLight isEqualToString:@"00"]) {
        [self.lightButton setBackgroundImage:[UIImage imageNamed:@"亮光_check"] forState:UIControlStateNormal];
        self.isShakeOrLight = @"01";
         self.lightLabel.textColor = darkBlue;
    } else if([self.isShakeOrLight isEqualToString:@"11"]) {
        [self.lightButton setBackgroundImage:[UIImage imageNamed:@"亮光_uncheck"] forState:UIControlStateNormal];
        self.isShakeOrLight = @"10";
        self.lightLabel.textColor = [UIColor grayColor];
    } else if([self.isShakeOrLight isEqualToString:@"10"]) {
        [self.lightButton setBackgroundImage:[UIImage imageNamed:@"亮光_check"] forState:UIControlStateNormal];
        self.isShakeOrLight = @"11";
         self.lightLabel.textColor = darkBlue;
    }
    
}
@end
