//
//  ClockController.m
//  asdf
//
//  Created by zsjkulong on 14-1-4.
//  Copyright (c) 2014年 zsjkulong. All rights reserved.
//

#import "ClockController.h"
#define darkBlue ([UIColor colorWithRed:0.0f green:0.49f blue:0.96f alpha:1.0f])
@interface ClockController ()

@property NSMutableArray *clockList;
@property UIColor *cellColor;
@property NSUserDefaults  *userDefaults;
@property ClockDetail *currentClockDetail;
@end

@implementation ClockController


@synthesize clockList;
@synthesize channels;
@synthesize channelBeans;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.cellColor = darkBlue;
    NSLog(@"viewDidLoad load");

}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    NSLog(@"viewWillAppear load");
    [self getUserDefault];
//    self.userDefaults
//    if(self.clockList.count ==0){
//        self.tintView.alpha=1;
//    }else{
//        self.tintView.alpha=0;
//        [self.view sendSubviewToBack:self.tintView];
//    }
//    NSLog(@"%d",self.clockList.count);
//    [self.clockTableView reloadData];
}

-(void) viewDidAppear:(BOOL)animated{
    [self.clockTableView reloadData];
}

-(void) getUserDefault{
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [self.userDefaults objectForKey:@"clockList"];
    

    if(data){
        NSArray *array;
        @try{
        array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        } @catch (NSException *exp){
            [self.userDefaults removeObjectForKey:@"clockList"];
            self.clockList = nil;
            return;
        }
        
        self.clockList = array;
    }else {
        self.clockList = nil;
    }
    
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self.clockList){
        return self.clockList.count;
    } else {
        return 0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

-(void) saveClockDetail{
    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:self.clockList];
    
    [self.userDefaults setObject:data forKey:@"clockList"];
    [self.userDefaults synchronize];
}

-(void) deleteAndSynUserDefualt:(NSInteger *)indexz{
    [self.clockList removeObjectAtIndex:indexz];
//    self.userDefaults 
    [self saveClockDetail];
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(UITableViewCellEditingStyleDelete == editingStyle){
//        NSLog(@"%d",indexPath.row);
        [self deleteAndSynUserDefualt:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:@"clockDetail"];
    ClockDetail *clockDetail = (ClockDetail *)[self.clockList objectAtIndex:indexPath.row];
    if(cell==nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"clockDetail"];

        
        
        UISwitch *uswitch = [[UISwitch alloc] init];
        uswitch.on = YES;

        uswitch.center = CGPointMake(cell.center.x+320/2-40,cell.center.y+20);
        [uswitch setTag:indexPath.row];
        [cell.contentView addSubview:uswitch];
        uswitch.on = [clockDetail.isEnable isEqualToString:@"1"]?YES:NO;
        [uswitch addTarget:self action:@selector(switchValueChange:) forControlEvents:UIControlEventValueChanged];
    }
    
    
    cell.textLabel.text = clockDetail.time;
    cell.textLabel.textColor = self.cellColor;
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:48];
    
    NSString *weekDayStr;
    if(clockDetail.weekDay.count>0){
        weekDayStr = @"";
        NSString *temp =@"";
        for (NSString *weekDayTemp in clockDetail.weekDay) {
            if([weekDayTemp isEqualToString:@"0"]){
                temp = @"周日";
            }else {
                temp =[NSString stringWithFormat:@"周%@",weekDayTemp];
            }
            weekDayStr = [weekDayStr stringByAppendingString:temp];
            weekDayStr = [weekDayStr stringByAppendingString:@"、"];
        }
        weekDayStr = [weekDayStr substringToIndex:weekDayStr.length-1];
    } else {
        weekDayStr = @"";
    }
    NSString *detailStr = [NSString stringWithFormat:@"%@ FM:%@",weekDayStr,clockDetail.channelName];
    cell.detailTextLabel.text =detailStr;
    cell.detailTextLabel.textColor = [UIColor grayColor];
    
    return cell;
}

-(void) switchValueChange:(UISwitch *)sender{
    NSInteger *row = [sender tag];
    ClockDetail *clockDetail = [self.clockList objectAtIndex:row];
    
    NSString *isEnabel = sender.isOn?@"1":@"0";
    
    clockDetail.isEnable = isEnabel;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^(){
        [self saveClockDetail];
    });
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)back:(id)sender {
    [super dismissViewControllerAnimated:YES completion:^(){
        
    }];
}

- (IBAction)add:(id)sender {
    UIStoryboard * storyboard = [ UIStoryboard storyboardWithName:@"Main" bundle:nil ];
    self.controller = [storyboard instantiateViewControllerWithIdentifier:@"clockView" ];
    self.controller.channels = self.channels;
    self.controller.channelBeans = self.channelBeans;
    self.controller.clockDetail = nil;
    [self presentViewController:self.controller animated:YES completion:^(){
        
    }];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard * storyboard = [ UIStoryboard storyboardWithName:@"Main" bundle:nil ];
    self.controller = [storyboard instantiateViewControllerWithIdentifier:@"clockView" ];
    self.controller.channels = self.channels;
    self.controller.channelBeans = self.channelBeans;
    if(self.clockList==nil){
        [self getUserDefault];
    }
    
    self.currentClockDetail =self.clockList[indexPath.row];
    
//    [self.clockList removeObjectAtIndex:indexPath.row];
//    [self saveClockDetail];
    
    
    self.controller.clockDetail =self.currentClockDetail;
    [self presentViewController:self.controller animated:YES completion:^(){
        
    }];
//    [self performSegueWithIdentifier:@"clockDetailPSegue" sender:self];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"clockDetailPSegue"]){
        self.controller = [segue destinationViewController];
        self.controller.channels = self.channels;
        self.controller.channelBeans = self.channelBeans;
        self.controller.clockDetail = self.currentClockDetail;

//        self.controller.delegate = self;
//        detailsVC.displayedLetter = [tableview objectAtIndex:row]
        
    }
}






@end
