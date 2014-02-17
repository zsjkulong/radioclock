//
//  ViewController.m
//  liveblur
//
//  Created by zsjkulong on 13-11-27.
//  Copyright (c) 2013年 zsjkulong. All rights reserved.
//

#import "MyViewController.h"

@interface MyViewController ()

@property (nonatomic, strong) NSMutableIndexSet *optionIndices;
@property (nonatomic, strong) NSDictionary *images;
@property (nonatomic ,strong) NSMutableArray *queueImages;
@property (nonatomic, strong) NSMutableArray *queueColor;

@property (nonatomic,strong) UISlider *voiceSlider;
@property (nonatomic,strong) Song *song;


//@property (nonatomic,strong) AudioPlayer *audioPlayer;
@end

@implementation MyViewController

@synthesize channelid;
//@synthesize errorlabel;
@synthesize blrView;
@synthesize callout;
@synthesize channels;
@synthesize jsonTools;
@synthesize channelid2colors;
@synthesize channelid2images;
@synthesize index2channelid;
@synthesize channelNames;
@synthesize progressUpdateTimer;
@synthesize progressView;
@synthesize songArray;
@synthesize userDefaults;
@synthesize audioPlayer;
@synthesize volumeView;
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addVoiceView];
    
//    self.helpView1.backgroundColor = [UIColor clearColor];
    
    self.subView.frame = self.view.frame;
//    jsonTools = [[JSONTools alloc] init];
//    NSLog(@"jsonTools.isConnect:%d", jsonTools.isConnect);
    
    
    
    
    //获取背景图片，启动定时器
//    [self.blrView blurWithColor:[BLRColorComponents lightEffect] CGPoint:point updateInterval:0.2f];

    
    
    //添加事件
    [self addEventToView];
    
    
}

