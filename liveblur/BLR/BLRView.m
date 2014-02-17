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
//  UBLRView.m
//  7blur
//
//  Created by JUSTIN M FISCHER on 9/02/13.
//  Copyright (c) 2013 Justin M Fischer. All rights reserved.
//


#import "BLRView.h"
#define __IPHONE_OS_VERSION_SOFT_MAX_REQUIRED __IPHONE_7_0

@interface BLRView ()




@property UIColor *defaultLabelTextColor;
@property BOOL panFlagIsFirst;
@property CGPoint point;
@property(nonatomic, weak) UIView *parent;
@property(nonatomic, assign) CGPoint location;
@property(nonatomic, assign) BlurType blurType;
@property(nonatomic, strong) BLRColorComponents *colorComponents;

@property(nonatomic, strong) dispatch_source_t timer;
@property(nonatomic, assign) CGRect rect;
@end

@implementation BLRView

@synthesize viewDirection ;
@synthesize contentView ;
@synthesize backgroundImageView;
@synthesize isSingleSelect;
@synthesize tapGesture;
@synthesize images;
@synthesize borderColors;
@synthesize itemViews;
@synthesize selectedIndices;

- (id) initWithCoder:(NSCoder *) aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        
    }
    
    return self;
}



+ (BLRView *) load:(UIView *) view rect:(CGRect)rect initWithImages:(NSArray *)images selectedIndices:(NSIndexSet *)selectedIndices borderColors:(NSArray *)colors Names:(NSArray *)names{
    BLRView *blur = [[[NSBundle mainBundle] loadNibNamed:@"BLRView" owner:nil options:nil] objectAtIndex:0];
    
    blur.location = CGPointMake(0, 0);

    blur.frame = rect;
    blur.width = rect.size.width;
    blur.parent = view;
    blur.viewDirection = KShouldMoveRight;
    blur.panFlagIsFirst = YES;
    
    //单选择还是多选
    blur.isSingleSelect = YES;
    
    //初始化
    blur.contentView = [[UIScrollView alloc] init];
    blur.contentView.alwaysBounceHorizontal = NO;
    blur.contentView.alwaysBounceVertical = YES;
    blur.contentView.bounces = YES;
    blur.contentView.clipsToBounds = NO;
    blur.contentView.showsHorizontalScrollIndicator = NO;
    blur.contentView.showsVerticalScrollIndicator = NO;
    blur.contentView.decelerationRate = 0.1;
    
    blur.defaultLabelTextColor = [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0f];
    [blur addSubview:blur.contentView];
    [blur bringSubviewToFront:blur.contentView];
    
    blur.animationDuration = 0.25f;
    blur.itemSize = CGSizeMake(rect.size.width/3, rect.size.width/3);
    
    blur.itemViews = [NSMutableArray array];
    blur.lables = [NSMutableArray array];
    blur.tintColor = [UIColor colorWithWhite:0.2 alpha:0.73];
    blur.borderWidth = 2;
    blur.itemBackgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.25];
    
    if (colors) {
        NSAssert([colors count] == [images count], @"Border color count must match images count. If you want a blank border, use [UIColor clearColor].");
    }
    
    blur.selectedIndices = [selectedIndices mutableCopy] ?: [NSMutableIndexSet indexSet];
    blur.borderColors = colors;
    blur.images = images;
    
    UITapGestureRecognizer *uiTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:blur action:@selector(handleExTap:)];
    [blur addGestureRecognizer:uiTapGestureRecognizer];
    
    uiTapGestureRecognizer.delegate = blur;
    
    //初始化blrbutton与label
    [blur.images enumerateObjectsUsingBlock:^(UIImage *image, NSUInteger idx, BOOL *stop) {
        BLRButton *view = [[BLRButton alloc] init];
        view.itemIndex = idx;
        view.clipsToBounds = YES;
        view.imageView.image = image;
        view.layer.borderWidth = 4;
        [blur.contentView addSubview:view];
        [blur.itemViews addObject:view];
        
        
        UILabel *label = [[UILabel alloc] init];
        label.text = names[idx];
        label.font = [UIFont fontWithName:label.font.fontName size:19];
        label.adjustsFontSizeToFitWidth =YES;
        [blur.contentView addSubview:label];
        [blur.lables addObject:label];
        
        //如果color不为空、选择的位置不为空并且选择的位置是当前位置
        if (blur.borderColors && blur.selectedIndices && [blur.selectedIndices containsIndex:idx]) {
            UIColor *color = blur.borderColors[idx];
            view.layer.borderColor = color.CGColor;
            label.textColor =color;
        }
        else {
            view.layer.borderColor = [UIColor clearColor].CGColor;
            label.textColor = blur.defaultLabelTextColor;
        }
    }];
    
    
    
    
    
    return blur;
}

