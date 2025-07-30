Pod::Spec.new do |spec|
  spec.name         = "mailcore2-ios"
  spec.version      = "1.0.1"
  spec.summary      = "Mailcore 2 for iOS with modern architecture support"
  spec.description  = "MailCore 2 提供简单异步的 API 来处理邮件协议 IMAP、POP 和 SMTP。API 已重新设计。此版本支持现代 iOS 架构，包括 arm64 和 arm64e。"
  spec.homepage     = "https://github.com/hufengiOS/mailcore2"
  spec.license      = { :type => "BSD", :file => "LICENSE" }
  spec.author       = "MailCore Authors"
  spec.platform     = :ios, "13.0"
  spec.source       = { :git => "https://github.com/hufengiOS/mailcore2.git", :branch => "master" }
  spec.header_dir   = "MailCore"
  spec.requires_arc = false
  
  # 头文件
  spec.source_files = "src/objc/**/*.h"
  spec.public_header_files = "src/objc/**/*.h"
  spec.preserve_paths = "src/objc/**/*.h"
  
  # 依赖库
  spec.libraries = ["xml2", "iconv", "z", "c++", "resolv"]
  
  # 架构支持配置
  spec.pod_target_xcconfig = {
    'VALID_ARCHS' => 'arm64 arm64e x86_64',
    'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64 arm64',
    'ONLY_ACTIVE_ARCH' => 'NO',
    'ENABLE_BITCODE' => 'NO',
    'IPHONEOS_DEPLOYMENT_TARGET' => '13.0'
  }
  
  # 用户目标配置
  spec.user_target_xcconfig = {
    'VALID_ARCHS' => 'arm64 arm64e x86_64',
    'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64 arm64',
    'ONLY_ACTIVE_ARCH' => 'NO',
    'ENABLE_BITCODE' => 'NO',
    'IPHONEOS_DEPLOYMENT_TARGET' => '13.0'
  }
  
  # 准备命令 - 简化版本
  spec.prepare_command = <<-CMD
    echo "MailCore2 iOS 1.0.1 准备完成"
    echo "支持的架构: arm64, arm64e, x86_64"
    echo "最低 iOS 版本: 13.0"
    echo "构建配置已优化为现代 iOS 架构"
  CMD
end 