-(void) initAll{
    channels = [jsonTools getAllChannels];
    [self initImages];
    [self initData];
    [self getUserDefualt];
    
//    
//    self.testLable.text = [self.userDefaults objectForKey:@"Terminate"];
    
//    self.fcount.text =[self.userDefaults objectForKey:@"fff"];
    UIImage *image = [UIImage imageNamed:@"1"];
    image = [image resizeImage:CGSizeMake((self.view.frame.size.width),250+(self.view.frame.size.height-480))];
    
    self.myImageView.image = image;
    __block NSString *bockkey=@"";
    [self.index2channelid enumerateKeysAndObjectsUsingBlock:
     ^(id key,id obj,BOOL *stop){
         if([obj isEqualToString:self.channelid]){
             bockkey = key;
             *stop = YES;
         }
     }];
    self.optionIndices = [NSMutableIndexSet indexSetWithIndex:bockkey.integerValue];
    
    NSArray *colors = [self.channelid2colors allValues];
    
    //view上层必须是在需要毛玻璃的那个view
    blrView  = [BLRView load:self.subView rect:CGRectMake((-self.view.frame.size.width/2),0,(self.view.frame.size.width/2),self.view.frame.size.height) initWithImages:self.queueImages selectedIndices:self.optionIndices borderColors:colors Names:self.channelNames];
    blrView.delegate = self;
    
    //    blrView sets
    
   
    
    [self showHelp];
    
    [self.view addSubview:blrView];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex  {
    if (buttonIndex == 1) {
        NSLog(@"11");
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=WIFI"]];
    }
    
}


-(void) showHelp{
    if(self.isFirst==nil){
        [UIView animateWithDuration:2.0f delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationCurveEaseInOut
                         animations:^{
                             self.helpImage1.alpha=1.0f;
                             self.helpText1.alpha=1.0f;
                             
        } completion:^(BOOL flag){
            [UIView animateWithDuration:2.0f delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationCurveEaseInOut
                             animations:^{
                                self.helpImage1.alpha=0.0f;
                                self.helpText1.alpha=0.0f;
                             } completion:^(BOOL flag){

                             }];
        }];
        
        [UIView animateWithDuration:2.0f delay:4 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationCurveEaseInOut
                         animations:^{

                             self.helpImage2.alpha=1.0f;
                             self.helpText2.alpha=1.0f;

                         } completion:^(BOOL flag){
                             [UIView animateWithDuration:2.0f delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationCurveEaseInOut
                                              animations:^{
                                    self.helpImage2.alpha=0.0f;
                                    self.helpText2.alpha=0.0f;
                         } completion:^(BOOL flag){
                         
                         }];
        }];
        
        [UIView animateWithDuration:2.0f delay:8 options:
         UIViewAnimationOptionBeginFromCurrentState |UIViewAnimationCurveEaseInOut
                         animations:^{
                             
                             self.helpImage3.alpha=1.0f;
                             self.helpText3.alpha=1.0f;
        } completion:^(BOOL flag){
            [UIView animateWithDuration:2.0f delay:0 options:
             UIViewAnimationOptionBeginFromCurrentState |UIViewAnimationCurveEaseInOut
                             animations:^{
                                 
                    self.helpImage3.alpha=0.0f;
                    self.helpText3.alpha=0.0f;
                             } completion:^(BOOL flag){
                                 
                             }];
        }];
        
        
        [UIView animateWithDuration:2.0f delay:12 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationCurveEaseInOut
                         animations:^{
                             self.helpImage4.alpha=1.0f;
                             self.helpText4.alpha=1.0f;
                             
        } completion:^(BOOL flag){
            [UIView animateWithDuration:2.0f delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationCurveEaseInOut
                             animations:^{
                self.helpImage4.alpha=0.0f;
                self.helpText4.alpha=0.0f;
            } completion:^(BOOL flag){
                                 
            }];
        }];
        [userDefaults setObject:@"1" forKey:@"isFirst"];
        [userDefaults synchronize];
//        self.isFirst = [userDefaults objectForKey:@"isFirst"];
    }
}

-(void) alertView{
    
    if(self.jsonTools.isConnect>=0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"无法连接到网络" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil];
        
        [alert show];
    }
}