+ (BLRView *) loadWithLocation:(CGPoint) point parent:(UIView *) view {
    BLRView *blur = [[[NSBundle mainBundle] loadNibNamed:@"BLRView" owner:nil options:nil] objectAtIndex:0];
    
    blur.parent = view;
    blur.location = point;
    blur.frame = CGRectMake(0, 0, blur.frame.size.width, blur.frame.size.height);
    
    return blur;
}

//- (void) awakeFromNib {
//    self.gripBarView.layer.cornerRadius = 6;
//}

- (void) unload {
    if(self.timer != nil) {
        
        dispatch_source_cancel(self.timer);
        self.timer = nil;
    }
    
    [self removeFromSuperview];
}

- (void) blurBackground :(CGRect) point{
    

    if(CGRectGetWidth(point)<5){
        return;
    }
    
    
    //定义一个图片上下文
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(CGRectGetWidth(self.parent.frame), CGRectGetHeight(self.parent.frame)), NO, 1);
    
    /*
     * 
     * 获取上级目录的截屏
     * renderInContext快很多
     */
    
     [self.parent.layer renderInContext:UIGraphicsGetCurrentContext()];
//    [self.parent drawViewHierarchyInRect:CGRectMake(0, 0, CGRectGetWidth(self.parent.frame), CGRectGetHeight(self.parent.frame)) afterScreenUpdates:NO];

    __block UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        
        //Blur finished in 0.004884 seconds.
        snapshot = [snapshot applyBlurWithCrop:CGRectMake(0, 0, CGRectGetWidth(point), CGRectGetHeight(point)) resize:CGSizeMake(CGRectGetWidth(point), CGRectGetHeight(point)) blurRadius:self.colorComponents.radius tintColor:self.colorComponents.tintColor saturationDeltaFactor:self.colorComponents.saturationDeltaFactor maskImage:self.colorComponents.maskImage];
        
       
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.backgroundImageView.image = snapshot;
            snapshot = nil;
        });
    });
}

- (void) blurWithColor:(BLRColorComponents *) components CGRect:(CGRect) point{
    if(self.blurType == KBlurUndefined) {
        
        self.blurType = KStaticBlur;
        self.colorComponents = components;
    }
    
    [self blurBackground:point];
}

- (void) blurWithColor:(BLRColorComponents *) components CGPoint:(CGPoint) point updateInterval:(float) interval {
    self.blurType = KLiveBlur;
    self.colorComponents = components;
    
    //创建定时器
    self.timer = CreateDispatchTimer(interval * NSEC_PER_SEC, 1ull * NSEC_PER_SEC, dispatch_get_main_queue(), ^{
        CGRect rect = [[self.layer presentationLayer] frame];
        CGRect size = CGRectMake(-rect.origin.x,0,self.frame.size.width + rect.origin.x, self.frame.size.height);
        
        [self blurWithColor:components CGRect:size];
    });

}

dispatch_source_t CreateDispatchTimer(uint64_t interval, uint64_t leeway, dispatch_queue_t queue, dispatch_block_t block) {
    
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    if (timer) {
        dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), interval, leeway);
        dispatch_source_set_event_handler(timer, block);
        
        
    }
    
    return timer;
}






