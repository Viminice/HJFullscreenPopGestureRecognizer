//
//  SecondController.m
//  HJFullscreenPopGestureRecognizer
//
//  Created by Vimin on 2017/3/27.
//  Copyright © 2017年 广州方鼎软件科技发展有限公司. All rights reserved.
//

#import "SecondController.h"
#import "ThirdController.h"
#import "HJFullscreenPopGestureRecognizer.h"

@interface SecondController ()

@end

@implementation SecondController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.hj_fullscreenPopGestureRecognizerEnabled = NO;
}

- (IBAction)normalPush:(id)sender {
    ThirdController *third = [[ThirdController alloc] init];
    [self.navigationController pushViewController:third animated:YES];
}

- (IBAction)animatedPush:(id)sender {
    ThirdController *third = [[ThirdController alloc] init];
    [self.navigationController hj_animatedPushViewController:third];
}

- (IBAction)normalPop:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)animatedPop:(id)sender {
    [self.navigationController hj_animatedPopViewController];
}

- (void)dealloc {
    NSLog(@"我死了");
}

@end
