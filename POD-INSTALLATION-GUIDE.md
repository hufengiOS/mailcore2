# MailCore2 iOS Pod 安装指南

## 问题解决方案

由于原始构建脚本使用了过时的架构设置，我们提供了多种解决方案：

### 方案 1：使用简化的 Podspec（推荐）

在您的 `Podfile` 中使用简化的 podspec：

```ruby
platform :ios, '13.0'

target 'YourApp' do
  use_frameworks!
  
  # 使用简化的 podspec
  pod 'mailcore2-ios', :path => 'path/to/mailcore2/cocoapods/mailcore2-ios-simple.podspec'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['VALID_ARCHS'] = 'arm64 arm64e x86_64'
      config.build_settings['VALID_ARCHS[sdk=iphonesimulator*]'] = 'x86_64 arm64'
      config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
      config.build_settings['ENABLE_BITCODE'] = 'NO'
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
    end
  end
end
```

### 方案 2：使用 GitHub 仓库（需要先推送代码）

```ruby
platform :ios, '13.0'

target 'YourApp' do
  use_frameworks!
  
  # 使用 GitHub 仓库
  pod 'mailcore2-ios', :git => 'https://github.com/hufengiOS/mailcore2.git', :branch => 'master'
end
```

### 方案 3：手动构建（如果需要完整功能）

如果您需要完整的 MailCore2 功能，可以手动构建：

```bash
# 1. 克隆仓库
git clone https://github.com/hufengiOS/mailcore2.git
cd mailcore2

# 2. 运行现代构建脚本
chmod +x scripts/build-mailcore2-ios-cocoapod-modern.sh
./scripts/build-mailcore2-ios-cocoapod-modern.sh

# 3. 在您的项目中使用构建结果
```

## 常见问题

### 1. 架构不支持错误

**错误信息**：
```
error: The armv7 architecture is deprecated
error: The armv7s architecture is deprecated
```

**解决方案**：
- 使用 `mailcore2-ios-simple.podspec`
- 确保设置了正确的架构配置

### 2. 部署目标过低

**错误信息**：
```
The iOS deployment target 'IPHONEOS_DEPLOYMENT_TARGET' is set to 7.0, but the range of supported deployment target versions is 12.0 to 18.4.99
```

**解决方案**：
- 将最低 iOS 版本设置为 13.0
- 在 podspec 中设置 `IPHONEOS_DEPLOYMENT_TARGET = '13.0'`

### 3. Bitcode 已弃用

**错误信息**：
```
Ignoring ENABLE_BITCODE because building with bitcode is no longer supported
```

**解决方案**：
- 设置 `ENABLE_BITCODE = 'NO'`
- 使用现代构建脚本

## 推荐配置

### Podfile 完整示例

```ruby
platform :ios, '13.0'

target 'YourApp' do
  use_frameworks!
  
  # 使用简化的 podspec
  pod 'mailcore2-ios', :path => 'path/to/mailcore2/cocoapods/mailcore2-ios-simple.podspec'
  
  # 其他依赖
  pod 'Alamofire', '~> 5.0'
  pod 'SnapKit', '~> 5.0'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      # 架构支持
      config.build_settings['VALID_ARCHS'] = 'arm64 arm64e x86_64'
      config.build_settings['VALID_ARCHS[sdk=iphonesimulator*]'] = 'x86_64 arm64'
      config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
      
      # 禁用 Bitcode
      config.build_settings['ENABLE_BITCODE'] = 'NO'
      
      # 设置部署目标
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
      
      # C++ 设置
      config.build_settings['CLANG_CXX_LANGUAGE_STANDARD'] = 'c++11'
      config.build_settings['CLANG_CXX_LIBRARY'] = 'libc++'
    end
  end
end
```

## 版本信息

- **版本**: 1.0.1
- **最低 iOS 版本**: 13.0
- **支持的架构**: arm64, arm64e, x86_64
- **支持的协议**: IMAP, POP, SMTP, NNTP

## 故障排除

如果仍然遇到问题，请：

1. 清理 Pod 缓存：
```bash
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