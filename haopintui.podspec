# coding: utf-8
Pod::Spec.new do |s|
  s.name         = "haopintui"
  s.version      = "1.0.0"
  s.summary      = "haopintui Source ."
  s.homepage     = 'https://github.com/shaibaoj/haopintui-plugin-ios-baichuan'
  s.license      = "MIT"
  s.authors      = { "xionghuayu" => "987939309@qq.com" }
  s.platform     = :ios
  s.ios.deployment_target = "8.0"
  s.source = { :git => 'https://github.com/shaibaoj/haopintui-plugin-ios-baichuan.git', :tag => s.version.to_s }

  s.source_files = "Source/*.{h,m,mm}"
  s.requires_arc = true
  #s.dependency 'UMCShare/Social/ReducedWeChat', '6.9.1'
  #s.dependency 'WechatOpenSDK', '1.8.2'
  
end
