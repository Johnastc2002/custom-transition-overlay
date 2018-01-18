//
//  CustomAnimationController.m
//  Custom Transition
//
//  Created by Johnny LEE on 1/17/18.
//  Copyright © 2018 Johnny. All rights reserved.
//

#import "CustomAnimationController.h"

#import "PureLayout.h"
#import "SVGKit.h"

@interface CustomAnimationController ()

@property (assign, nonatomic) CGRect originFrame;

@end

@implementation CustomAnimationController

- (instancetype)initWithOriginFrame:(CGRect)originFrame fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC
{
    self = [super init];
    if(self)
    {
        self.originFrame = originFrame;
        self.fromVC = fromVC;
        self.toVC = toVC;
    }
    return self;
}

- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext
{
    // For using xib.
    UIViewController *fromVC = self.fromVC;
    UIViewController *toVC = self.toVC;
    UIView *snapshot = [toVC.view snapshotViewAfterScreenUpdates:YES];

    if(!fromVC || !toVC || !snapshot)
    {
        return;
    }
    
    // Hide both VC until the animation ends, to show the outlook of toVC, use snapshot, which is a fake UIView looks like toVC
    fromVC.view.hidden = YES;
    toVC.view.hidden = YES;
    
    UIView *containerView = transitionContext.containerView;
    
    //Adding toVC.view for user interaction after animation, otherwise the it will show blank after animation
    [containerView addSubview:toVC.view];
    [containerView addSubview:snapshot];

    // White background View
    UIView *whiteBGView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    whiteBGView.backgroundColor = UIColor.whiteColor;
    [containerView addSubview:whiteBGView];
    
    // For add margin when scaling
    CGFloat kScaleForShrink = 10;
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    //For adding margin when rotation
    NSInteger rotationOffset = sqrt(screenWidth * screenWidth + screenHeight * screenHeight) / 2;
    
    NSInteger coverX = -rotationOffset * kScaleForShrink + screenWidth / 2;
    NSInteger coverY = -rotationOffset * kScaleForShrink + screenHeight / 2;
    
    NSInteger coverWidth = rotationOffset * 2 * kScaleForShrink;
    NSInteger coverHeight = rotationOffset * 2 * kScaleForShrink;

    UIView *cover = [[UIView alloc] initWithFrame:CGRectMake(coverX, coverY, coverWidth, coverHeight)];
    [self addHoleForView:cover];
    cover.backgroundColor = UIColor.clearColor;
    [containerView addSubview:cover];
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    //Expand first
    CGAffineTransform transform = CGAffineTransformMakeScale(kScaleForShrink, kScaleForShrink);
    cover.layer.affineTransform = transform;

    /*********************** DO NOT SET HIDDEN FOR VIEW INSIDE ANIMATION !!!!!! IT WONT WORK !!!!!***********************/
    [UIView animateKeyframesWithDuration:duration
                                   delay:0
                                 options:UIViewKeyframeAnimationOptionCalculationModeCubic
                              animations:^
    {
         [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.1 animations:^{
             //Then Shrink
             CGAffineTransform transform = CGAffineTransformMakeScale(1, 1);
             cover.layer.affineTransform = transform;
         }];
        
        // As The animation will find the shortest path, therefore we cannot set M_PI * 2 for 360 degress.
        // Instead, we set the destination 4 times (3 times should be work as well) to guide the animation to the destination point (i.e. 90 degrees, 180 degrees, 270 degrees, 360 degrees)
        [UIView addKeyframeWithRelativeStartTime:0.2 relativeDuration:0.15 animations:^{
            //Rotate
            CGAffineTransform transform = CGAffineTransformMakeRotation (M_PI_2);
            cover.layer.affineTransform = transform;
        }];
        
        [UIView addKeyframeWithRelativeStartTime:0.35 relativeDuration:0.15 animations:^{
            //Rotate
            CGAffineTransform transform = CGAffineTransformMakeRotation (M_PI);
            cover.layer.affineTransform = transform;
        }];
        
        [UIView addKeyframeWithRelativeStartTime:0.5 relativeDuration:0.15 animations:^{
            //Rotate
            CGAffineTransform transform = CGAffineTransformMakeRotation (- M_PI_2);
            cover.layer.affineTransform = transform;
        }];
        
        [UIView addKeyframeWithRelativeStartTime:0.65 relativeDuration:0.15 animations:^{
            //Rotate
            CGAffineTransform transform = CGAffineTransformIdentity;
            cover.layer.affineTransform = transform;
        }];
        
        
        [UIView addKeyframeWithRelativeStartTime:0.8 relativeDuration:0.1 animations:^{
            //bounce
            whiteBGView.alpha = 0;
            CGAffineTransform transform = CGAffineTransformMakeScale(1.0/kScaleForShrink, 1.0/kScaleForShrink);
            cover.layer.affineTransform = transform;
        }];
         
         [UIView addKeyframeWithRelativeStartTime:0.9 relativeDuration:0.1 animations:^{
             // Zoom out
             CGAffineTransform transform = CGAffineTransformMakeScale(10, 10);
             cover.layer.affineTransform = transform;
         }];
    }
    completion:^(BOOL finished)
    {
        [snapshot removeFromSuperview];
        [cover removeFromSuperview];
        fromVC.view.hidden = NO;
        toVC.view.hidden = NO;
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}

- (void)addHoleForView:(UIView *)view
{
    UIBezierPath *path = [UIBezierPath
                          bezierPathWithRoundedRect:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)cornerRadius:0];
    
    //Translating SVG file to UIBezierPath
    SVGKImage* newImage = [SVGKImage imageNamed:@"github"];
    CALayer *layer = [newImage newCALayerTree];
    CAShapeLayer *shapeLayer = (CAShapeLayer *)layer.sublayers.firstObject;
    UIBezierPath *imagePath = [UIBezierPath new];
    imagePath.CGPath = shapeLayer.path;
    
    //Rescale the image (or Path)
    CGFloat kImageScale = 8;
    CGAffineTransform scaleTransform = CGAffineTransformMakeScale(kImageScale, kImageScale);
    [imagePath applyTransform:scaleTransform];
    
    // Make image center (or Path)
    CGFloat xForCenter = view.frame.size.width / 2 - (newImage.size.width / 2) * kImageScale;
    CGFloat yForCenter = view.frame.size.height / 2 - (newImage.size.height / 2) * kImageScale;
    CGAffineTransform transform = CGAffineTransformMakeTranslation(xForCenter, yForCenter);
    [imagePath applyTransform:transform];

    [path appendPath:imagePath];
    [path setUsesEvenOddFillRule:YES];
    
    CAShapeLayer *fillLayer = [CAShapeLayer layer];
    fillLayer.path = path.CGPath;
    fillLayer.fillRule = kCAFillRuleEvenOdd;
    fillLayer.fillColor = [UIColor blueColor].CGColor;
    [view.layer addSublayer:fillLayer];
}

- (NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext
{
    return 2.0;
}

@end
