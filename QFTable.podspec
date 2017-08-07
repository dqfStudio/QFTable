#QFTable.podspec
Pod::Spec.new do |s|
s.name         = "QFTable"
s.version      = "1.0.0"
s.summary      = "easy to use tableView."

s.homepage     = "https://github.com/dqfStudio/QFTable"
s.license      = 'MIT'
s.author       = { "dqf" => "897432098@qq.com" }
s.platform     = :ios, "7.0"
s.ios.deployment_target = "7.0"
s.source       = { :git => "https://github.com/dqfStudio/QFTable.git", :tag => s.version}
s.source_files  = 'QFTable/**/*.{h,m}'
s.requires_arc = true
end
