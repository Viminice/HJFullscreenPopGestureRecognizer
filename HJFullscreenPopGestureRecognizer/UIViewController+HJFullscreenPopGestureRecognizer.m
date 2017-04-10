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
#import "UIWindow+HJFullscreenPopGestureRecognizer.h"
#import "HJFullscreenPopGestureRecognizerView.h"
#import "UIView+HJFullscreenPopGestureRecognizer.h"

#define HJ_KEYWINDOW                [UIApplication sharedApplication].keyWindow
#define HJ_ROOTVIEWCONTROLLER       HJ_KEYWINDOW.rootViewController
#define HJ_PRESENTEDVIEWCONTROLLER  HJ_ROOTVIEWCONTROLLER.presentedViewController

static const void *hj_fullscreenPopGestureRecognizerEnabledKey = "hj_fullscreenPopGestureRecognizerEnabledKey";

@interface UIViewController () <UIGestureRecognizerDelegate>

@end

@implementation UIViewController (HJFullscreenPopGestureRecognizer)

+ (void)load {
    // 交换方法
    Method hj_dissmiss = class_getInstanceMethod(self, @selector(hj_dismissViewControllerAnimated:completion:));
    Method dissmiss = class_getInstanceMethod(self, @selector(dismissViewControllerAnimated:completion:));
    method_exchangeImplementations(hj_dissmiss, dissmiss);
}

- (void)setHj_fullscreenPopGestureRecognizerEnabled:(BOOL)hj_fullscreenPopGestureRecognizerEnabled {
    // runtime关联属性
    objc_setAssociatedObject(self, hj_fullscreenPopGestureRecognizerEnabledKey, @(hj_fullscreenPopGestureRecognizerEnabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    pan.delegate = self;
    pan.enabled = hj_fullscreenPopGestureRecognizerEnabled;
    if (hj_fullscreenPopGestureRecognizerEnabled) {
        [self.view addGestureRecognizer:pan];
    }
}

- (BOOL)hj_fullscreenPopGestureRecognizerEnabled {
    return [objc_getAssociatedObject(self, hj_fullscreenPopGestureRecognizerEnabledKey) boolValue];
}

- (void)pan:(UIPanGestureRecognizer *)pan {
    if (self.navigationController.viewControllers.count <= 1) return;
    CGFloat offsetX = [pan translationInView:self.view].x;
    if (pan.state == UIGestureRecognizerStateBegan) {
        // 显示window的hj_fullscreenPopGestureRecognizerView
        HJ_KEYWINDOW.hj_fullscreenPopGestureRecognizerView.hidden = NO;
    }else if (pan.state == UIGestureRecognizerStateChanged) {
        // 留多20间距确认用户真的是要返回
        if (offsetX > 20.0) {
            // 平移出窗口
            HJ_ROOTVIEWCONTROLLER.view.transform = CGAffineTransformMakeTranslation(offsetX - 20.0, 0);
            HJ_PRESENTEDVIEWCONTROLLER.view.transform = CGAffineTransformMakeTranslation(offsetX - 20.0, 0);
        }
    }else if (pan.state == UIGestureRecognizerStateEnded) {
        if (offsetX > 100.0) { // pop
            [UIView animateWithDuration:0.25 animations:^{
                // 平移出窗口
                HJ_ROOTVIEWCONTROLLER.view.transform = CGAffineTransformMakeTranslation(HJ_KEYWINDOW.hj_width, 0);
                HJ_PRESENTEDVIEWCONTROLLER.view.transform = CGAffineTransformMakeTranslation(HJ_KEYWINDOW.hj_width, 0);
            } completion:^(BOOL finished) {
                // 控制器跳转
                [self.navigationController popViewControllerAnimated:NO];
                // 恢复
                HJ_ROOTVIEWCONTROLLER.view.transform = CGAffineTransformIdentity;
                HJ_PRESENTEDVIEWCONTROLLER.view.transform = CGAffineTransformIdentity;
                HJ_KEYWINDOW.hj_fullscreenPopGestureRecognizerView.hidden = YES;
            }];
        }else {
            [UIView animateWithDuration:0.25 animations:^{
                // 恢复
                HJ_ROOTVIEWCONTROLLER.view.transform = CGAffineTransformIdentity;
                HJ_PRESENTEDVIEWCONTROLLER.view.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                HJ_KEYWINDOW.hj_fullscreenPopGestureRecognizerView.hidden = YES;
            }];
        }
    }
}

- (void)hj_dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion {
    // 删除window的hj_fullscreenPopGestureRecognizerView
    [HJ_KEYWINDOW.hj_fullscreenPopGestureRecognizerView removeFromSuperview];
    HJ_KEYWINDOW.hj_fullscreenPopGestureRecognizerView = nil;
    [self hj_dismissViewControllerAnimated:flag completion:completion];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.view == self.view) {
        if (self.hj_fullscreenPopGestureRecognizerEnabled) {
            CGPoint point = [gestureRecognizer translationInView:self.view];
            if (point.x > 0 && point.y == 0) {
                return YES;
            }
        }
    }
    return NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([otherGestureRecognizer isKindOfClass:NSClassFromString(@"UIScrollViewPanGestureRecognizer")] || [otherGestureRecognizer isKindOfClass:NSClassFromString(@"UIPanGestureRecognizer")] || [otherGestureRecognizer isKindOfClass:NSClassFromString(@"UIScrollViewPagingSwipeGestureRecognizer")]) {
        if ([otherGestureRecognizer.view isKindOfClass:[UIScrollView class]]) {
            CGFloat offsetX = ((UIScrollView *)otherGestureRecognizer.view).contentOffset.x;
            if (offsetX == 0) {
                return YES;
            }
        }
        return NO;
    }
    return YES;
}

@end
