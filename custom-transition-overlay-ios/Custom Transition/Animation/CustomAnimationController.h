//
//  CustomAnimationController.h
//  Custom Transition
//
//  Created by Johnny LEE on 1/17/18.
//  Copyright © 2018 Johnny. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@interface CustomAnimationController : NSObject <UIViewControllerTransitioningDelegate>

- (instancetype)initWithOriginFrame:(CGRect)originFrame fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC;

@property (strong, nonatomic) UIViewController *fromVC;
@property (strong, nonatomic) UIViewController *toVC;

@end
