# CIWebImage

## Features
* 实现UIImageView，UIButton的分类，用来显示网络图片
* 异步下载图片
* 异步缓存（内存+磁盘），并且自动管理缓存有效性
* 同一个URL不会重复下载，自动识别无效URL
* 下载和缓存过程使用GCD和ARC，不阻塞主线程
* 支持多种图片格式（包括jpeg、png、gif、heic等）

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements
* iOS 8.0 or later
* Xcode 10.0 or later

## Notice
* 如果项目中有其他库依赖SDWebImage，请保持该库依赖版本大于5.0。

## Installation

CIWebImage is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'CIWebImage', :git => 'https://gitlab.oneitfarm.com/basemodule-ios/ciwebimage.git'

```
  or
```ruby
source 'https://gitlab.oneitfarm.com/basemodule-ios/cibasemodulespec.git'
pod 'CIWebImage'

```

## How To Use

* Objective-C

```objc
#import <CIWebImage/CIWebImage.h>
...
[imageView ci_downloadImageWithURL:[NSURL URLWithString:@"http://www.domain.com/path/to/image.jpg"]
             placeholderImage:[UIImage imageNamed:@"placeholder.png"]];

...
//gif使用
[imageView ci_downloadImageWithURL:[NSURL URLWithString:@"https://baby.ci123.com/yunqi/ios2/images/gif/home_right_test.gif"]
          placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
          
...
//Button使用
[btn ci_downloadImageWithURL:[NSURL URLWithString:@"http://www.domain.com/path/to/image.jpg"]
        forState:UIControlStateNormal];
```

## API Document

如需查看详细API文档，请点击如下链接：

[API文档](https://gitlab.oneitfarm.com/basemodule-ios/ciwebimage/blob/master/CIWebImage%20API.md)

## License

CIWebImage is available under the MIT license. See the LICENSE file for more info.
