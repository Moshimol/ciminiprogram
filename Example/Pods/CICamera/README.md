# CICamera
>相机图片基础模块封装

>支持拍照/视频/扫码   

>支持多图选择（默认9张）


## 开发工具
* IDE: Xcode 11.3
* 抓包: Charles
* UI调试: Injection For Xcode

## 第三方依赖
* PKShortVideo                                    视频录制
* TZImagePickerController                   相册管理

## 引入
* cocoapod 引入。
* info.plist文件中加入(权限设置必须加入哦，否则引起闪退)
   * Privacy - Camera Usage Description                        访问相机以拍照
   * Privacy - Microphone Usage Description                  访问麦克风以录像
   * Privacy - Location Usage Description                       允许定位以把位置保存到照片中
   * Privacy - Photo Library Usage Description                访问相册以选择照片
   * Privacy - Location When In Use Usage Description  允许定位以把位置保存到照片中
   * Privacy - Photo Library Additions Usage Description 访问相册以把文件保存到照片中
        
## 使用

### 创建
```objc
self.cameraManager = [CICameraManager sharedInstance];
self.galleryManager = [CIGalleryManager sharedInstance];
```

### 扫码
```objc
/* 扫码 */
self.cameraManager.scanCompletionHandler = ^(NSString * _Nonnull result) {
    NSLog(@"扫码结果：%@", result);
};
[self.cameraManager setMode:MODE_SCAN With:self];
```

### 相册选择
```objc
/* 相册选择 */
self.galleryManager.pictureCompleteHandler = ^(NSArray<UIImage *> * _Nonnull photos, NSArray * _Nonnull assets) {
    NSLog(@"相册选择结果：images: %@, assets: %@", photos, assets);
};
[self.galleryManager createAlbum:self];
```

### 拍摄
```objc
/* 拍摄 */
self.cameraManager.pictureCompleteHandler = ^(NSArray<UIImage *> * _Nonnull photos, NSArray * _Nonnull assets) {
    NSLog(@"拍摄结果：images: %@, assets: %@", photos, assets);
};
[self.cameraManager setMode:MODE_PICTURE With:self];
```

### 拍摄小视频
```objc
/* 拍摄小视频 */
[self.cameraManager setMode:MODE_VIDEO With:self];
NSLog(@"视频拍摄结果路径：%@",self.cameraManager.savePathString);

```

详情见[API文档](./CICameraAPI介绍.md)

# CICamera

[![CI Status](https://img.shields.io/travis/sssssunying/CICamera.svg?style=flat)](https://travis-ci.org/sssssunying/CICamera)
[![Version](https://img.shields.io/cocoapods/v/CICamera.svg?style=flat)](https://cocoapods.org/pods/CICamera)
[![License](https://img.shields.io/cocoapods/l/CICamera.svg?style=flat)](https://cocoapods.org/pods/CICamera)
[![Platform](https://img.shields.io/cocoapods/p/CICamera.svg?style=flat)](https://cocoapods.org/pods/CICamera)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

CICamera is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'CICamera', :git => 'https://gitlab.oneitfarm.com/basemodule-ios/cicamera.git'
```

## Author

sssssunying, sunying@corp-ci.com

## License

CICamera is available under the MIT license. See the LICENSE file for more info.
