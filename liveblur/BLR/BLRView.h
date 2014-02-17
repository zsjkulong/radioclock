//
// Copyright (c) 2013 Justin M Fischer
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of
// this software and associated documentation files (the "Software"), to deal in
// the Software without restriction, including without limitation the rights to
// use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
// the Software, and to permit persons to whom the Software is furnished to do so,
// subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
// FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
// COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
// IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
// CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//
//  BLRView.h
//  7blur
//
//  Created by JUSTIN M FISCHER on 9/02/13.
//  Copyright (c) 2013 Justin M Fischer. All rights reserved.
//

typedef enum {
    KBlurUndefined = 0,
    KStaticBlur = 1,
    KLiveBlur = 2
} BlurType;

typedef enum {
    KShouldMoveDown = 0,
    KShouldMoveUp = 1,
    KShouldMoveLeft = 2,
    KShouldMoveRight = 3
} ViewDirection;






@class BLRColorComponents;
@class BLRView;
/// A UIView subclass that supports live real time and static blurs. See https://github.com/justinmfischer/7blur
///

#import "BLRView.h"
#import "BLRButton.h"
#import "UIImage+ImageEffects.h"


@protocol BLRViewDelegate <NSObject>
@optional
- (void)sidebar:(BLRView *)sidebar willShowOnScreenAnimated:(BOOL)animatedYesOrNo;
- (void)sidebar:(BLRView *)sidebar didShowOnScreenAnimated:(BOOL)animatedYesOrNo;
- (void)sidebar:(BLRView *)sidebar willDismissFromScreenAnimated:(BOOL)animatedYesOrNo;
- (void)sidebar:(BLRView *)sidebar didDismissFromScreenAnimated:(BOOL)animatedYesOrNo;
- (void)sidebar:(BLRView *)sidebar didTapItemAtIndex:(NSUInteger)index;
- (void)sidebar:(BLRView *)sidebar didEnable:(BOOL)itemEnabled itemAtIndex:(NSUInteger)index;
@end


@interface BLRView : UIView <UIGestureRecognizerDelegate>
@property(nonatomic, strong) IBOutlet UIImageView *backgroundImageView;
@property(nonatomic, strong) IBOutlet UITextView *textView;


@property (nonatomic,assign) ViewDirection viewDirection ;

@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSArray *borderColors;
@property (nonatomic, strong) NSMutableArray *itemViews;
@property (nonatomic, strong) NSMutableIndexSet *selectedIndices;
@property (nonatomic, strong) NSMutableArray  *lables;

// The width of the sidebar
// Default 150
@property (nonatomic, assign) CGFloat width;

// Access the view that contains the menu items
@property (nonatomic, strong) UIScrollView *contentView;

// Toggle displaying the sidebar on the right side of the device
// Default NO
@property (nonatomic, assign) BOOL showFromRight;

// The duration of the show and hide animations
// Default 0.25
@property (nonatomic, assign) CGFloat animationDuration;

// The dimension for each item view, not including padding
// Default {75, 75}
@property (nonatomic, assign) CGSize itemSize;

// The color to tint the blur effect
// Default white: 0.2, alpha: 0.73
@property (nonatomic, strong) UIColor *buttonTintColor;

// The background color for each item view
// NOTE: set using either colorWithWhite:alpha or colorWithRed:green:blue:alpha
// Default white: 1, alpha 0.25
@property (nonatomic, strong) UIColor *itemBackgroundColor;

// The width of the colored border for selected item views
// Default 2
@property (nonatomic, assign) NSUInteger borderWidth;

// If YES, only a single item can be selected at a time, and one item is always selected
// Default NO
@property (nonatomic, assign) BOOL isSingleSelect;


// An optional delegate to respond to interaction events
@property (nonatomic, weak) id <BLRViewDelegate> delegate;
/// Drop down menu style.
///
/// @param UIView as background content
/// @return A newly created BLRView instance
+ (BLRView *) load:(UIView *) view rect:(CGRect)rect initWithImages:(NSArray *)images selectedIndices:(NSIndexSet *)selectedIndices borderColors:(NSArray *)colors Names:(NSArray*)names;

///Fixed position style.
///
/// @param Location CGPoint point
/// @param Parent UIView as background content
/// @return A newly created BLRView instance
+ (BLRView *) loadWithLocation:(CGPoint) point parent:(UIView *) view;

///Remove.
///
/// @brief Invalidates timers and removes view from superview.
/// @return void
- (void) unload;

///Down.
///
/// @brief Slides down drop down menu into place.
/// @return void
- (void) slideDown;

///Up.
///
/// @brief Slides up drop down menu.
/// @return void
- (void) slideUp;

-(void) slideLeft;

-(void) slideRight;

//-(void) panFiger: (CGPoint)cgpoint;
///Static blur.
///
/// @brief Blur content with static blur.
/// @param BLRColorComponents as blur components
/// @return void
- (void) blurWithColor:(BLRColorComponents *) components CGRect:(CGRect) point;

//Live real time blur.
///
/// @brief Start live real time blur with update interval in seconds.
/// @param BLRColorComponents as blur components
/// @param Update interval float as interval for background content updates
/// @return void
- (void) blurWithColor:(BLRColorComponents *) components CGPoint:(CGPoint) point updateInterval:(float) interval;

@end



@interface BLRColorComponents : NSObject

@property(nonatomic, assign) CGFloat radius;
@property(nonatomic, strong) UIColor *tintColor;
@property(nonatomic, assign) CGFloat saturationDeltaFactor;
@property(nonatomic, strong) UIImage *maskImage;
/// Blur color components.
///Light color effect.
///
+ (BLRColorComponents *) lightEffect;

///Dark color effect.
///
+ (BLRColorComponents *) darkEffect;

///Coral color effect.
///
+ (BLRColorComponents *) coralEffect;

///Neon color effect.
///
+ (BLRColorComponents *) neonEffect;

///Sky color effect.
///
+ (BLRColorComponents *) skyEffect;

@end