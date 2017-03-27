//
//  UIViewController+HJFullscreenPopGestureRecognizer.h
//  HJFullscreenPopGestureRecognizer
//
//  Created by Vimin on 2017/3/24.
//  Copyright © 2017年 广州方鼎软件科技发展有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (HJFullscreenPopGestureRecognizer)

/**
 *  全屏返回手势开关, 默认为NO
 */
@property (assign, nonatomic) BOOL hj_fullscreenPopGestureRecognizerEnabled;

@end
