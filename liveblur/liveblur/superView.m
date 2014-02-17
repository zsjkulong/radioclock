//
//  superView.m
//  asdf
//
//  Created by zsjkulong on 13-12-16.
//  Copyright (c) 2013年 zsjkulong. All rights reserved.
//

#import "superView.h"

@implementation superView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


-(void) layoutSubviews{
    [super layoutSubviews];
//    [self.blrView blurWithColor:[BLRColorComponents lightEffect] CGRect:self.blrView.frame];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
