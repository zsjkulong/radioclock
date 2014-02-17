//
//  clockCell.m
//  asdf
//
//  Created by zsjkulong on 14-1-6.
//  Copyright (c) 2014年 zsjkulong. All rights reserved.
//

#import "clockCell.h"

@implementation clockCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    [load];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


//+ (void)load
//{
//    Method existing = class_getInstanceMethod(self, @selector(layoutSubviews));
//    Method new = class_getInstanceMethod(self, @selector(_autolayout_replacementLayoutSubviews));
//    
//    method_exchangeImplementations(existing, new);
//}
//
//- (void)_autolayout_replacementLayoutSubviews
//{
//    [super layoutSubviews];
////    [self _autolayout_replacementLayoutSubviews]; // not recursive due to method swizzling
//    [super layoutSubviews];
//}

@end
