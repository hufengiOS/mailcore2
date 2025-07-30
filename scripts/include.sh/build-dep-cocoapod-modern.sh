#!/bin/sh

build_git_ios()
{
  if test "x$name" = x ; then
    return
  fi

  # 现代架构设置
  simarchs="x86_64 arm64"
  sdkminversion="13.0"
  sdkversion="`xcodebuild -showsdks 2>/dev/null | grep iphoneos | sed 's/.*iphoneos\(.*\)/\1/'`"
  devicearchs="arm64 arm64e"

  versions_path="$scriptpath/deps-versions.plist"
  version="`defaults read "$versions_path" "$name" 2>/dev/null`"
  version="$(($version+1))"
  if test x$build_for_external = x1 ; then
    version=0
  fi

  if test x$build_for_external = x1 ; then
    builddir="$scriptpath/../Externals/tmp/dependencies"
  else
    builddir="$HOME/MailCore-Builds/dependencies"
  fi
  BUILD_TIMESTAMP=`date +'%Y%m%d%H%M%S'`
  tempbuilddir="$builddir/workdir/$BUILD_TIMESTAMP"
  mkdir -p "$tempbuilddir"
  srcdir="$tempbuilddir/src"
  logdir="$tempbuilddir/log"
  resultdir="$builddir/builds"
  tmpdir="$tempbuilddir/tmp"
  

  echo "正在工作目录: $tempbuilddir"

  mkdir -p "$resultdir"
  mkdir -p "$logdir"
  mkdir -p "$tmpdir"
  mkdir -p "$srcdir"

  pushd . >/dev/null

  # 禁用 Bitcode（已弃用）
  XCODE_BITCODE_FLAGS="ENABLE_BITCODE=NO"
  XCTOOL_OTHERFLAGS='$(inherited)'
  
  cd "$TOPDIR/build-mac"
  sdk="iphoneos$sdkversion"
  echo "正在构建 $sdk"
  xcodebuild -project "$xcode_project" -sdk $sdk -scheme "$xcode_target" -configuration Release SYMROOT="$tmpdir/bin" OBJROOT="$tmpdir/obj" ARCHS="$devicearchs" IPHONEOS_DEPLOYMENT_TARGET="$sdkminversion" OTHER_CFLAGS="$XCTOOL_OTHERFLAGS" $XCODE_BITCODE_FLAGS
  if test x$? != x0 ; then
    echo "构建失败"
    exit 1
  fi
  sdk="iphonesimulator$sdkversion"
  echo "正在构建 $sdk"
  xcodebuild -project "$xcode_project" -sdk $sdk -scheme "$xcode_target" -configuration Release SYMROOT="$tmpdir/bin" OBJROOT="$tmpdir/obj" ARCHS="$simarchs" IPHONEOS_DEPLOYMENT_TARGET="$sdkminversion" OTHER_CFLAGS='$(inherited)'
  if test x$? != x0 ; then
    echo "构建失败"
    exit 1
  fi
  echo "构建完成"

  if echo $library|grep '\.framework$'>/dev/null ; then
    cd "$tmpdir/bin/Release"
    defaults write "$tmpdir/bin/Release/$library/Resources/Info.plist" "git-rev" "$rev"
    mkdir -p "$resultdir/$name"
    zip -qry "$resultdir/$name/$name-$version.zip" "$library"
  else
    cd "$tmpdir/bin"
    mkdir -p "$name-$version/$name"
    mkdir -p "$name-$version/$name/lib"
    if test x$build_mailcore = x1 ; then
      mkdir -p "$name-$version/$name/include"
      mv Release-iphoneos/include/MailCore "$name-$version/$name/include"
    else
      mv Release-iphoneos/include "$name-$version/$name"
    fi
    lipo -create "Release-iphoneos/$library" \
      "Release-iphonesimulator/$library" \
        -output "$name-$version/$name/lib/$library"
    for dep in $embedded_deps ; do
      if test -d "$TOPDIR/build-mac/$dep" ; then
        mv "$TOPDIR/build-mac/$dep" "$name-$version"
      elif test -d "$TOPDIR/Externals/$dep" ; then
        mv "$TOPDIR/Externals/$dep" "$name-$version"
      else
        echo "依赖 $dep 未找到"
      fi
      if test x$build_mailcore = x1 ; then
        cp -R "$name-$version/$dep/lib" "$name-$version/$name"
        rm -rf "$name-$version/$dep"
      fi
    done
    if test x$build_mailcore = x1 ; then
      cd "$name-$version"
      zip -qry "$resultdir/$name/$name-$version.zip" "$name"
    else
      cd "$name-$version"
      zip -qry "$resultdir/$name/$name-$version.zip" .
    fi
  fi

  popd >/dev/null

  if test x$build_for_external = x1 ; then
    echo "$resultdir/$name/$name-$version.zip"
  else
    echo "$resultdir/$name/$name-$version.zip"
  fi
} 