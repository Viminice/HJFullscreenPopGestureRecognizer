//
//  UINavigationController+HJFullscreenPopGestureRecognizer.m
//  HJFullscreenPopGestureRecognizer
//
//  Created by Vimin on 2017/3/24.
//  Copyright © 2017年 广州方鼎软件科技发展有限公司. All rights reserved.
//

#import "UINavigationController+HJFullscreenPopGestureRecognizer.h"
#import <objc/runtime.h>
#import "UIViewController+HJFullscreenPopGestureRecognizer.h"
#import "UIWindow+HJFullscreenPopGestureRecognizer.h"
#import "HJFullscreenPopGestureRecognizerView.h"
#import "UIView+HJFullscreenPopGestureRecognizer.h"

#define HJ_KEYWINDOW                [UIApplication sharedApplication].keyWindow
#define HJ_ROOTVIEWCONTROLLER       HJ_KEYWINDOW.rootViewController
#define HJ_PRESENTEDVIEWCONTROLLER  HJ_ROOTVIEWCONTROLLER.presentedViewController

static const void *hj_fullscreenPopGestureRecognizerKey = "hj_fullscreenPopGestureRecognizerKey";

static NSMutableArray *hj_imagesArr;

@interface UINavigationController () <UIGestureRecognizerDelegate>

@end

@implementation UINavigationController (HJFullscreenPopGestureRecognizer)

+ (void)load {
    // 初始化hj_imagesArr
    hj_imagesArr = [NSMutableArray array];
    // 交换方法
    Method hj_push = class_getInstanceMethod(self, @selector(hj_pushViewController:animated:));
    Method push = class_getInstanceMethod(self, @selector(pushViewController:animated:));
    method_exchangeImplementations(hj_push, push);
    
    Method hj_pop = class_getInstanceMethod(self, @selector(hj_popViewControllerAnimated:));
    Method pop = class_getInstanceMethod(self, @selector(popViewControllerAnimated:));
    method_exchangeImplementations(hj_pop, pop);
    
    Method hj_popToRoot = class_getInstanceMethod(self, @selector(hj_popToRootViewControllerAnimated:));
    Method popToRoot = class_getInstanceMethod(self, @selector(popToRootViewControllerAnimated:));
    method_exchangeImplementations(hj_popToRoot, popToRoot);
}

- (void)setHj_fullscreenPopGestureRecognizer:(UIPanGestureRecognizer *)hj_fullscreenPopGestureRecognizer {
    // runtime关联属性
    objc_setAssociatedObject(self, hj_fullscreenPopGestureRecognizerKey, hj_fullscreenPopGestureRecognizer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIPanGestureRecognizer *)hj_fullscreenPopGestureRecognizer {
    // 添加手势
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        self.interactivePopGestureRecognizer.enabled = NO;
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        pan.delegate = self;
        [self.view addGestureRecognizer:pan];
        self.hj_fullscreenPopGestureRecognizer = pan;
    });
    return objc_getAssociatedObject(self, hj_fullscreenPopGestureRecognizerKey);
}

- (void)pan:(UIPanGestureRecognizer *)pan {
    if (self.viewControllers.count <= 1) return;
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
                [self popViewControllerAnimated:NO];
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

#pragma mark - 系统方法重写
- (void)hj_pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count >= 1) {
        // 截图并设置图片
        UIImage *image = [self hj_fullscreenShot];
        if (image) {
            HJ_KEYWINDOW.hj_fullscreenPopGestureRecognizerView.hj_fullscreenImage = image;
        }
    }
    [self hj_pushViewController:viewController animated:YES];
}

- (UIViewController *)hj_popViewControllerAnimated:(BOOL)animated {
    UIViewController *viewController = [self hj_popViewControllerAnimated:animated];
    // 删除最后一张图片
    [hj_imagesArr removeLastObject];
    // 设置图片
    UIImage *image = hj_imagesArr.lastObject;
    if (image) {
        HJ_KEYWINDOW.hj_fullscreenPopGestureRecognizerView.hj_fullscreenImage = image;
    }
    return viewController;
}

- (NSArray<UIViewController *> *)hj_popToRootViewControllerAnimated:(BOOL)animated {
    NSArray *arr = [self hj_popToRootViewControllerAnimated:animated];
    HJ_KEYWINDOW.hj_fullscreenPopGestureRecognizerView.hj_fullscreenImage = nil;
    // 删除所有的图片
    [hj_imagesArr removeAllObjects];
    return arr;
}

