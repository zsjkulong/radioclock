//
//  JSONTools.m
//  liveblur
//
//  Created by zsjkulong on 13-12-6.
//  Copyright (c) 2013年 zsjkulong. All rights reserved.
//

#import "JSONTools.h"

@implementation JSONTools

@synthesize url;
@synthesize isConnect;


-(void) checkValue{
    self.networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    NSLog(@"Initial cell connection: %@", self.networkInfo.currentRadioAccessTechnology);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(radioAccessChanged) name:
     CTRadioAccessTechnologyDidChangeNotification object:nil];

// whatever stuff your method does...
}

- (void)radioAccessChanged {
    NSLog(@"Now you're connected via %@", self.networkInfo.currentRadioAccessTechnology);
}






-(NSMutableArray *)getAllChannels{
    if(self.isConnect<=0){
        return nil;
    }
    NSError *error;
    NSMutableArray *returnChannels = [[NSMutableArray alloc]init];
    NSArray *channels;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:self.url];
    
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSDictionary *channelJSON = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    
    channels =  [channelJSON objectForKey:@"channels"];
    
    
    Channel *channel;
    for (NSDictionary *data in channels) {
        channel = [[Channel alloc]init];
        channel.name =[data objectForKey:@"name"];
        channel.seq_id = [data objectForKey:@"seq_id"];
        channel.abbr_en = [data objectForKey:@"addr_en"];
        channel.channel_id =[data objectForKey:@"channel_id"];
//        channel. =[data objectForKey:@"name_en"];
        [returnChannels addObject:channel];
    }

    
    return returnChannels;
}


-(NSMutableArray *) getSongFromChannel:(NSString *) channel_id {
    if(self.isConnect<=0){
        return nil;
    }
    NSError *error;
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSString *urlStr = [NSString stringWithFormat:@"http://douban.fm/j/app/radio/people?app_name=radio_desktop_win&version=100&sid=&channel=%@&type=n",channel_id ];
    NSURL *urlz = [[NSURL alloc] initWithString:urlStr];
//     NSLog(@"2");
    NSURLRequest *request = [NSURLRequest requestWithURL:urlz];
    
    [NSURLConnection sendAsynchronousRequest:request queue:nil completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
        
    }];
    
    NSData *data=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
//    NSLog(@"2");
    NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    
    NSArray *songs = [jsonData objectForKey:@"song"];
    
    Song *song;
    for (NSDictionary *tempd in songs) {
        song = [[Song alloc]init];
        song.picture = [tempd objectForKey:@"picture"];
        song.artist = [tempd objectForKey:@"artist"];
        song.albumtitle = [tempd objectForKey:@"albumtitle"];
        song.title = [tempd objectForKey:@"title"];
        song.url = [tempd objectForKey:@"url"];
        [array addObject:song];
    }
    
    
    return array;
}


+ (NSString *)replaceUnicode:(NSString *)unicodeStr
{
    
    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u"withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""];
    NSString *tempStr3 = [[@"\""stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData
                                                           mutabilityOption:NSPropertyListImmutable
                                                                     format:NULL
                                                           errorDescription:NULL];
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n"withString:@"\n"];
}

@end