- (void)configPlayingInfo
{
	Class playingInfoCenter = NSClassFromString(@"MPNowPlayingInfoCenter");
    
    if (playingInfoCenter) {
        
        if(self.jsonTools.isConnect < 0){
            return;
        }
        NSMutableDictionary *songInfo = [ [NSMutableDictionary alloc] init];
        
        
        MPMediaItemArtwork *albumArt = [ [MPMediaItemArtwork alloc] initWithImage: self.image];
        
        [ songInfo setObject: self.song.title forKey:MPMediaItemPropertyTitle ];
        [ songInfo setObject: self.song.artist forKey:MPMediaItemPropertyArtist ];
        [ songInfo setObject: self.song.albumtitle forKey:MPMediaItemPropertyAlbumTitle ];
        [ songInfo setObject: albumArt forKey:MPMediaItemPropertyArtwork ];
        [ songInfo setObject: [NSNumber numberWithFloat: self.audioPlayer.duration ] forKey:MPMediaItemPropertyPlaybackDuration ];
        

        
        [ songInfo setObject: [NSNumber numberWithInt:1]  forKey:MPNowPlayingInfoPropertyPlaybackRate ];
        [ [MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:songInfo ];
    }

}

-(void) stop{
    if (self.audioPlayer.playbackState == MPMoviePlaybackStatePlaying ) {
        [self.audioPlayer stop];
    }
//    self.audioPlayer
}

- (void) createNOMPplayer:(NSString *) url{
    [[AVAudioSession sharedInstance] setDelegate: self];
    
    NSError *myErr;
    
    // Initialize the AVAudioSession here.
    if (![[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&myErr]) {
        // Handle the error here.
        NSLog(@"Audio Session error %@, %@", myErr, [myErr userInfo]);
    }
    else{
        // Since there were no errors initializing the session, we'll allow begin receiving remote control events
        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    }
    
    [self destroyStreamer];
    
    //initialize our audio player
    audioPlayer = [[MPMoviePlayerController alloc] initWithContentURL:[[NSURL alloc] initFileURLWithPath:url]];
    
    
    [audioPlayer setShouldAutoplay:NO];
    [audioPlayer setControlStyle: MPMovieControlStyleEmbedded];
    audioPlayer.view.hidden = YES;
    
    [audioPlayer prepareToPlay];

}

- (void) createMPplayer:(NSString *) url{
    [[AVAudioSession sharedInstance] setDelegate: self];
    
    NSError *myErr;
    
    // Initialize the AVAudioSession here.
    if (![[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&myErr]) {
        // Handle the error here.
        NSLog(@"Audio Session error %@, %@", myErr, [myErr userInfo]);
    }
    else{
        // Since there were no errors initializing the session, we'll allow begin receiving remote control events
        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    }
    
    [self destroyStreamer];
    
    //initialize our audio player
    audioPlayer = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:url]];
    
    [audioPlayer setShouldAutoplay:NO];
    [audioPlayer setControlStyle: MPMovieControlStyleEmbedded];
    audioPlayer.view.hidden = YES;
    
    [audioPlayer prepareToPlay];
    [audioPlayer play];
    
    [self createTimers:YES];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(playbackStateChanged:)
     name:MPMoviePlayerPlaybackStateDidChangeNotification
     object:self.audioPlayer];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(playbackFinish:)
     name:MPMoviePlayerPlaybackDidFinishNotification
     object:self.audioPlayer];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    self.errorlabel.text = [self.userDefaults objectForKey:@"gaojing"];
    
	[self becomeFirstResponder];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	[[UIApplication sharedApplication] endReceivingRemoteControlEvents];
	[self resignFirstResponder];
}

- (BOOL)canBecomeFirstResponder
{
	return YES;
}

-(void) addVoiceView{
    
//    self.mpc = [MPMusicPlayerController applicationMusicPlayer];
    
    volumeView = [[MPVolumeView alloc] initWithFrame:CGRectMake(-80, self.view.frame.size.height/2, 200, 20)];

    volumeView.alpha = 0.0;
    
}

-(void) getUserDefualt{
    userDefaults = [NSUserDefaults standardUserDefaults];
    self.channelid = [userDefaults objectForKey:@"channelid"];
    NSNumber *value =[userDefaults objectForKey:@"voicevalue"];
    self.isFirst = [userDefaults objectForKey:@"isFirst"];
    if(value.floatValue==0){
        self.voiceSlider.value = 100;
    } else {
        self.voiceSlider.value = value.floatValue;
    }
    if (self.channelid==nil) {
        self.channelid = @"1";
    } 
    [self backgroupChangeSong:self.channelid];
}


