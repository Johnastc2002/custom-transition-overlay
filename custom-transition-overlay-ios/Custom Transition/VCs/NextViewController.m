//
//  NextViewController.m
//  Custom Transition
//
//  Created by Johnny LEE on 1/17/18.
//  Copyright © 2018 Johnny. All rights reserved.
//

#import "NextViewController.h"

@interface NextViewController ()

@end

@implementation NextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonDidClick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
