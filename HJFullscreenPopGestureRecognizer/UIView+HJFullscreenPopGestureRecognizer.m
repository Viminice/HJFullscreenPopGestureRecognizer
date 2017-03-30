//
//  UIView+HJFullscreenPopGestureRecognizer.m
//  HJFullscreenPopGestureRecognizer
//
//  Created by Vimin on 2017/3/24.
//  Copyright © 2017年 广州方鼎软件科技发展有限公司. All rights reserved.
//

#import "UIView+HJFullscreenPopGestureRecognizer.h"

@implementation UIView (HJFullscreenPopGestureRecognizer)

- (void)setHj_width:(CGFloat)hj_width {
    CGRect frame = self.frame;
    frame.size.width = hj_width;
    self.frame = frame;
}

- (CGFloat)hj_width {
    return self.frame.size.width;
}

- (void)setHj_height:(CGFloat)hj_height {
    CGRect frame = self.frame;
    frame.size.height = hj_height;
    self.frame = frame;
}

- (CGFloat)hj_height {
    return self.frame.size.height;
}

@end
