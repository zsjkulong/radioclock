//
//  JSONTools.h
//  liveblur
//
//  Created by zsjkulong on 13-12-6.
//  Copyright (c) 2013年 zsjkulong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Channel.h"
#import "Song.h"
#import "AFHTTPRequestOperationManager.h"
@import CoreTelephony.CTTelephonyNetworkInfo;
@interface JSONTools : NSObject

@property (nonatomic, strong) CTTelephonyNetworkInfo *networkInfo;
@property (nonatomic,strong) NSURL *url;
@property NSInteger isConnect;

-(BOOL) isConnectTointernet:(NSString *) URL;
-(NSMutableArray *) getAllChannels;
-(NSMutableArray *) getSongFromChannel:(NSString *) channel_id;
@end
