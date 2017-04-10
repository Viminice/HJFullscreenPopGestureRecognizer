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
static const void *hj_fullscreenPopGestureRecognizerViewExistKey = "hj_fullscreenPopGestureRecognizerViewExistKey";

@interface UIWindow ()

/**
 *  hj_fullscreenPopGestureRecognizerView是否存在
 */
@property (assign, nonatomic) BOOL hj_fullscreenPopGestureRecognizerViewExist;

@end

@implementation UIWindow (HJFullscreenPopGestureRecognizer)

- (void)setHj_fullscreenPopGestureRecognizerView:(HJFullscreenPopGestureRecognizerView *)hj_fullscreenPopGestureRecognizerView {
    if (hj_fullscreenPopGestureRecognizerView == nil) {
        self.hj_fullscreenPopGestureRecognizerViewExist = NO;
    }
    objc_setAssociatedObject(self, hj_fullscreenPopGestureRecognizerViewKey, hj_fullscreenPopGestureRecognizerView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (HJFullscreenPopGestureRecognizerView *)hj_fullscreenPopGestureRecognizerView {
    // 添加hj_fullscreenPopGestureRecognizerView
    if (!self.hj_fullscreenPopGestureRecognizerViewExist) {
        HJFullscreenPopGestureRecognizerView *hj_fullscreenPopGestureRecognizerView = [[HJFullscreenPopGestureRecognizerView alloc] initWithFrame:self.bounds];
        [self insertSubview:hj_fullscreenPopGestureRecognizerView atIndex:0];
        self.hj_fullscreenPopGestureRecognizerView = hj_fullscreenPopGestureRecognizerView;
        self.hj_fullscreenPopGestureRecognizerViewExist = YES;
    }
    return objc_getAssociatedObject(self, hj_fullscreenPopGestureRecognizerViewKey);
}

- (void)setHj_fullscreenPopGestureRecognizerViewExist:(BOOL)hj_fullscreenPopGestureRecognizerViewExist {
    objc_setAssociatedObject(self, hj_fullscreenPopGestureRecognizerViewExistKey, @(hj_fullscreenPopGestureRecognizerViewExist), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)hj_fullscreenPopGestureRecognizerViewExist {
    return [objc_getAssociatedObject(self, hj_fullscreenPopGestureRecognizerViewExistKey) boolValue];
}

@end
