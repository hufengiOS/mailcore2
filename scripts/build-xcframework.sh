#!/bin/bash

# MailCore2 XCFramework 构建脚本
# 支持现代 iOS 架构 (arm64, arm64e, x86_64)

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}开始构建 MailCore2 XCFramework...${NC}"

# 检查必要工具
if ! command -v xcodebuild &> /dev/null; then
    echo -e "${RED}错误: 未找到 xcodebuild${NC}"
    exit 1
fi

# 设置变量
PROJECT_NAME="mailcore2"
FRAMEWORK_NAME="MailCore"
BUILD_DIR="build-xcframework"
OUTPUT_DIR="bin"

# 创建构建目录
mkdir -p $BUILD_DIR
mkdir -p $OUTPUT_DIR

# 清理之前的构建
echo -e "${YELLOW}清理之前的构建...${NC}"
rm -rf $BUILD_DIR
rm -rf $OUTPUT_DIR/*.xcframework

# 构建 iOS 设备版本 (arm64, arm64e)
echo -e "${YELLOW}构建 iOS 设备版本...${NC}"
xcodebuild -project build-mac/mailcore2.xcodeproj \
    -scheme "mailcore ios" \
    -configuration Release \
    -sdk iphoneos \
    -arch arm64 \
    -arch arm64e \
    -derivedDataPath $BUILD_DIR/ios-device \
    build

# 构建 iOS 模拟器版本 (x86_64, arm64)
echo -e "${YELLOW}构建 iOS 模拟器版本...${NC}"
xcodebuild -project build-mac/mailcore2.xcodeproj \
    -scheme "mailcore ios" \
    -configuration Release \
    -sdk iphonesimulator \
    -arch x86_64 \
    -arch arm64 \
    -derivedDataPath $BUILD_DIR/ios-simulator \
    build

# 创建 XCFramework
echo -e "${YELLOW}创建 XCFramework...${NC}"
xcodebuild -create-xcframework \
    -framework $BUILD_DIR/ios-device/Build/Products/Release-iphoneos/$FRAMEWORK_NAME.framework \
    -framework $BUILD_DIR/ios-simulator/Build/Products/Release-iphonesimulator/$FRAMEWORK_NAME.framework \
    -output $OUTPUT_DIR/$FRAMEWORK_NAME.xcframework

# 创建压缩包
echo -e "${YELLOW}创建压缩包...${NC}"
cd $OUTPUT_DIR
zip -r $FRAMEWORK_NAME-$(date +%Y-%m-%d).xcframework.zip $FRAMEWORK_NAME.xcframework
cd ..

# 清理构建目录
echo -e "${YELLOW}清理构建目录...${NC}"
rm -rf $BUILD_DIR

echo -e "${GREEN}构建完成！${NC}"
echo -e "${GREEN}XCFramework 位置: $OUTPUT_DIR/$FRAMEWORK_NAME.xcframework${NC}"
echo -e "${GREEN}压缩包位置: $OUTPUT_DIR/$FRAMEWORK_NAME-$(date +%Y-%m-%d).xcframework.zip${NC}"

# 显示支持的架构
echo -e "${YELLOW}支持的架构:${NC}"
lipo -info $OUTPUT_DIR/$FRAMEWORK_NAME.xcframework/ios-arm64/$FRAMEWORK_NAME.framework/$FRAMEWORK_NAME
lipo -info $OUTPUT_DIR/$FRAMEWORK_NAME.xcframework/ios-arm64e/$FRAMEWORK_NAME.framework/$FRAMEWORK_NAME
lipo -info $OUTPUT_DIR/$FRAMEWORK_NAME.xcframework/ios-x86_64-simulator/$FRAMEWORK_NAME.framework/$FRAMEWORK_NAME
lipo -info $OUTPUT_DIR/$FRAMEWORK_NAME.xcframework/ios-arm64-simulator/$FRAMEWORK_NAME.framework/$FRAMEWORK_NAME 