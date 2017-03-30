//
//  UIWindow+HJFullscreenPopGestureRecognizer.m
//  HJFullscreenPopGestureRecognizer
//
//  Created by Vimin on 2017/3/24.
//  Copyright © 2017年 广州方鼎软件科技发展有限公司. All rights reserved.
//

#import "UIWindow+HJFullscreenPopGestureRecognizer.h"
#import "HJFullscreenPopGestureRecognizerView.h"
#import <objc/runtime.h>

static const void *hj_fullscreenPopGestureRecognizerViewKey = "hj_fullscreenPopGestureRecognizerViewKey";

@implementation UIWindow (HJFullscreenPopGestureRecognizer)

- (void)setHj_fullscreenPopGestureRecognizerView:(HJFullscreenPopGestureRecognizerView *)hj_fullscreenPopGestureRecognizerView {
    objc_setAssociatedObject(self, hj_fullscreenPopGestureRecognizerViewKey, hj_fullscreenPopGestureRecognizerView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (HJFullscreenPopGestureRecognizerView *)hj_fullscreenPopGestureRecognizerView {
    // 添加hj_fullscreenPopGestureRecognizerView
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        HJFullscreenPopGestureRecognizerView *hj_fullscreenPopGestureRecognizerView = [[HJFullscreenPopGestureRecognizerView alloc] initWithFrame:self.bounds];
        [self insertSubview:hj_fullscreenPopGestureRecognizerView atIndex:0];
        self.hj_fullscreenPopGestureRecognizerView = hj_fullscreenPopGestureRecognizerView;
    });
    return objc_getAssociatedObject(self, hj_fullscreenPopGestureRecognizerViewKey);
}

@end
