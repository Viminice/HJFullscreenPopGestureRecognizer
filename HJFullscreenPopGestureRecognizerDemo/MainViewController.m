//
//  MainViewController.m
//  HJFullscreenPopGestureRecognizer
//
//  Created by Vimin on 2017/3/27.
//  Copyright © 2017年 广州方鼎软件科技发展有限公司. All rights reserved.
//

#import "MainViewController.h"
#import "FirstController.h"
#import "HJFullscreenPopGestureRecognizer.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)normalPush:(id)sender {
    FirstController *first = [[FirstController alloc] init];
    [self.navigationController pushViewController:first animated:YES];
}

- (IBAction)animatedPush:(id)sender {
    FirstController *first = [[FirstController alloc] init];
    [self.navigationController hj_animatedPushViewController:first];
}


- (void)dealloc {
    NSLog(@"我死了");
}

@end
