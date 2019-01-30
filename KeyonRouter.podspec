
Pod::Spec.new do |s|
  s.name         = "KeyonRouter"
  s.version      = "0.0.5"
  s.summary      = "swift的路由."
  s.description  = <<-DESC
                    自己写的一个swift的路由
                   DESC
  s.homepage     = "https://github.com/616115891/JYRouter"
  s.license      = "MIT"
  s.author       = { "Keyon" => "616115891@qq.com" }
  s.source       = { :git => "https://github.com/616115891/JYRouter.git", :tag => "#{s.version}" }
  s.ios.deployment_target = "10.0"
  s.source_files = "JYRouter/Source"
  s.swift_version = "4.2"
end
