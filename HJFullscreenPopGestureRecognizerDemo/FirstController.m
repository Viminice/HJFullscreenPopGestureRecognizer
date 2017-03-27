//
//  FirstController.m
//  HJFullscreenPopGestureRecognizer
//
//  Created by Vimin on 2017/3/27.
//  Copyright © 2017年 广州方鼎软件科技发展有限公司. All rights reserved.
//

#import "FirstController.h"
#import "HJFullscreenPopGestureRecognizer.h"
#import "SecondController.h"

@interface FirstController ()

@end

@implementation FirstController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.hj_fullscreenPopGestureRecognizerEnabled = YES;
}

- (IBAction)normalPush:(id)sender {
    SecondController *second = [[SecondController alloc] init];
    [self.navigationController pushViewController:second animated:YES];
}

- (IBAction)animatedPush:(id)sender {
    SecondController *second = [[SecondController alloc] init];
    [self.navigationController hj_animatedPushViewController:second];
}

- (IBAction)normalPop:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)animatedPop:(id)sender {
    [self.navigationController hj_animatedPopViewController];
}


@end
