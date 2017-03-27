# HJFullscreenPopGestureRecognizer

+ 类似酷狗音乐, 斗鱼TV的全屏返回手势, push动效, pop动效

![image](https://raw.githubusercontent.com/shusheng732/HJFullscreenPopGestureRecognizer/0.0.2/images/fullscreenPop.gif)

![image](https://github.com/shusheng732/HJFullscreenPopGestureRecognizer/blob/0.0.2/images/animatedPop.gif?raw=true)

![image](https://raw.githubusercontent.com/shusheng732/HJFullscreenPopGestureRecognizer/0.0.2/images/animatedPush.gif)

# How to use
+ 安装
+ Installation with CocoaPods:
```ruby
pod 'HJFullscreenPopGestureRecognizer'
```
+ Manual import:
    + Drag All files in the HJFullscreenPopGestureRecognizer folder to project
    + Import the main file：``` #import "HJFullscreenPopGestureRecognizer.h"```

+ 1.全屏返回手势
```objc
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.hj_fullscreenPopGestureRecognizerEnabled = YES;
}
```

+ 2.动画push
```objc
[self.navigationController hj_animatedPushViewController:viewController];
```

+ 3.动画pop
```objc
[self.navigationController hj_animatedPopViewController];
```

# Over. it's just so easy!
