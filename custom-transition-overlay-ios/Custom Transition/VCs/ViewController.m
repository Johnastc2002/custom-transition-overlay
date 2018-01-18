//
//  ViewController.m
//  Custom Transition
//
//  Created by Johnny LEE on 1/17/18.
//  Copyright © 2018 Johnny. All rights reserved.
//

#import "ViewController.h"

#import "CustomAnimationController.h"
#import "NextViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)nextButtonDidClick:(id)sender
{
    NextViewController *vc = [NextViewController new];
    vc.transitioningDelegate = self;
    [self presentViewController:vc animated:YES completion:nil];
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    
    return [[CustomAnimationController alloc] initWithOriginFrame:self.view.frame fromVC:source toVC:presented];
}

@end
