//
//  ClockDetail.m
//  asdf
//
//  Created by zsjkulong on 14-1-4.
//  Copyright (c) 2014年 zsjkulong. All rights reserved.
//

#import "ClockDetail.h"

@implementation ClockDetail

@synthesize time;
@synthesize channelName;
@synthesize isShakeOrLight;
@synthesize weekDay;
@synthesize channelIndex;
@synthesize hourIndex;
@synthesize minIndex;
@synthesize uid;
@synthesize isloop;
@synthesize isEnable;
@synthesize isChange;
-(void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:time forKey:@"time"];
    [encoder encodeObject:channelName forKey:@"channelName"];
    [encoder encodeObject:isShakeOrLight forKey:@"isShakeOrLight"];
    [encoder encodeObject:weekDay forKey:@"weekDay"];
    [encoder encodeObject:channelIndex forKey:@"channelIndex"];
    [encoder encodeObject:hourIndex forKey:@"hourIndex"];
    [encoder encodeObject:minIndex forKey:@"minIndex"];
    [encoder encodeObject:uid forKey:@"uid"];
    [encoder encodeObject:isloop forKey:@"isloop"];
    [encoder encodeObject:isEnable forKey:@"isEnable"];
    [encoder encodeObject:isChange forKey:@"isChange"];
}

-(id)initWithCoder:(NSCoder *)decoder
{
    self.time = [decoder decodeObjectForKey:@"time"];
    self.channelName = [decoder decodeObjectForKey:@"channelName"];
    self.isShakeOrLight = [decoder decodeObjectForKey:@"isShakeOrLight"];
    self.weekDay = [decoder decodeObjectForKey:@"weekDay"];
    self.channelIndex = [decoder decodeObjectForKey:@"channelIndex"];
    self.minIndex = [decoder decodeObjectForKey:@"minIndex"];
    self.hourIndex = [decoder decodeObjectForKey:@"hourIndex"];
    self.uid = [decoder decodeObjectForKey:@"uid"];
    self.isloop = [decoder decodeObjectForKey:@"isloop"];
    self.isEnable = [decoder decodeObjectForKey:@"isEnable"];
    self.isChange = [decoder decodeObjectForKey:@"isChange"];
    return self;
}

@end