-(void) initData{
    
    songArray = [[NSMutableArray alloc] init];
    
    channelid2images = [[NSMutableDictionary alloc] init];
    channelid2colors = [[NSMutableDictionary alloc] init];
    channelNames = [[NSMutableArray alloc] init];
    index2channelid = [[NSMutableDictionary alloc] init];
    self.queueImages =[[NSMutableArray alloc] init];
    for (NSInteger i = 0,j=0; i < channels.count;i++) {
        
        Channel * channel = (Channel *)channels[i];
        
        NSString *name =channel.name;
        if ([name rangeOfString:@"MHz"].length >0) {
            name = [name stringByReplacingOccurrencesOfString:@"MHz" withString:@""];
            name = [name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            channel.name = name;
        }
        
//        NSString 
        //根据程序中有的image来筛选频道
        if([self.images objectForKey:channel.name]){
            [channelid2images setValue:[UIImage imageNamed:[self.images objectForKey:channel.name] ] forKey:channel.channel_id];
            [self.queueImages addObject:[UIImage imageNamed:[self.images objectForKey:channel.name]]];
            [channelid2colors setValue:[UIColor colorWithRed:0.18f green:0.67f blue:0.84f alpha:1.0f] forKey:channel.channel_id];
            [channelNames addObject:channel.name];
            [index2channelid setValue:channel.channel_id forKey:[NSString stringWithFormat:@"%ld",(long)j]];
            j++;
        }
        
    }
}

-(void) addEventToView{
    //添加横向滑动事件
    UISwipeGestureRecognizer *swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeFiger:)];
    
    swipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.subView addGestureRecognizer:swipeGestureRecognizer];
    
    swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeFiger:)];
    swipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.subView addGestureRecognizer:swipeGestureRecognizer];
    
    UIPanGestureRecognizer *uiPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(swipeFigerUpOrDown:)];
    [self.subView addGestureRecognizer:uiPanGestureRecognizer];
    [uiPanGestureRecognizer requireGestureRecognizerToFail:swipeGestureRecognizer];
    uiPanGestureRecognizer.delegate = self;
    swipeGestureRecognizer.delegate = self;
}


-(void) swipeFiger:(UISwipeGestureRecognizer *) gestureRecognizer{
    if(gestureRecognizer.direction == UISwipeGestureRecognizerDirectionLeft && blrView.viewDirection==KShouldMoveLeft){
        [self.blrView slideLeft];
        blrView.viewDirection =KShouldMoveRight;
    } else if (gestureRecognizer.direction == UISwipeGestureRecognizerDirectionRight && blrView.viewDirection==KShouldMoveRight){
        [self.blrView slideRight];
        blrView.viewDirection =KShouldMoveLeft;
    }
}

-(void) swipeFigerUpOrDown:(UIPanGestureRecognizer *) gestureRecognizer{

    
//    volumeView.
    
    CGPoint point = [gestureRecognizer translationInView:self.superView];

    if(point.y > 20||point.y < -20){
        UISlider *volumeViewSlider;
        
        for (UIView *view in [self.volumeView subviews]){
            if ([[[view class] description] isEqualToString:@"MPVolumeSlider"]) {
                volumeViewSlider = (UISlider *) view;
            }
        }
        
        volumeViewSlider.value = volumeViewSlider.value-point.y/6000;
//        NSLog(@"volumeViewSlider.value:%f",volumeViewSlider.value);
//        NSLog(@"point.y/200:%f",point.y/4000);
//        self.mpc.volume = self.voiceSlider.value/100;
    }
    if(gestureRecognizer.state == UIGestureRecognizerStateEnded){
        [UIView animateWithDuration:0.5 animations:^(void){
            self.volumeView.alpha = 0;
        }];
    }
//    NSNumber *voiceValue = [NSNumber numberWithFloat:self.volumeView];
//    [self.userDefaults setValue:voiceValue forKey:@"voicevalue"];
//    [self.userDefaults synchronize];
    
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
	if (event.type == UIEventTypeRemoteControl) {
        switch (event.subtype) {
            case UIEventSubtypeRemoteControlPause:
//                [self resumeOrPause]; // 切换播放、暂停按钮
//                NSLog(@"pause");
                [self playButtionAction:self.playButton];
                break;
            case UIEventSubtypeRemoteControlPlay:
                //                [self resumeOrPause]; // 切换播放、暂停按钮
//                NSLog(@"pause");
                [self playButtionAction:self.playButton];
                break;
            case UIEventSubtypeRemoteControlPreviousTrack:
//                [self playPrev]; // 播放上一曲按钮
                break;
                
            case UIEventSubtypeRemoteControlNextTrack:
                [self forwardButtionAction:self.forwardButton]; // 播放下一曲按钮
                break;
                
            default:
                break;
        }
    }
}

