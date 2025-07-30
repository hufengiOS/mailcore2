Pod::Spec.new do |spec|
  spec.name         = "mailcore2-ios"
  spec.version      = "0.6.5"
  spec.summary      = "Mailcore 2 for iOS with modern architecture support"
  spec.description  = "MailCore 2 提供简单异步的 API 来处理邮件协议 IMAP、POP 和 SMTP。API 已重新设计。此版本支持现代 iOS 架构，包括 arm64 和 arm64e。"
  spec.homepage     = "https://github.com/hufengiOS/mailcore2"
  spec.license      = { :type => "BSD", :file => "LICENSE" }
  spec.author       = "MailCore Authors"
  spec.platform     = :ios, "8.0"
  spec.source       = { :git => "https://github.com/hufengiOS/mailcore2.git", :tag => "#{spec.version}" }
  spec.header_dir   = "MailCore"
  spec.requires_arc = false
  
  # 使用 XCFramework
  spec.vendored_frameworks = "bin/MailCore.xcframework"
  
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
    'ENABLE_BITCODE' => 'NO'
  }
  
  # 用户目标配置
  spec.user_target_xcconfig = {
    'VALID_ARCHS' => 'arm64 arm64e x86_64',
    'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64 arm64',
    'ONLY_ACTIVE_ARCH' => 'NO',
    'ENABLE_BITCODE' => 'NO'
  }
  
  # 准备命令
  spec.prepare_command = <<-CMD
    # 检查并构建 XCFramework
    if [ ! -d "bin/MailCore.xcframework" ]; then
      echo "构建 XCFramework..."
      chmod +x scripts/build-xcframework.sh
      ./scripts/build-xcframework.sh
    fi
    
    # 下载 LICENSE 文件
    curl -O https://github.com/hufengiOS/mailcore2/raw/master/LICENSE
  CMD
end 