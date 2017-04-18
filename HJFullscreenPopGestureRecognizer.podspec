
Pod::Spec.new do |s|

  s.name         = "HJFullscreenPopGestureRecognizer"
  s.version      = "1.1.2"
  s.summary      = "全屏返回手势,类似酷狗音乐的动态push, 动态pop!"
  s.homepage     = "https://github.com/shusheng732/HJFullscreenPopGestureRecognizer"
  s.license      = "MIT"
  s.author       = { "Vimin" => "shusheng732@163.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/shusheng732/HJFullscreenPopGestureRecognizer.git", :tag => s.version }
  s.source_files = "HJFullscreenPopGestureRecognizer", "HJFullscreenPopGestureRecognizer/*.{h,m}"
  s.requires_arc = true

end