//动态显示 blrbutton与label的方法
- (void)show {
    CGFloat initDelay = 0.1f;

    
    
    SEL sdkSpringSelector = NSSelectorFromString(@"animateWithDuration:delay:usingSpringWithDamping:initialSpringVelocity:options:animations:completion:");
    BOOL sdkHasSpringAnimation = [UIView respondsToSelector:sdkSpringSelector];
    
    //遍历每个itemview，设置放大1.2倍然后恢复原始大小的动画
    [self.itemViews enumerateObjectsUsingBlock:^(BLRButton *view, NSUInteger idx, BOOL *stop) {
        view.layer.transform = CATransform3DMakeScale(0.3, 0.3, 1);
        view.alpha = 0;
        view.originalBackgroundColor = self.itemBackgroundColor;
        view.layer.borderWidth = self.borderWidth;
        
        UILabel *label = [self.lables objectAtIndex:idx];

        [self animateFauxBounceWithView:view idx:idx initDelay:initDelay];
        
        [self animateFauxBounceWithView:label idx:idx initDelay:initDelay];
//        
//        if (sdkHasSpringAnimation) {
//            [self animateSpringWithView:view idx:idx initDelay:initDelay];
//        }
//        else {
//            [self animateFauxBounceWithView:view idx:idx initDelay:initDelay];
//        }
    }];

}

//ios7 使用的方法，每设置成功
- (void)animateSpringWithView:(BLRButton *)view idx:(NSUInteger)idx initDelay:(CGFloat)initDelay {
#if __IPHONE_OS_VERSION_SOFT_MAX_REQUIRED
    [UIView animateWithDuration:0.1
                          delay:(initDelay + idx*0.1f)
         usingSpringWithDamping:10
          initialSpringVelocity:50
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         view.layer.transform = CATransform3DIdentity;
                         view.alpha = 1;
                     }
                     completion:nil];
#endif
}

//设置动画的方法
- (void)animateFauxBounceWithView:(UIView *)view idx:(NSUInteger)idx initDelay:(CGFloat)initDelay {
    [UIView animateWithDuration:0.1
                          delay:(initDelay + idx*0.1f)
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationCurveEaseInOut
                     animations:^{
                         view.layer.transform = CATransform3DMakeScale(1.2, 1.2, 1);
                         view.alpha = 1;
                         
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.1 animations:^{
                             view.layer.transform = CATransform3DIdentity;
                         }];
                     }];
    
}

//点击处理方法
- (void)handleExTap:(UITapGestureRecognizer *)recognizer {
        //获取点击的索引
        NSInteger tapIndex = [self indexOfTap:[recognizer locationInView:self.contentView]];
        if (tapIndex != NSNotFound) {
            [self didTapItemAtIndex:tapIndex];
        }
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    for(UIView *view1 in gestureRecognizer.view.subviews){
        if([view1 isDescendantOfView:self.parent]){
            return NO;
        }
    }
    return YES;
}

