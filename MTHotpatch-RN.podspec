Pod::Spec.new do |s|
    s.name         = "MTHotPatch-RN"
    s.version      = "1.0.0"
    s.ios.deployment_target = '9.0'
    s.summary      = "react-native的热更新工具包"
    s.homepage     = "https://github.com/MrTung/MTHotpatch-RN"
    s.license              = { :type => "MIT", :file => "LICENSE" }
    s.author             = { "Simple" => "287178790@qq.com" }
    s.source       = { :git => "https://github.com/MrTung/MTHotpatch-RN", :tag => s.version }
    #s.source_files  = "HotPatch/*"
    s.resources          = "HotPatch/HotPatch.bundle"
    s.frameworks = 'Foundation'
    s.vendored_frameworks = 'HotPatch.framework'
    s.requires_arc = true
end