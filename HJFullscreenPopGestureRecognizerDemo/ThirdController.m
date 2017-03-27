//
//  ThirdController.m
//  HJFullscreenPopGestureRecognizer
//
//  Created by Vimin on 2017/3/27.
//  Copyright © 2017年 广州方鼎软件科技发展有限公司. All rights reserved.
//

#import "ThirdController.h"
#import "HJFullscreenPopGestureRecognizer.h"

@interface ThirdController ()

@end

@implementation ThirdController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.hj_fullscreenPopGestureRecognizerEnabled = YES;
}

- (IBAction)popToRootViewController:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)animatedPopToRootViewController:(id)sender {
    [self.navigationController hj_animatedPopToRootViewController];
}

@end