#pragma mark - 动画push/动画pop
- (void)hj_animatedPushViewController:(UIViewController *)viewController {
    // 截图并设置图片
    UIImage *image = [self hj_fullscreenShot];
    if (image) {
        HJ_KEYWINDOW.hj_fullscreenPopGestureRecognizerView.hj_fullscreenImage = image;
    }
    HJ_KEYWINDOW.hj_fullscreenPopGestureRecognizerView.hidden = NO;
    // 平移出窗口
    HJ_ROOTVIEWCONTROLLER.view.transform = CGAffineTransformMakeTranslation(HJ_KEYWINDOW.hj_width, 0);
    HJ_PRESENTEDVIEWCONTROLLER.view.transform = CGAffineTransformMakeTranslation(HJ_KEYWINDOW.hj_width, 0);
    // 控制器跳转
    [self hj_pushViewController:viewController animated:NO];
    // 做动画
    [UIView animateWithDuration:0.25 animations:^{
        // 恢复
        HJ_ROOTVIEWCONTROLLER.view.transform = CGAffineTransformIdentity;
        HJ_PRESENTEDVIEWCONTROLLER.view.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        HJ_KEYWINDOW.hj_fullscreenPopGestureRecognizerView.hidden = YES;
    }];
}

- (UIViewController *)hj_animatedPopViewController {
    __block UIViewController *viewController = nil;
    HJ_KEYWINDOW.hj_fullscreenPopGestureRecognizerView.hidden = NO;
    [UIView animateWithDuration:0.25 animations:^{
        // 平移出窗口
        HJ_ROOTVIEWCONTROLLER.view.transform = CGAffineTransformMakeTranslation(HJ_KEYWINDOW.hj_width, 0);
        HJ_PRESENTEDVIEWCONTROLLER.view.transform = CGAffineTransformMakeTranslation(HJ_KEYWINDOW.hj_width, 0);
    } completion:^(BOOL finished) {
        // 控制器跳转
        viewController = [self popViewControllerAnimated:NO];
        // 恢复
        HJ_ROOTVIEWCONTROLLER.view.transform = CGAffineTransformIdentity;
        HJ_PRESENTEDVIEWCONTROLLER.view.transform = CGAffineTransformIdentity;
        HJ_KEYWINDOW.hj_fullscreenPopGestureRecognizerView.hidden = YES;
    }];
    return viewController;
}

- (NSArray<UIViewController *> *)hj_animatedPopToRootViewController {
    __block NSArray *arr = nil;
    // 设置图片
    UIImage *image = hj_imagesArr.firstObject;
    if (image) {
        HJ_KEYWINDOW.hj_fullscreenPopGestureRecognizerView.hj_fullscreenImage = image;
    }
    
    HJ_KEYWINDOW.hj_fullscreenPopGestureRecognizerView.hidden = NO;
    [UIView animateWithDuration:0.25 animations:^{
        // 平移出窗口
        HJ_ROOTVIEWCONTROLLER.view.transform = CGAffineTransformMakeTranslation(HJ_KEYWINDOW.hj_width, 0);
        HJ_PRESENTEDVIEWCONTROLLER.view.transform = CGAffineTransformMakeTranslation(HJ_KEYWINDOW.hj_width, 0);
    } completion:^(BOOL finished) {
        arr = [self popToRootViewControllerAnimated:NO];
        // 恢复
        HJ_ROOTVIEWCONTROLLER.view.transform = CGAffineTransformIdentity;
        HJ_PRESENTEDVIEWCONTROLLER.view.transform = CGAffineTransformIdentity;
        HJ_KEYWINDOW.hj_fullscreenPopGestureRecognizerView.hidden = YES;
    }];
    return arr;
}

// 截屏
- (UIImage *)hj_fullscreenShot {
    // 开启图片上下文
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(HJ_KEYWINDOW.hj_width, HJ_KEYWINDOW.hj_height), NO, 0);
    [HJ_KEYWINDOW.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    // 关闭图形上下文
    UIGraphicsEndImageContext();
    // 保存图片
    [hj_imagesArr addObject:image];
    return image;
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.view == self.view) {
        if (self.topViewController.hj_fullscreenPopGestureRecognizerEnabled) {
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