-(void) initImages{
    self.images = [[NSMutableDictionary alloc] init];
//    self.images setValue:@ forKey:<#(NSString *)#>
//    self.images set
    [self.images setValue:@"91.1.jpg" forKey:@"91.1"];
    [self.images setValue:@"Easy.jpg" forKey:@"Easy"];
    [self.images setValue:@"R&B.jpg" forKey:@"R&B"];
    [self.images setValue:@"八零.jpg" forKey:@"八零"];
    [self.images setValue:@"不拘一格.jpg" forKey:@"不拘一格"];
    [self.images setValue:@"电影原音.jpg" forKey:@"电影原音"];
    [self.images setValue:@"电子.jpg" forKey:@"电子"];
    [self.images setValue:@"动漫.jpg" forKey:@"动漫"];
    [self.images setValue:@"法语.jpg" forKey:@"法语"];
    [self.images setValue:@"工作学习.jpg" forKey:@"工作学习"];
    [self.images setValue:@"古典.jpg" forKey:@"古典"];
    [self.images setValue:@"韩语.jpg" forKey:@"韩语"];
    [self.images setValue:@"华语.jpg" forKey:@"华语"];
    [self.images setValue:@"九零.jpg" forKey:@"九零"];
    [self.images setValue:@"爵士.jpg" forKey:@"爵士"];
    [self.images setValue:@"咖啡.jpg" forKey:@"咖啡"];
    [self.images setValue:@"民谣.jpg" forKey:@"民谣"];
    [self.images setValue:@"女声.jpg" forKey:@"女声"];
    [self.images setValue:@"欧美.jpg" forKey:@"欧美"];
    [self.images setValue:@"七零.jpg" forKey:@"七零"];
//    [self.images setValue:@"且听风吟华为敬献.jpg" forKey:@"且听风吟华为敬献"];
    [self.images setValue:@"轻音乐.jpg" forKey:@"轻音乐"];
    [self.images setValue:@"日语.jpg" forKey:@"日语"];
    [self.images setValue:@"说唱.jpg" forKey:@"说唱"];
    [self.images setValue:@"小清新.jpg" forKey:@"小清新"];
    [self.images setValue:@"新歌.jpg" forKey:@"新歌"];
    [self.images setValue:@"摇滚.jpg" forKey:@"摇滚"];
    [self.images setValue:@"粤语.jpg" forKey:@"粤语"];
    [self.images setValue:@"中国好声音.jpg" forKey:@"中国好声音"];
}

-(void) tapFiger:(UITapGestureRecognizer *) getstureRecognizer{
    [self.blrView slideLeft];
    blrView.viewDirection =KShouldMoveRight;
}




-(void) buttonDidPush{
    switch (blrView.viewDirection) {
        case KShouldMoveLeft:
            [self.blrView slideLeft];
            blrView.viewDirection =KShouldMoveRight;
            break;
        case KShouldMoveRight:
            [self.blrView slideRight];
            blrView.viewDirection =KShouldMoveLeft;
            break;
        default:
            break;
    }
    

}


- (void)sidebar:(BLRView *)sidebar didTapItemAtIndex:(NSUInteger)index{
//    NSLog(@"11");
//    NSNumber *number = [NSNumber numberWithInteger:index];
    
    NSString *number = [NSString stringWithFormat:@"%lu",(unsigned long)index];
    self.channelid  = [self.index2channelid objectForKey:number];
//     NSLog(@"1");
    [self.songArray removeAllObjects];
    
//    [self destroyStreamer];
    [self backgroupChangeSong:self.channelid];
    
    [userDefaults setValue:self.channelid forKey:@"channelid"];
    [userDefaults synchronize];
    
    
}