//处理点击效果
- (void)didTapItemAtIndex:(NSUInteger)index {
    //判断是否以前点击过这个列
    BOOL didEnable = ! [self.selectedIndices containsIndex:index];
    
    if ([self.delegate respondsToSelector:@selector(sidebar:didTapItemAtIndex:)]) {
        [self.delegate sidebar:self didTapItemAtIndex:index];
    }
    
    if (self.borderColors) {
        UIColor *stroke = self.borderColors[index];
        UIView *view = self.itemViews[index];
        UILabel *lable = self.lables[index];
        if (didEnable) {
            //是多选还是单选
            if (isSingleSelect){
                //单选就删掉所有其他选择，并且把其他button与label设置为默认颜色
                [self.selectedIndices removeAllIndexes];
                [self.itemViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    UIView *aView = (UIView *)obj;
                    [[aView layer] setBorderColor:[[UIColor clearColor] CGColor]];
                    UILabel *lable = self.lables[idx];
                    lable.textColor = self.defaultLabelTextColor;
                    
                }];
            }
            //设置颜色与动画
            view.layer.borderColor = stroke.CGColor;
            lable.textColor =stroke;
            CABasicAnimation *borderAnimation = [CABasicAnimation animationWithKeyPath:@"borderColor"];
            borderAnimation.fromValue = (id)[UIColor clearColor].CGColor;
            borderAnimation.toValue = (id)stroke.CGColor;
            borderAnimation.duration = 0.5f;
            [view.layer addAnimation:borderAnimation forKey:nil];
                    }
        else {
            if (!isSingleSelect){
                view.layer.borderColor = [UIColor clearColor].CGColor;
                lable.textColor = self.defaultLabelTextColor;
                [self.selectedIndices removeIndex:index];
            }
        }
        //建立一个圆形图形
        CGRect pathFrame = CGRectMake(-CGRectGetMidX(view.bounds), -CGRectGetMidY(view.bounds), view.bounds.size.width, view.bounds.size.height);
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:pathFrame cornerRadius:view.layer.cornerRadius];
        
        //获取中心点在contentView中的坐标
        // accounts for left/right offset and contentOffset of scroll view
        CGPoint shapePosition = [self convertPoint:view.center fromView:self.contentView];
        
        //创建一个圆,设置中心点,颜色为无颜色
        CAShapeLayer *circleShape = [CAShapeLayer layer];
        circleShape.path = path.CGPath;
        circleShape.position = shapePosition;
        circleShape.fillColor = [UIColor clearColor].CGColor;
        circleShape.opacity = 0;
        //线颜色与线宽度
        circleShape.strokeColor = stroke.CGColor;
        circleShape.lineWidth = self.borderWidth;
        
        [self.layer addSublayer:circleShape];
        
        //设置放大的方法
        CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
        scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(2.5, 2.5, 1)];
        
        //逐渐消失
        CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        alphaAnimation.fromValue = @1;
        alphaAnimation.toValue = @0;
        
        CAAnimationGroup *animation = [CAAnimationGroup animation];
        animation.animations = @[scaleAnimation, alphaAnimation];
        animation.duration = 0.5f;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        [circleShape addAnimation:animation forKey:nil];
    }
    
    [self slideLeft];
    self.viewDirection =KShouldMoveRight;
   
}

//向左滑动
-(void) slideLeft{
    [UIView animateWithDuration:0.2f animations:^{
        self.alpha = 1;
        self.frame = CGRectMake(-self.frame.size.width,0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        self.contentView.frame = self.frame;
    } completion:^(BOOL finished){
        //停止定时获取背景的方法，设置button与lable隐藏
//        dispatch_suspend(self.timer);
//        [self NodisplayItems];
    }];
    
}

//向右滑动
-(void) slideRight{
    [UIView animateWithDuration:0.2f animations:^{
        self.frame = CGRectMake(self.location.x, self.location.y, CGRectGetWidth(self.frame),CGRectGetHeight(self.frame));
        [self blurWithColor:[BLRColorComponents lightEffect] CGRect:self.frame];
        self.contentView.frame = self.frame;
//        [self show];
    } completion:^(BOOL isfinished){
//        dispatch_resume(self.timer);
        
    }];
    
    
}

-(void) NodisplayItems{
    [self.itemViews enumerateObjectsUsingBlock:^(BLRButton *view, NSUInteger idx, BOOL *stop) {
        view.alpha = 0;
        UILabel *lable = [self.lables objectAtIndex:idx];
        lable.alpha = 0;
    }];
}

//设置button与label的位置
- (void)layoutItems {
    CGFloat leftPadding =(self.width - self.itemSize.width)/10;
    CGFloat topPadding = (self.width - self.itemSize.width)/4;
    __block double i = 0;
    [self.itemViews enumerateObjectsUsingBlock:^(BLRButton *view, NSUInteger idx, BOOL *stop) {
        
        CGRect frame = CGRectMake(leftPadding, topPadding*idx + self.itemSize.height*idx + topPadding, self.itemSize.width, self.itemSize.height);
        
        i = topPadding*idx + self.itemSize.height*idx;
        
        view.frame = frame;
        view.layer.cornerRadius = frame.size.width/2.f;
//        view.alpha = 0;
        
        CGRect rect =CGRectMake(0, 0, self.itemSize.width*1.7, self.itemSize.height/2);
        UILabel *lable = [self.lables objectAtIndex:idx];
        lable.frame = rect;
        lable.textAlignment = NSTextAlignmentCenter;
        lable.center = CGPointMake(frame.size.width + rect.size.width/2+13, view.center.y);
//        lable.backgroundColor = [UIColor whiteColor];
//        lable.
//        lable.alpha = 0;
    }];

    NSInteger items = [self.itemViews count];
    self.contentView.contentSize = CGSizeMake(0, items *(self.itemSize.height+topPadding)+ topPadding);
//    self.contentView.backgroundColor = [UIColor whiteColor];
}

- (void)layoutSubviews {
    self.contentView.frame = self.frame;
    //设置blrbutton与lable的位置
    [self layoutItems];
}

//通过点击的CGPoint来获取是点击了哪个Item
- (NSInteger)indexOfTap:(CGPoint)location {
    __block NSUInteger index = NSNotFound;
    
    [self.itemViews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        if (CGRectContainsPoint(view.frame, location)) {
            index = idx;
            *stop = YES;
        }
        
        UILabel *label = self.lables[idx];
        
        if (CGRectContainsPoint(label.frame, location)) {
            index = idx;
            *stop = YES;
        }
    }];
    
    return index;
}

