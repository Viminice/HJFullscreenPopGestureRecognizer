//
//  UIViewController+HJFullscreenPopGestureRecognizer.m
//  HJFullscreenPopGestureRecognizer
//
//  Created by Vimin on 2017/3/24.
//  Copyright © 2017年 广州方鼎软件科技发展有限公司. All rights reserved.
//

#import "UIViewController+HJFullscreenPopGestureRecognizer.h"
#import <objc/runtime.h>
#import "UINavigationController+HJFullscreenPopGestureRecognizer.h"

static const void *hj_fullscreenPopGestureRecognizerEnabledKey = "hj_fullscreenPopGestureRecognizerEnabledKey";

@implementation UIViewController (HJFullscreenPopGestureRecognizer)

- (void)setHj_fullscreenPopGestureRecognizerEnabled:(BOOL)hj_fullscreenPopGestureRecognizerEnabled {
    // runtime关联属性
    objc_setAssociatedObject(self, hj_fullscreenPopGestureRecognizerEnabledKey, @(hj_fullscreenPopGestureRecognizerEnabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    // 全屏返回手势开关
    self.navigationController.hj_fullscreenPopGestureRecognizer.enabled = hj_fullscreenPopGestureRecognizerEnabled;
    self.navigationController.interactivePopGestureRecognizer.enabled = !hj_fullscreenPopGestureRecognizerEnabled;
}

- (BOOL)hj_fullscreenPopGestureRecognizerEnabled {
    return [objc_getAssociatedObject(self, hj_fullscreenPopGestureRecognizerEnabledKey) boolValue];
}

@end
