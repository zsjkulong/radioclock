//
//  BLRButton.m
//  liveblur
//
//  Created by zsjkulong on 13-12-2.
//  Copyright (c) 2013年 zsjkulong. All rights reserved.
//

#import "BLRButton.h"



@implementation BLRButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = [UIColor clearColor];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        
        
        [self addSubview:_imageView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat inset = self.bounds.size.height;
//    self.imageView.frame = CGRectMake(0, 0, inset, inset);
    self.imageView.frame = self.frame;
    self.imageView.center = CGPointMake(inset/2, inset/2);
}

- (void)setOriginalBackgroundColor:(UIColor *)originalBackgroundColor {
    _originalBackgroundColor = originalBackgroundColor;
    self.backgroundColor = originalBackgroundColor;
}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    [super touchesBegan:touches withEvent:event];
//    
//    float r, g, b, a;
//    float darkenFactor = 0.3f;
//    UIColor *darkerColor;
//    if ([self.originalBackgroundColor getRed:&r green:&g blue:&b alpha:&a]) {
//        darkerColor = [UIColor colorWithRed:MAX(r - darkenFactor, 0.0) green:MAX(g - darkenFactor, 0.0) blue:MAX(b - darkenFactor, 0.0) alpha:a];
//    }
//    else if ([self.originalBackgroundColor getWhite:&r alpha:&a]){
//        darkerColor = [UIColor colorWithWhite:MAX(r - darkenFactor, 0.0) alpha:a];
//    }
//    else {
//        @throw @"Item color should be RGBA or White/Alpha in order to darken the button color.";
//    }
//    self.backgroundColor = darkerColor;
//}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    self.backgroundColor = self.originalBackgroundColor;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    self.backgroundColor = self.originalBackgroundColor;
}

@end