-(void) taskChangeSong:(NSString *) channelid{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){

        self.songArray =[jsonTools getSongFromChannel:channelid];

        if(self.songArray==nil || self.jsonTools.isConnect<=0){
//            [self alertView];
            return;
        }
        
        Song *song = [self.songArray lastObject];
        [self.songArray removeLastObject];
        if(song==nil){
            return;
        }
        dispatch_sync(dispatch_get_main_queue(),^(void){
            self.songName.text = song.title;
            self.playerView.text = [NSString stringWithFormat:@"%@ - %@",song.artist,song.albumtitle];
            song.picture = [song.picture stringByReplacingOccurrencesOfString:@"mpic" withString:@"lpic"];
            NSURL *url = [NSURL URLWithString:song.picture];
            self.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
            self.image = [self.image resizeImage:CGSizeMake((self.view.frame.size.width),250+(self.view.frame.size.height-480))];
            self.myImageView.image = self.image;
            [self createMPplayer:song.url];
            //            [self createStreamer:song.url];
            //            [streamer start];
//            [self configPlayingInfo];
            self.song = song;
        });
        
    });
}

-(void) backgroupChangeSong:(NSString *) channelid{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        if([self.songArray count]==0){
            self.songArray =[jsonTools getSongFromChannel:channelid];
        }
        
        if(self.songArray==nil || self.jsonTools.isConnect<=0){
//            [self alertView];
            return;
        }
        Song *song = [self.songArray lastObject];
        [self.songArray removeLastObject];
        
        dispatch_sync(dispatch_get_main_queue(),^(void){
            //封装数据
            self.songName.text = song.title;
            self.playerView.text = [NSString stringWithFormat:@"%@ - %@",song.artist,song.albumtitle];
            //获取图片的地址
            song.picture = [song.picture stringByReplacingOccurrencesOfString:@"mpic" withString:@"lpic"];
            NSURL *url = [NSURL URLWithString:song.picture];
            self.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
            self.image = [self.image resizeImage:CGSizeMake((self.view.frame.size.width),250+(self.view.frame.size.height-480))];
            
            
            //放大图片 支持retina
            self.image = [self.image initWithCGImage:[self.image CGImage] scale:2.0f orientation:UIImageOrientationUp];
            
            self.myImageView.image = self.image;
            [self createMPplayer:song.url];
//            [self createStreamer:song.url];
//            [streamer start];
            self.song = song;
            [self blr];
        });

    });
}




- (void)destroyStreamer
{
	if (self.audioPlayer)
	{
		[[NSNotificationCenter defaultCenter]
         removeObserver:self
         name:MPMoviePlayerPlaybackStateDidChangeNotification
         object:self.audioPlayer];
        
        [[NSNotificationCenter defaultCenter]
         removeObserver:self
         name:MPMoviePlayerPlaybackDidFinishNotification
         object:self.audioPlayer];
        
		[self createTimers:NO];
		
		[self.audioPlayer stop];
//		[streamer release];
//        CFRelease(streamer);
		self.audioPlayer = nil;
	}
}



- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}


- (void)playbackStateChanged:(NSNotification *)aNotification
{
//	iPhoneStreamingPlayerAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    if (self.audioPlayer.playbackState == MPMoviePlaybackStatePlaying)
	{
        [UIView animateWithDuration:0.25 animations:^(){
            [self.playButton setBackgroundImage:[UIImage imageNamed:@"pause" ] forState:UIControlStateNormal];
        }];
        double delayInSeconds = 1.5;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
             [self configPlayingInfo];
        });
        self.status = @"playing";
       
	}
	else if (self.audioPlayer.playbackState == MPMoviePlaybackStatePaused) {
        [UIView animateWithDuration:0.25 animations:^(){
            [self.playButton setBackgroundImage:[UIImage imageNamed:@"play" ] forState:UIControlStateNormal];
        }];
        self.status = @"paused";
	}
	else if (self.audioPlayer.playbackState == MPMoviePlaybackStateInterrupted)
	{
//        NSLog(@"asdf");
//		[self destroyStreamer];
        
//        [self.audioPlayer pause];
//        [progressUpdateTimer setFireDate:[NSDate distantFuture]];
//        self.status =
        self.status = @"interrupted";
//        [self backgroupChangeSong:self.channelid];
	} else if (self.audioPlayer.playbackState == MPMoviePlaybackStateStopped)
	{
		[self destroyStreamer];
        self.status = @"stop";
        [self backgroupChangeSong:self.channelid];
	}
}

