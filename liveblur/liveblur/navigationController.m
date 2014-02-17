//
//  navigationController.m
//  asdf
//
//  Created by zsjkulong on 14-1-6.
//  Copyright (c) 2014年 zsjkulong. All rights reserved.
//

#import "navigationController.h"

@interface navigationController ()

@end

@implementation navigationController

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
    
    UIStoryboard * storyboard = [ UIStoryboard storyboardWithName:@"Main" bundle:nil ];
    
    ClockController *clocklist = [storyboard instantiateViewControllerWithIdentifier:@"clockList" ];
    
    clocklist.channelBeans =  self.channelBeans;
    clocklist.channels = self.channels;
    [self pushViewController:clocklist animated:YES];

	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
