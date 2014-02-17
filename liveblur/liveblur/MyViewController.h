//
//  ViewController.h
//  liveblur
//
//  Created by zsjkulong on 13-11-27.
//  Copyright (c) 2013年 zsjkulong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLRView.h"
#import "RNFrostedSidebar.h"
#import "JSONTools.h"
#import "superView.h"
#import "SetClockViewController.h"
#import <MediaPlayer/MPNowPlayingInfoCenter.h>
#import <MediaPlayer/MPMediaItem.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MPMoviePlayerController.h>
#import <MediaPlayer/MPVolumeView.h>
#import <MediaPlayer/MPVolumeSettings.h>
#import <MediaPlayer/MPMusicPlayerController.h>
#import "ClockController.h"
#import "navigationController.h"



@interface MyViewController : UIViewController <BLRViewDelegate,UIGestureRecognizerDelegate,UIAlertViewDelegate>
- (IBAction)toClockView:(id)sender;

- (IBAction)playButtionAction:(id)sender;
- (IBAction)forwardButtionAction:(id)sender;
//@property (strong, nonatomic) IBOutlet UIView *VoiceView;
@property (strong, nonatomic) IBOutlet superView *superView;
@property (nonatomic,strong) BLRView *blrView;
@property (strong, nonatomic) IBOutlet UIButton *playButton;
@property (strong, nonatomic) IBOutlet UIButton *forwardButton;
@property (strong, nonatomic) IBOutlet UILabel *playerView;
@property (strong, nonatomic) IBOutlet UILabel *songName;
@property (nonatomic,assign) ViewDirection viewDirection;
@property (strong, nonatomic) IBOutlet UIView *subView;
@property (strong, nonatomic) IBOutlet UIProgressView *progressView;
@property (strong, nonatomic) IBOutlet UIImageView *myImageView;
@property (strong, nonatomic) IBOutlet UIView *helpView1;
@property (strong, nonatomic) IBOutlet UILabel *helpText1;
@property (strong, nonatomic) IBOutlet UIImageView *helpImage1;
@property (strong, nonatomic) IBOutlet UILabel *helpText2;
@property (strong, nonatomic) IBOutlet UILabel *errorlabel;
@property (strong, nonatomic) IBOutlet UIImageView *helpImage2;
@property (strong, nonatomic) IBOutlet UILabel *helpText4;
@property (strong, nonatomic) IBOutlet UIImageView *helpImage3;
@property (strong, nonatomic) IBOutlet UIView *helpView2;
@property (strong, nonatomic) IBOutlet UILabel *helpText3;
@property (strong, nonatomic) IBOutlet UIImageView *helpImage4;
@property (nonatomic,strong) RNFrostedSidebar *callout;
@property (nonatomic,strong) NSMutableArray *channels;
@property (nonatomic,strong) JSONTools *jsonTools;
@property (nonatomic,strong) UIImage *image;
@property (nonatomic,strong) MPMoviePlayerController *audioPlayer;
@property (nonatomic,strong) MPVolumeView *volumeView;
@property (nonatomic ,weak) SetClockViewController *controller;
@property (nonatomic ,weak) ClockController *clocklist;
@property (nonatomic ,weak) navigationController *navigation;

@property (nonatomic,strong) NSDictionary *channelid2images;
@property (nonatomic,strong) NSDictionary *channelid2colors;
@property (nonatomic,strong) NSDictionary *index2channelid;
@property (nonatomic,strong) NSMutableArray *channelNames;
@property (nonatomic,strong) NSTimer *progressUpdateTimer;
@property (nonatomic,strong) NSMutableArray *songArray;
@property (nonatomic,strong) NSUserDefaults *userDefaults;
@property (nonatomic,strong) NSString *isFirst;
@property (nonatomic,strong) NSString *status;
@property (nonatomic,strong) NSString *channelid;
//@property (nonatomic,strong) BOOL isEnterBack;

-(void) stop;
-(void) backgroupChangeSong:(NSString *) channelid;
-(void) taskChangeSong:(NSString *) channelid;
-(void) initAll;
-(void) alertView;
- (void)destroyStreamer;
- (void) createNOMPplayer:(NSString *) url;
@end
