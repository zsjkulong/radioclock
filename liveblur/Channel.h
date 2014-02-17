//
//  Channel.h
//  liveblur
//
//  Created by zsjkulong on 13-12-6.
//  Copyright (c) 2013年 zsjkulong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Channel : NSObject
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *seq_id;
@property (nonatomic,strong) NSString *abbr_en;
@property (nonatomic,strong) NSString *channel_id;
@property (nonatomic,strong) NSString *name_en;
@end
