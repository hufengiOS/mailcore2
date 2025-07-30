# MailCore2 iOS 现代架构支持

## 问题描述

原始的 MailCore2 项目在 iOS 配置中明确排除了 `arm64` 架构，这会导致在现代 iOS 设备（特别是 iPhone 12 及以后的设备）上出现架构不支持的错误。

## 解决方案

我们已经更新了 MailCore2 项目以支持现代 iOS 架构：

### 1. 更新的 Podspec 文件

创建了两个新的 podspec 文件：

- `cocoapods/mailcore2-ios.podspec` - 更新了架构支持配置
- `cocoapods/mailcore2-ios-xcframework.podspec` - 使用 XCFramework 的现代版本
- `cocoapods/mailcore2-ios-simple.podspec` - 简化的现代版本

### 2. XCFramework 构建脚本

创建了 `scripts/build-xcframework.sh` 脚本来构建支持现代架构的 XCFramework。

### 3. Swift 包装器

创建了 `src/swift/MailCoreSwift.swift` 来提供更好的 Swift 集成体验。

### 4. 现代构建脚本

创建了 `scripts/build-mailcore2-ios-cocoapod-modern.sh` 来解决过时架构问题。

## 使用方法

### 方法 1: 使用 CocoaPods

1. 在您的 `Podfile` 中添加：

```ruby
platform :ios, '13.0'

target 'YourApp' do
  use_frameworks!
  
  # 使用本地 podspec 文件
  pod 'mailcore2-ios', :path => 'path/to/mailcore2/cocoapods/mailcore2-ios-xcframework.podspec'
end

post_install do |installer|
  installer.pods_project.targets.each do |config|
    target.build_configurations.each do |config|
      config.build_settings['VALID_ARCHS'] = 'arm64 arm64e x86_64'
      config.build_settings['VALID_ARCHS[sdk=iphonesimulator*]'] = 'x86_64 arm64'
      config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
      config.build_settings['ENABLE_BITCODE'] = 'NO'
    end
  end
end
```

2. 运行安装：

```bash
pod install
```

### 方法 2: 手动构建 XCFramework

1. 运行构建脚本：

```bash
chmod +x scripts/build-xcframework.sh
./scripts/build-xcframework.sh
```

2. 将生成的 `bin/MailCore.xcframework` 添加到您的项目中。

## Swift 使用示例

```swift
import MailCore

class EmailManager {
    private let imapSession = MCOIMAPSession()
    private let smtpSession = MCOSMTPSession()
    
    func connectIMAP() {
        imapSession.connectSwift(
            hostname: "imap.gmail.com",
            port: 993,
            username: "your-email@gmail.com",
            password: "your-password"
        ) { error in
            if let error = error {
                print("IMAP 连接失败: \(error)")
            } else {
                print("IMAP 连接成功！")
            }
        }
    }
    
    func sendEmail() {
        let messageData = MCOMessageBuilder.createSimpleMessage(
            from: "sender@example.com",
            to: "recipient@example.com",
            subject: "测试邮件",
            body: "这是一封测试邮件"
        )
        
        smtpSession.sendMessageSwift(messageData: messageData) { error in
            if let error = error {
                print("发送失败: \(error)")
            } else {
                print("发送成功！")
            }
        }
    }
}
```

## 支持的架构

- **设备**: `arm64`, `arm64e`
- **模拟器**: `x86_64`, `arm64`

## 版本信息

- **MailCore2 版本**: 1.0.1
- **支持的协议**: IMAP, POP, SMTP, NNTP
- **最低 iOS 版本**: 13.0

## 注意事项

1. **Bitcode**: 已禁用 Bitcode 以确保兼容性
2. **C++ 标准**: 使用 C++11 标准
3. **架构支持**: 支持所有现代 iOS 架构
4. **Swift 集成**: 提供完整的 Swift 包装器

## 故障排除

### 常见错误

1. **架构不支持错误**:
   - 确保在 Podfile 中设置了正确的架构配置
   - 检查 `VALID_ARCHS` 设置
   - 使用简化的 podspec 文件

2. **编译错误**:
   - 确保使用 C++11 标准
   - 检查 `CLANG_CXX_LIBRARY` 设置为 `libc++`
   - 确保最低 iOS 版本为 13.0

3. **链接错误**:
   - 确保添加了必要的系统库
   - 检查 `OTHER_LDFLAGS` 设置
   - 禁用 Bitcode

### 调试步骤

1. 清理项目：
```bash
pod deintegrate
pod cache clean --all
rm -rf Pods
rm -rf Podfile.lock
```

2. 重新安装：
```bash
pod install
```

3. 检查架构支持：
```bash
lipo -info YourApp.app/YourApp
```

## 推荐使用方式

为了获得最佳体验，推荐使用简化的 podspec：

```ruby
pod 'mailcore2-ios', :path => 'path/to/mailcore2/cocoapods/mailcore2-ios-simple.podspec'
```

## 贡献

如果您遇到任何问题或有改进建议，请：

1. 检查现有的 Issues
2. 创建新的 Issue 并提供详细信息
3. 提交 Pull Request

## 许可证

本项目基于 BSD 许可证。详见 `LICENSE` 文件。 