- (void) slideDown {
    [UIView animateWithDuration:0.25f animations:^{
        
        self.frame = CGRectMake(self.location.x, self.location.y, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        self.alpha = 1;
        
    } completion:^(BOOL finished) {
        if(self.blurType == KStaticBlur) {
//            [self blurWithColor:self.colorComponents];
        }
    }];
}

- (void) slideUp {
    if(self.timer != nil) {
        
        dispatch_source_cancel(self.timer);
        self.timer = nil;
    }
    
    [UIView animateWithDuration:0.15f animations:^{
        
        self.frame = CGRectMake(self.location.x, -(self.frame.size.height + self.location.y), self.frame.size.width, self.frame.size.height);
        self.alpha = 0;
        
    } completion:^(BOOL finished) {
        
    }];
}

//-(void) panFiger:(CGPoint) point{
////    if (self.panFlagIsFirst==YES) {
////        self.point = point;
////        self.panFlagIsFirst = NO;
////    }
////    CGFloat panLength = point.x - self.point.x;
//    
//    CGRect size = CGRectMake(point.x,0,self.frame.size.width + point
//                             .x, self.frame.size.height);
//    [self blurWithColor:self.colorComponents CGRect:size];
//    self.frame = CGRectMake(point.x, 0,self.frame.size.width,self.frame.size.height);
//    
//}
@end

@interface BLRColorComponents()
@end

@implementation BLRColorComponents

+ (BLRColorComponents *) lightEffect {
    BLRColorComponents *components = [[BLRColorComponents alloc] init];
    
    components.radius = 1;
    components.tintColor = [UIColor colorWithWhite:.8f alpha:.2f];
    components.saturationDeltaFactor = 1.8f;
    components.maskImage = nil;
    
    return components;
}

+ (BLRColorComponents *) darkEffect {
    BLRColorComponents *components = [[BLRColorComponents alloc] init];
    
    components.radius = 8;
    components.tintColor = [UIColor colorWithRed:0.0f green:0.0 blue:0.0f alpha:.5f];
    components.saturationDeltaFactor = 3.0f;
    components.maskImage = nil;
    
    return components;
}

+ (BLRColorComponents *) coralEffect {
    BLRColorComponents *components = [[BLRColorComponents alloc] init];
    
    components.radius = 8;
    components.tintColor = [UIColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:.1f];
    components.saturationDeltaFactor = 3.0f;
    components.maskImage = nil;
    
    return components;
}

+ (BLRColorComponents *) neonEffect {
    BLRColorComponents *components = [[BLRColorComponents alloc] init];
    
    components.radius = 8;
    components.tintColor = [UIColor colorWithRed:0.0f green:1.0f blue:0.0f alpha:.1f];
    components.saturationDeltaFactor = 3.0f;
    components.maskImage = nil;
    
    return components;
}

+ (BLRColorComponents *) skyEffect {
    BLRColorComponents *components = [[BLRColorComponents alloc] init];
    
    components.radius = 4;
    components.tintColor = [UIColor colorWithRed:0.0f green:0.0f blue:1.0f alpha:.1f];
    components.saturationDeltaFactor = 3.0f;
    components.maskImage = nil;
    
    return components;
}

// ...

@end
