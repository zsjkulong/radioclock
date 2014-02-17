//
//  ClockDetail.h
//  asdf
//
//  Created by zsjkulong on 14-1-4.
//  Copyright (c) 2014年 zsjkulong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClockDetail : NSObject<NSCoding>

@property NSString *uid;
@property NSString *time;
@property NSArray *weekDay;
@property NSString *channelName;
@property NSString *isShakeOrLight;
@property NSString *channelIndex;
@property NSString *hourIndex;
@property NSString *minIndex;
@property NSString *isloop;
@property NSString *isEnable;
@property NSString *isChange;
@end
