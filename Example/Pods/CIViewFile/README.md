## Features
* 打开pdf、word、txt、excel、ppt等常用文档
* 解压zip包预览zip包
# Example
To run the example project, clone the repo, and run pod install from the Example directory first.

## Requirements
* iOS 8.0 or later
* Xcode 10.0 or later
## Installation
CIViewFile is available through CocoaPods. To install it, simply add the following line to your Podfile:
```ruby
## pod 'CIViewFile', :git => 'https://gitlab.oneitfarm.com/basemodule-ios/cifilemanager.git'
```
or
```ruby
source 'https://gitlab.oneitfarm.com/basemodule-ios/civiewfile.git'pod 'CIFileManager'
```
## How To Use
* Objective-C
```objc
#import "CIFileViewHelper.h"//判断是否支持打开    
BOOL res = [CIFileViewHelper canPreviewItem:url];   
if (res) {       
    //传入name和path和rootviewcontroller        
    [CIFileViewHelper showFileWithName:self.nameArr[indexPath.row] path:self.pathArr[indexPath.row] rootViewController:self];    
}else {
    //        不支持则用其他应用打开        
    UIDocumentInteractionController *_documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:url];
    [_documentInteractionController presentOpenInMenuFromRect:CGRectZero inView:self.view animated:YES];
}
```

API Document
如需查看详细API文档，请点击如下链接：

[API文档](https://gitlab.oneitfarm.com/basemodule-ios/civiewfile/blob/master/Example/CIViewFile/CIFileViewHelper.md)

## License
CIFileManager is available under the MIT license. See the LICENSE file for more info.

