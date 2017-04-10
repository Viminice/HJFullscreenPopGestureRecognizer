//
//  UINavigationController+HJFullscreenPopGestureRecognizer.h
//  HJFullscreenPopGestureRecognizer
//
//  Created by Vimin on 2017/3/24.
//  Copyright © 2017年 广州方鼎软件科技发展有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (HJFullscreenPopGestureRecognizer)

/**
 *  动画push
 */
- (void)hj_animatedPushViewController:(UIViewController *)viewController;

/**
 *  动画pop
 */
- (UIViewController *)hj_animatedPopViewController;

/**
 *  动画pop到根控制器
 */
- (NSArray<UIViewController *> *)hj_animatedPopToRootViewController;

/**
 *  动画pop到指定控制器
 */
- (NSArray<UIViewController *> *)hj_animatedPopToViewController:(UIViewController *)viewController;

@end