-(void) playbackFinish:(NSNotification *)aNotification{
    NSNumber* reason = [[aNotification userInfo] objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
    
    switch ([reason intValue]) {
        case MPMovieFinishReasonPlaybackEnded:
//            [self destroyStreamer];
            [self backgroupChangeSong:self.channelid];
//            NSLog(@"playbackFinished. Reason: Playback Ended");
            
            break;
        case MPMovieFinishReasonPlaybackError:
            NSLog(@"playbackFinished. Reason: Playback Error");
            break;
        case MPMovieFinishReasonUserExited:
            NSLog(@"playbackFinished. Reason: User Exited");
            break;
        default:
            break;
    }
    
    
}

/**
 * 获取blur特效
 */
-(void) blr{
    CGRect rect = CGRectMake(0, 0, self.blrView.frame.size.width, self.blrView.frame.size.height);
    [self.blrView blurWithColor:[BLRColorComponents lightEffect] CGRect:rect];
}

-(void)createTimers:(BOOL)create
{
	if (create) {
		if (self.audioPlayer) {
            [self createTimers:NO];
            progressUpdateTimer =
            [NSTimer
             scheduledTimerWithTimeInterval:0.5
             target:self
             selector:@selector(updateProgress:)
             userInfo:nil
             repeats:YES];
		}
	}
	else {
		if (progressUpdateTimer)
		{
            self.progressView.progress = 0;
			[progressUpdateTimer invalidate];
			progressUpdateTimer = nil;
		}

	}
}


- (void)updateProgress:(NSTimer *)updatedTimer
{
		double duration = audioPlayer.duration;
//        NSLog(@"update中时间间隔:%f", self.audioPlayer.duration );
		if (duration > 0)
		{
//            [self configPlayingInfo];
			[progressView  setProgress:progressView.progress + (updatedTimer.timeInterval / duration)];
		}
}


- (IBAction)toClockView:(id)sender {
    UIStoryboard * storyboard = [ UIStoryboard storyboardWithName:@"Main" bundle:nil ];
    self.navigation = [storyboard instantiateViewControllerWithIdentifier:@"navigations" ];
    self.clocklist = [storyboard instantiateViewControllerWithIdentifier:@"clockList" ];
    self.navigation.channels = self.channelNames;
    self.navigation.channelBeans = self.channels;
    self.navigation.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:self.navigation animated:YES completion:^(){
        
    }];
//    [self.navigation pushViewController:self.clocklist animated:YES];
    
}
- (IBAction)playButtionAction:(id)sender {
    
        if (self.audioPlayer.playbackState == MPMoviePlaybackStatePlaying) {
            
            if(self.jsonTools.isConnect<=0){
                [self alertView];
                return;
            }
            
            [self.playButton setBackgroundImage:[UIImage imageNamed:@"pause"] forState:0];
            [self.audioPlayer pause];
            [progressUpdateTimer setFireDate:[NSDate distantFuture] ];
        } else if (self.audioPlayer.playbackState == MPMoviePlaybackStatePaused){
            [self.playButton setBackgroundImage:[UIImage imageNamed:@"play"] forState:0];
            [self.audioPlayer play];
            [progressUpdateTimer setFireDate:[NSDate date] ];
        }
}

- (IBAction)forwardButtionAction:(id)sender {
    
    
    if(self.jsonTools.isConnect<=0){
        [self alertView];
        return;
    }
//    [self destroyStreamer];
    [self backgroupChangeSong:self.channelid];
}
@end


