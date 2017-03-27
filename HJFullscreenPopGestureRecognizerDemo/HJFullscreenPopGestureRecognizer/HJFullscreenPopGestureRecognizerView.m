//
//  HJFullscreenPopGestureRecognizerView.m
//  HJFullscreenPopGestureRecognizer
//
//  Created by Vimin on 2017/3/24.
//  Copyright © 2017年 广州方鼎软件科技发展有限公司. All rights reserved.
//

#import "HJFullscreenPopGestureRecognizerView.h"
#import "UIView+HJFullscreenPopGestureRecognizer.h"

#define HJ_KEYWINDOW [UIApplication sharedApplication].keyWindow
#define HJRGBAColor(r, g, b, a) [UIColor colorWithRed:(r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:(a)]

@interface HJFullscreenPopGestureRecognizerView ()

/** imageV */
@property (weak, nonatomic) UIImageView *imageV;

/** hud */
@property (weak, nonatomic) UIView *hud;

@end

@implementation HJFullscreenPopGestureRecognizerView

- (void)setHj_fullscreenImage:(UIImage *)hj_fullscreenImage {
    _hj_fullscreenImage = hj_fullscreenImage;
    self.imageV.image = hj_fullscreenImage;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 设置背景颜色
        self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
        // 添加子控件
        [self initSubViews];
        // KVO
        [[UIApplication sharedApplication].keyWindow.rootViewController.view addObserver:self forKeyPath:@"transform" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)initSubViews {
    // imageV
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:self.bounds];
    [self addSubview:imageV];
    self.imageV = imageV;
    
    // hud
    UIView *hud = [[UIView alloc] initWithFrame:self.bounds];
    hud.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    [self addSubview:hud];
    self.hud = hud;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    CGAffineTransform transform = [[change valueForKey:NSKeyValueChangeNewKey] CGAffineTransformValue];
    [self hj_showEffectChange:transform.tx];
}

- (void)hj_showEffectChange:(CGFloat)offsetX {
    if (offsetX > 0){
        CGFloat alpha = 0.4 - offsetX / HJ_KEYWINDOW.hj_width * 0.4;
        self.hud.backgroundColor = HJRGBAColor(0, 0, 0, alpha);
        self.imageV.transform = CGAffineTransformMakeScale(0.9 + offsetX / HJ_KEYWINDOW.hj_width * 0.1, 0.9 + offsetX / HJ_KEYWINDOW.hj_width * 0.1);
    }else {
        self.imageV.transform = CGAffineTransformMakeScale(0.9, 0.9);
    }
}

- (void)dealloc {
    [[UIApplication sharedApplication].keyWindow.rootViewController.view removeObserver:self forKeyPath:@"transform"];
}

@end
